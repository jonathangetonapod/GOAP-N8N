# Deploy n8n to Railway - Correct Method

Railway deployment for n8n works best using the **Railway Dashboard** rather than CLI deployment with a Dockerfile.

## Step-by-Step Deployment

### 1. Create New Railway Project

1. Go to https://railway.app/new
2. Click "Empty Project"

### 2. Add PostgreSQL Database

1. Click "+ New" in your project
2. Select "Database" → "Add PostgreSQL"
3. Railway will create a PostgreSQL instance

### 3. Add n8n Service from Docker Image

1. Click "+ New" in your project
2. Select "Docker Image"
3. Enter the image: `n8nio/n8n:latest`
4. Click "Deploy"

### 4. Configure n8n Environment Variables

Click on your n8n service, go to "Variables" tab, and add these:

#### Required Variables:

```
N8N_PORT=5678
NODE_ENV=production
GENERIC_TIMEZONE=America/New_York
```

#### Database Connection (Reference your Postgres service):

```
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=${{Postgres.PGHOST}}
DB_POSTGRESDB_PORT=${{Postgres.PGPORT}}
DB_POSTGRESDB_DATABASE=${{Postgres.PGDATABASE}}
DB_POSTGRESDB_USER=${{Postgres.PGUSER}}
DB_POSTGRESDB_PASSWORD=${{Postgres.PGPASSWORD}}
```

#### Security:

Generate encryption key first:
```bash
openssl rand -base64 32
```

Then add:
```
N8N_ENCRYPTION_KEY=<your-generated-key>
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=<your-password>
```

### 5. Generate Public Domain

1. Go to your n8n service settings
2. Click on "Settings" tab
3. Scroll to "Networking"
4. Click "Generate Domain"
5. Copy your domain (e.g., `your-app.up.railway.app`)

### 6. Update Domain Variables

Add these variables to your n8n service (use your actual domain from step 5):

```
N8N_HOST=your-app.up.railway.app
N8N_PROTOCOL=https
WEBHOOK_URL=https://your-app.up.railway.app/
```

### 7. Access Your n8n Instance

1. Wait for the deployment to complete (check "Deployments" tab)
2. Go to your domain: `https://your-app.up.railway.app`
3. Login with your `N8N_BASIC_AUTH_USER` and `N8N_BASIC_AUTH_PASSWORD`

## Using Railway CLI (Alternative)

If you prefer using the CLI, here's how to set it up properly:

### 1. Link or Create Project

```bash
# Login first
railway login

# Create new project or link existing
railway init
# OR
railway link
```

### 2. Add Database

```bash
railway add --database postgres
```

### 3. Add n8n Service from Docker Image

You need to do this in the Railway dashboard:
1. Go to your project at https://railway.app/
2. Click "+ New" → "Docker Image"
3. Enter: `n8nio/n8n:latest`

### 4. Set Environment Variables

```bash
# Generate encryption key
openssl rand -base64 32

# Set variables (replace with your values)
railway variables --set "N8N_PORT=5678" --set "NODE_ENV=production" --set "GENERIC_TIMEZONE=America/New_York"

railway variables --set "N8N_ENCRYPTION_KEY=<your-generated-key>"
railway variables --set "N8N_BASIC_AUTH_ACTIVE=true"
railway variables --set "N8N_BASIC_AUTH_USER=admin"
railway variables --set "N8N_BASIC_AUTH_PASSWORD=<your-password>"

# Database variables
railway variables --set "DB_TYPE=postgresdb"
railway variables --set "DB_POSTGRESDB_HOST=\${{Postgres.PGHOST}}"
railway variables --set "DB_POSTGRESDB_PORT=\${{Postgres.PGPORT}}"
railway variables --set "DB_POSTGRESDB_DATABASE=\${{Postgres.PGDATABASE}}"
railway variables --set "DB_POSTGRESDB_USER=\${{Postgres.PGUSER}}"
railway variables --set "DB_POSTGRESDB_PASSWORD=\${{Postgres.PGPASSWORD}}"
```

### 5. Generate Domain

```bash
railway domain
```

If no domain exists:
```bash
railway domain --generate
```

### 6. Update Domain Variables

Replace `your-app.up.railway.app` with your actual domain:

```bash
railway variables --set "N8N_HOST=your-app.up.railway.app"
railway variables --set "N8N_PROTOCOL=https"
railway variables --set "WEBHOOK_URL=https://your-app.up.railway.app/"
```

## Troubleshooting

### Service Won't Start
- Check logs in Railway dashboard under "Deployments" → "View Logs"
- Verify all environment variables are set correctly
- Make sure database service is running

### Can't Connect to Database
- Verify the database reference variables are correct (`${{Postgres.PGHOST}}` etc.)
- Check that both services are in the same project

### Webhooks Not Working
- Ensure `WEBHOOK_URL` matches your Railway domain exactly
- Must include `https://` and trailing `/`

## Important Notes

- **Don't use a custom Dockerfile** - Railway works best with the official n8n Docker image
- **Database is required** - n8n needs PostgreSQL for production use
- **Keep encryption key safe** - You'll need it to decrypt credentials
- **Domain must be generated** - Required for webhooks and proper URL handling

## Resources

- [n8n Documentation](https://docs.n8n.io/)
- [Railway Documentation](https://docs.railway.app/)
- [n8n Docker Hub](https://hub.docker.com/r/n8nio/n8n)
