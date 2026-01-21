# Railway CLI Deployment Guide

## Step 1: Login to Railway

Run this command in your terminal (it will open a browser):

```bash
railway login
```

This will open your browser to authenticate with Railway. Once completed, return to the terminal.

## Step 2: Link to Existing Project or Create New

### Option A: Create a New Project

```bash
railway init
```

This will create a new Railway project and link it to this directory.

### Option B: Link to Existing Project

If you already created a project via the Railway dashboard:

```bash
railway link
```

Select your project from the list.

## Step 3: Add PostgreSQL Database

```bash
railway add --database postgres
```

This creates a PostgreSQL database in your Railway project.

## Step 4: Set Environment Variables

Generate an encryption key first:

```bash
openssl rand -base64 32
```

Copy the output and use it in the next commands:

```bash
# Set encryption key (use the output from above)
railway variables set N8N_ENCRYPTION_KEY="your-generated-key-here"

# Set basic auth credentials
railway variables set N8N_BASIC_AUTH_ACTIVE=true
railway variables set N8N_BASIC_AUTH_USER=admin
railway variables set N8N_BASIC_AUTH_PASSWORD="your-secure-password"

# Set timezone
railway variables set GENERIC_TIMEZONE="America/New_York"
```

## Step 5: Deploy

```bash
railway up
```

This will build and deploy your n8n instance to Railway.

## Step 6: Get Your Domain

After deployment, run:

```bash
railway domain
```

This will show you your Railway domain. If you don't have one yet, create it:

```bash
railway domain --generate
```

## Step 7: Update Domain Variables

Once you have your domain (e.g., `your-app.up.railway.app`), set these variables:

```bash
railway variables set N8N_HOST="your-app.up.railway.app"
railway variables set N8N_PROTOCOL=https
railway variables set WEBHOOK_URL="https://your-app.up.railway.app/"
```

## Step 8: Set Database Connection Variables

The database variables are automatically available. Add them to your service:

```bash
railway variables set DB_POSTGRESDB_HOST='${{Postgres.PGHOST}}'
railway variables set DB_POSTGRESDB_PORT='${{Postgres.PGPORT}}'
railway variables set DB_POSTGRESDB_DATABASE='${{Postgres.PGDATABASE}}'
railway variables set DB_POSTGRESDB_USER='${{Postgres.PGUSER}}'
railway variables set DB_POSTGRESDB_PASSWORD='${{Postgres.PGPASSWORD}}'
```

Note: Railway will automatically resolve these `${{...}}` references to the actual values.

## Useful Commands

### View logs
```bash
railway logs
```

### View all variables
```bash
railway variables
```

### Open project in browser
```bash
railway open
```

### Redeploy
```bash
railway up
```

### Check status
```bash
railway status
```

## Troubleshooting

- **Build fails**: Check logs with `railway logs`
- **Database connection issues**: Verify database variables are set correctly with `railway variables`
- **Can't access n8n**: Make sure domain is generated and domain variables are set

## Alternative: Deploy from GitHub

If you prefer to deploy from your GitHub repository:

1. Go to https://railway.app/
2. Create "New Project" → "Deploy from GitHub repo"
3. Select `jonathangetonapod/GOAP-N8N`
4. Follow steps 3-8 above using the Railway dashboard instead
