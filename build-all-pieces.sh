#!/bin/bash

# Mudar para o diretório do projeto
cd /Users/arthurhaliski/Documents/activepieces/activepieces

# Lista de todos os pieces para build
pieces=(
  "activecampaign" "activepieces" "actualbudget" "acumbamail" "afforai" "aianswer" "airtable"
  "amazon-s3" "amazon-sns" "amazon-sqs" "aminos" "apify" "apitable" "apollo" "approval" "asana"
  "ashby" "assemblyai" "azure-communication-services" "azure-openai" "bamboohr" "bannerbear"
  "baserow" "beamer" "bettermode" "binance" "bonjoro" "box" "brilliant-directories" "bubble"
  "cal-com" "calendly" "captain-data" "cartloom" "certopus" "chargekeep" "clarifai" "claude"
  "clearout" "clickup" "clockodo" "common" "confluence" "connections" "constant-contact"
  "contentful" "contiguity" "convertkit" "crypto" "csv" "customer-io" "data-mapper"
  "data-summarizer" "date-helper" "datocms" "deepl" "deepseek" "delay" "discord" "discourse"
  "drip" "dropbox" "dust" "elevenlabs" "facebook-leads" "facebook-pages" "figma" "file-helper"
  "fliqr-ai" "flowise" "flowlu" "formbricks" "forms" "frame" "framework" "freshdesk"
  "freshsales" "gameball" "gcloud-pubsub" "generatebanners" "ghostcms" "gistly" "github"
  "gitlab" "gmail" "google-calendar" "google-contacts" "google-docs" "google-drive"
  "google-forms" "google-gemini" "google-my-business" "google-search-console" "google-sheets"
  "google-tasks" "gotify" "graphql" "gravityforms" "grist" "groq" "hackernews" "harvest"
  "heartbeat" "http" "hubspot" "image-ai" "image-helper" "imap" "instagram-business"
  "instasent" "intercom" "invoiceninja" "jira-cloud" "jotform" "json" "kallabot-ai" "kimai"
  "kizeo-forms" "krisp-call" "lead-connector" "lever" "line" "linear" "linka" "linkedin"
  "llmrails" "localai" "mailchimp" "mailer-lite" "maileroo" "mailjet" "mastodon"
  "math-helper" "matomo" "matrix" "mattermost" "mautic" "messagebird" "metabase"
  "microsoft-dynamics-365-business-central" "microsoft-dynamics-crm" "microsoft-excel-365"
  "microsoft-onedrive" "microsoft-outlook-calendar" "microsoft-sharepoint" "microsoft-teams"
  "mindee" "mixpanel" "monday" "moxie-crm" "mysql" "nifty" "nocodb" "notion" "ntfy" "odoo"
  "onfleet" "open-router" "openai" "pastebin" "pastefy" "pdf" "perplexity-ai" "photoroom"
  "pipedrive" "poper" "postgres" "posthog" "pushover" "pylon" "qdrant" "qrcode" "queue"
  "quickzu" "rabbitmq" "razorpay" "reachinbox" "reoon-verifier" "resend" "retable" "retune"
  "robolly" "rss" "saastic" "salesforce" "scenario" "schedule" "scrapegrapghai" "segment"
  "sendfox" "sendgrid" "sendinblue" "sendy" "sessions-us" "seven" "sftp" "shopify"
  "simplepdf" "slack" "smaily" "smtp" "snowflake" "soap" "sperse" "spotify" "square"
  "stability-ai" "stable-diffusion-webui" "store" "straico" "stripe" "subflows" "supabase"
  "supadata" "surrealdb" "surveymonkey" "tags" "talkable" "tally" "taskade" "tavily"
  "telegram-bot" "text-ai" "text-helper" "tidycal" "todoist" "totalcms" "trello" "twilio"
  "twin-labs" "twitter" "typeform" "upgradechat" "utility-ai" "vbout" "village" "vtex"
  "vtiger" "webflow" "webhook" "webling" "wedof" "whatsable" "whatsapp" "woocommerce"
  "wootric" "wordpress" "xero" "xml" "youtube" "zendesk" "zerobounce" "zoho-books"
  "zoho-crm" "zoho-invoice" "zoom" "zuora"
)

# Construir cada piece
for piece in "${pieces[@]}"; do
  echo "Building pieces-$piece..."
  npx nx build "pieces-$piece"
done

echo "Build de todos os pieces completado!" 