import {createPiece} from '../../framework/piece';
import { insertRowAction } from './actions/insert-row.action';

export const googleSheets = createPiece({
	name: 'google_sheets',
	logoUrl: 'https://cdn.activepieces.com/pieces/google_sheets.png',
	actions: [insertRowAction],
    displayName:"Google Sheets",
	triggers: [],
});