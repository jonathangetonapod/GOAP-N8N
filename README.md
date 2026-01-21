# n8n Deployment on Railway

This repository contains the configuration files needed to deploy n8n on Railway.

## Prerequisites

- A Railway account (sign up at https://railway.app/)
- Railway CLI installed (optional, for command-line deployment)

## Deployment Steps

### Option 1: Deploy via Railway Dashboard (Recommended)

1. **Create a New Project on Railway**
   - Go to https://railway.app/
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Connect your GitHub account and select this repository

2. **Add PostgreSQL Database**
   - In your Railway project, click "New"
   - Select "Database" → "Add PostgreSQL"
   - Railway will automatically create a PostgreSQL instance

3. **Configure Environment Variables**
   - Click on your n8n service
   - Go to "Variables" tab
   - Add the following variables:

   ```
   N8N_HOST=your-app-name.up.railway.app
   N8N_PROTOCOL=https
   WEBHOOK_URL=https://your-app-name.up.railway.app/
   GENERIC_TIMEZONE=America/New_York
   N8N_ENCRYPTION_KEY=<generate-random-string>
   N8N_BASIC_AUTH_ACTIVE=true
   N8N_BASIC_AUTH_USER=admin
   N8N_BASIC_AUTH_PASSWORD=<your-secure-password>
   ```

4. **Link Database to n8n Service**
   - Railway will provide database connection variables
   - Reference them in your n8n service:

   ```
   DB_POSTGRESDB_HOST=${{Postgres.PGHOST}}
   DB_POSTGRESDB_PORT=${{Postgres.PGPORT}}
   DB_POSTGRESDB_DATABASE=${{Postgres.PGDATABASE}}
   DB_POSTGRESDB_USER=${{Postgres.PGUSER}}
   DB_POSTGRESDB_PASSWORD=${{Postgres.PGPASSWORD}}
   ```

5. **Deploy**
   - Railway will automatically deploy your n8n instance
   - Once deployed, you'll get a public URL (e.g., `your-app-name.up.railway.app`)

### Option 2: Deploy via Railway CLI

1. **Install Railway CLI**
   ```bash
   npm install -g @railway/cli
   ```

2. **Login to Railway**
   ```bash
   railway login
   ```

3. **Initialize Project**
   ```bash
   railway init
   ```

4. **Add PostgreSQL**
   ```bash
   railway add --database postgres
   ```

5. **Set Environment Variables**
   ```bash
   railway variables --set "N8N_HOST=your-app-name.up.railway.app"
   railway variables --set "N8N_PROTOCOL=https"
   railway variables --set "WEBHOOK_URL=https://your-app-name.up.railway.app/"
   railway variables --set "N8N_ENCRYPTION_KEY=$(openssl rand -base64 32)"
   railway variables --set "N8N_BASIC_AUTH_ACTIVE=true"
   railway variables --set "N8N_BASIC_AUTH_USER=admin"
   railway variables --set "N8N_BASIC_AUTH_PASSWORD=your-password"
   ```

6. **Deploy**
   ```bash
   railway up
   ```

## Generate Encryption Key

To generate a secure encryption key, run:

```bash
openssl rand -base64 32
```

## Access Your n8n Instance

After deployment:

1. Go to your Railway dashboard
2. Click on your n8n service
3. Click on "Settings" → "Networking"
4. Copy the public domain (e.g., `your-app-name.up.railway.app`)
5. Open it in your browser
6. Login with the credentials you set in `N8N_BASIC_AUTH_USER` and `N8N_BASIC_AUTH_PASSWORD`

## Important Notes

- **Encryption Key**: Keep your `N8N_ENCRYPTION_KEY` safe. If you lose it, you won't be able to decrypt your credentials.
- **Basic Auth**: Once you set up your first user account in n8n, you can disable basic auth by setting `N8N_BASIC_AUTH_ACTIVE=false`.
- **Persistent Storage**: Railway provides persistent volumes automatically. Your workflows and data are stored in the PostgreSQL database.
- **Webhooks**: Make sure to update `N8N_HOST` and `WEBHOOK_URL` with your actual Railway domain.

## Local Development

To test locally using docker-compose:

1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```

2. Update the environment variables in `.env` with your local settings

3. Run docker-compose:
   ```bash
   docker-compose up
   ```

4. Access n8n at http://localhost:5678

## Troubleshooting

- **Cannot connect to database**: Ensure the PostgreSQL service is running and the connection variables are correctly referenced.
- **Webhooks not working**: Check that `WEBHOOK_URL` matches your Railway domain exactly.
- **n8n won't start**: Check the logs in Railway dashboard under "Deployments" → "View Logs".

## Resources

- [n8n Documentation](https://docs.n8n.io/)
- [Railway Documentation](https://docs.railway.app/)
- [n8n Docker Image](https://hub.docker.com/r/n8nio/n8n)
