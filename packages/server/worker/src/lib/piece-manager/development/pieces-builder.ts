import { spawn } from 'child_process'
import { Server } from 'http'
import { resolve } from 'path'
import { ApLock, filePiecesUtils, memoryLock, PiecesSource } from '@activepieces/server-shared'
import { debounce, isNil, WebsocketClientEvent } from '@activepieces/shared'
import chalk from 'chalk'
import chokidar from 'chokidar'
import { FastifyBaseLogger, FastifyInstance } from 'fastify'

export const PIECES_BUILDER_MUTEX_KEY = 'pieces-builder'

async function handleFileChange(packages: string[], pieceProjectName: string, piecePackageName: string, io: Server, log: FastifyBaseLogger): Promise<void> {
    log.info(
        chalk.blueBright.bold(
            '👀 Detected changes in pieces. Waiting... 👀 ' + pieceProjectName,
        ),
    )
    let lock: ApLock | undefined
    try {
        lock = await memoryLock.acquire(PIECES_BUILDER_MUTEX_KEY)

        log.info(chalk.blue.bold('🤌 Building pieces... 🤌'))
        if (!/^[A-Za-z0-9-]+$/.test(pieceProjectName)) {
            throw new Error(`Piece package name contains invalid character: ${pieceProjectName}`)
        }
        const cmd = `npx nx run-many -t build --projects=${pieceProjectName}`
        await runCommandWithLiveOutput(cmd)
        await filePiecesUtils(packages, log).clearPieceCache(piecePackageName)
        io.emit(WebsocketClientEvent.REFRESH_PIECE)
    }
    catch (error) {
        log.info(error, chalk.red.bold('Failed to run build process...'))
    }
    finally {
        if (lock) {
            await lock.release()
        }
        log.info(
            chalk.green.bold(
                '✨ Changes are ready! Please refresh the frontend to see the new updates. ✨',
            ),
        )
    }
}

async function runCommandWithLiveOutput(cmd: string): Promise<void> {
    const [command, ...args] = cmd.split(' ')

    return new Promise<void>((resolve, reject) => {
        const child = spawn(command, args, { stdio: 'inherit', shell: true })

        child.on('error', reject)
        child.on('close', code => {
            if (code === 0) {
                resolve()
            }
            else {
                reject(new Error(`Process exited with code ${code}`))
            }
        })
    })
}

export async function piecesBuilder(app: FastifyInstance, io: Server, packages: string[], piecesSource: PiecesSource): Promise<void> {

    const isFilePieces = piecesSource === PiecesSource.FILE
    // Only run this script if the pieces source is file
    if (!isFilePieces) return

    const watchers: chokidar.FSWatcher[] = []

    // Watch the entire community pieces directory
    const communityPiecesDir = resolve(__dirname, '../../../../../pieces/community')
    app.log.info(chalk.blue(`Starting watch for all pieces in: ${communityPiecesDir}`))

    const watcher = chokidar.watch(communityPiecesDir, {
        ignored: [/^\./, /node_modules/, /dist/],
        persistent: true,
        ignoreInitial: true,
        awaitWriteFinish: {
            stabilityThreshold: 2000,
            pollInterval: 200,
        },
    })

    watcher.on('ready', () => {
        app.log.info(chalk.green('Initial scan complete. Ready for changes'))
    })

    watcher.on('all', (event, path) => {
        if (path.endsWith('.ts') || path.endsWith('package.json')) {
            const pieceDir = path.split('/pieces/community/')[1]?.split('/')[0]
            if (pieceDir) {
                const pieceProjectName = `pieces-${pieceDir}`
                const packageJsonName = `@activepieces/piece-${pieceDir}`
                handleFileChange(packages, pieceProjectName, packageJsonName, io, app.log).catch(app.log.error)
            }
        }
    })

    watchers.push(watcher)

    app.addHook('onClose', () => {
        for (const watcher of watchers) {
            watcher.close().catch(app.log.error)
        }
    })
}
