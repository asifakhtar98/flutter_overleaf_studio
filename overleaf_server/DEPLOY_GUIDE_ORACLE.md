# 🚀 Production Deploy Guide — Overleaf Server

> Step-by-step guide to deploy the Overleaf Server on Oracle Cloud Free Tier (ARM64).

> [!IMPORTANT]
> Replace all occurrences of `YOUR_ORACLE_IP`, `YOUR_USERNAME`, `YOUR_DOCKERHUB_USERNAME`, and `YOUR_API_KEY` with your actual values before running any command.

---

## Prerequisites Checklist

| # | Item | Status |
|---|------|--------|
| 1 | Oracle Cloud account (free tier) | ❓ |
| 2 | GitHub account + repo created | ❓ |
| 3 | Docker Hub account (free) | ❓ |
| 4 | SSH key pair (`ed25519`) | ❓ |
| 5 | Local machine with Docker installed | ❓ |

---

## Step 1: Provision Oracle Cloud VM

### 1.1 Create VM Instance

1. Login to [Oracle Cloud Console](https://cloud.oracle.com)
2. Navigate to **Compute → Instances → Create Instance**
3. Configure:

| Setting | Value |
|---------|-------|
| **Name: `overleaf-server`` |
| **Image** | Ubuntu 22.04 (Canonical) |
| **Shape** | `VM.Standard.A1.Flex` |
| **OCPUs** | 4 |
| **Memory** | 24 GB |
| **Boot volume** | 100 GB (free tier allows up to 200 GB total) |
| **Network** | Create new VCN or use default |

4. Upload your SSH public key (or paste it)
5. Click **Create**

> [!WARNING]
> Oracle Free Tier A1.Flex instances are in high demand. If you get a "capacity" error, keep trying every few minutes, try a different availability domain, or switch regions.

### 1.2 Configure Network Security

In Oracle Cloud Console:

1. Navigate to **Networking → Virtual Cloud Networks → your VCN**
2. Click on the **Default Security List**
3. **Add Ingress Rule**:

| Setting | Value |
|---------|-------|
| Source CIDR | `0.0.0.0/0` |
| Protocol | TCP |
| Destination Port | `8080` |

4. Save

### 1.3 Note Your Public IP

Copy the public IP from your instance details. You'll need it for:
- SSH access
- GitHub secrets
- API access

---

## Step 2: Initial Server Setup

SSH into your VM:

```bash
ssh -i ~/.ssh/your_key ubuntu@YOUR_ORACLE_IP
```

Run the setup script:

```bash
# Option A: Run from repo (if repo is public)
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/overleaf-server/main/scripts/server-setup.sh | bash

# Option B: Copy and run manually
# (paste contents of scripts/server-setup.sh and run)
```

**What the script does:**
- ✅ Updates system packages
- ✅ Installs Docker CE (ARM64)
- ✅ Adds user to docker group
- ✅ Configures UFW firewall (ports 22, 8080)
- ✅ Configures Oracle Cloud iptables rules
- ✅ Creates `~/overleaf-server/` directory with `.env` template
- ✅ Sets up Docker log rotation

**After the script:**

```bash
# Log out and back in for Docker group membership
exit
ssh -i ~/.ssh/your_key ubuntu@YOUR_ORACLE_IP

# Verify Docker works
docker run --rm hello-world
```

---

## Step 3: Configure Production Environment

Edit the environment file on the VM:

```bash
nano ~/overleaf-server/.env
```

**Critical values to change:**

```bash
# Generate strong API keys
API_KEYS=$(openssl rand -hex 32),$(openssl rand -hex 32)

# Set in .env
API_KEYS=<paste-your-generated-keys>
ALLOWED_ORIGINS=*    # Lock down to your Flutter app domain later
LOG_LEVEL=info
WORKERS=4
CACHE_MAX_SIZE=200
USE_TMPFS=true
MAX_CONCURRENT_COMPILES=4
```

Copy the deploy script and prod compose to the VM:

```bash
# From your local machine
scp -i ~/.ssh/your_key scripts/deploy.sh ubuntu@YOUR_ORACLE_IP:~/overleaf-server/scripts/
scp -i ~/.ssh/your_key docker-compose.prod.yml ubuntu@YOUR_ORACLE_IP:~/overleaf-server/
```

---

## Step 4: Configure GitHub Secrets

In your GitHub repo → **Settings → Secrets and variables → Actions**:

| Secret | How to get the value |
|--------|---------------------|
| `DOCKERHUB_USERNAME` | Your Docker Hub username |
| `DOCKERHUB_TOKEN` | Docker Hub → Account Settings → Security → New Access Token |
| `ORACLE_HOST` | Your VM's public IP address |
| `ORACLE_SSH_USER` | `ubuntu` (default for Oracle Ubuntu images) |
| `ORACLE_SSH_KEY` | `cat ~/.ssh/your_key` — the PRIVATE key |

### Generate Docker Hub access token

1. Go to [hub.docker.com](https://hub.docker.com)
2. Account Settings → Security → New Access Token
3. Name: `overleaf-server-ci`
4. Permissions: Read & Write
5. Copy the token — you won't see it again

---

## Step 5: First Deployment

### Option A: Via CI/CD (recommended)

```bash
# Push to main branch
git add .
git commit -m "Initial release"
git push origin main
```

This triggers:
1. **CI**: Lint → Test → Build ARM64 image → Push to Docker Hub
2. **CD**: SSH → Pull → Blue-green deploy → Health check

Monitor at: `https://github.com/YOUR_USERNAME/overleaf-server/actions`

### Option B: Manual first deploy (while CI builds)

SSH into the VM:

```bash
ssh -i ~/.ssh/your_key ubuntu@YOUR_ORACLE_IP

# Pull and start manually
cd ~/overleaf-server
docker pull YOUR_DOCKERHUB_USERNAME/overleaf-server:latest
bash scripts/deploy.sh YOUR_DOCKERHUB_USERNAME/overleaf-server:latest
```

### Verify deployment

```bash
# From your local machine — health check
curl -s http://YOUR_ORACLE_IP:8080/api/v1/health | python3 -m json.tool

# Test compilation
curl -X POST http://YOUR_ORACLE_IP:8080/api/v1/compile \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"source": "\\documentclass{article}\\begin{document}Hello from Oracle Cloud!\\end{document}"}' \
  -o /tmp/test.pdf

# Verify PDF
file /tmp/test.pdf
# Expected: /tmp/test.pdf: PDF document, version 1.5

# Interactive API docs (open in browser)
# http://YOUR_ORACLE_IP:8080/docs   — Swagger UI
# http://YOUR_ORACLE_IP:8080/redoc  — ReDoc
```

---

## Step 6: Ongoing Operations

### View logs

Logs are structured JSON (via `structlog` + `orjson`). Each line includes
`request_id`, `event`, `level`, and timing information.

```bash
ssh ubuntu@YOUR_ORACLE_IP
docker logs overleaf-server-blue --tail 100 -f

# Pipe through jq for formatted output
docker logs overleaf-server-blue --tail 20 2>&1 | jq .
```

### Restart the container

```bash
docker restart overleaf-server-blue
```

### Update manually (if CI/CD is broken)

```bash
cd ~/overleaf-server
docker pull YOUR_DOCKERHUB_USERNAME/overleaf-server:latest
bash scripts/deploy.sh YOUR_DOCKERHUB_USERNAME/overleaf-server:latest
```

### Check resource usage

```bash
docker stats overleaf-server-blue
free -h
df -h
```

---

## Optional: Domain + TLS (Free)

If you want HTTPS with a custom domain:

### Using Cloudflare (free)

1. Register domain (or use existing)
2. Add to Cloudflare (free plan)
3. Create A record: `api.yourdomain.com → YOUR_ORACLE_IP`
4. Enable Proxy (orange cloud) — gives free TLS
5. Set SSL mode to **Full**
6. Update `ALLOWED_ORIGINS` in `.env`:
   ```
   ALLOWED_ORIGINS=https://yourdomain.com,https://api.yourdomain.com
   ```

### Using Let's Encrypt + Nginx (free, self-hosted)

```bash
# On the VM
sudo apt install nginx certbot python3-certbot-nginx
sudo certbot --nginx -d api.yourdomain.com

# Configure Nginx to proxy to port 8080
sudo tee /etc/nginx/sites-available/overleaf-server << 'EOF'
server {
    server_name api.yourdomain.com;
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        client_max_body_size 50M;
    }
    listen 443 ssl;
    ssl_certificate /etc/letsencrypt/live/api.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.yourdomain.com/privkey.pem;
}
server {
    listen 80;
    server_name api.yourdomain.com;
    return 301 https://$server_name$request_uri;
}
EOF
sudo ln -sf /etc/nginx/sites-available/overleaf-server /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
```

---

## Monitoring & Alerts (Free)

### UptimeRobot (free)

1. Sign up at [uptimerobot.com](https://uptimerobot.com)
2. Add monitor: `http://YOUR_ORACLE_IP:8080/api/v1/health`
3. Check interval: 5 minutes
4. Alert contacts: your email

### Manual health check cron (on VM)

```bash
# Add to crontab
crontab -e

# Check health every 5 minutes, restart if down
*/5 * * * * curl -sf http://localhost:8080/api/v1/health || docker restart $(docker ps -q --filter "name=overleaf-server") >> /var/log/texlive-health.log 2>&1
```

---

## Troubleshooting

### Container won't start

```bash
docker logs overleaf-server-blue --tail 50
# Check for Python import errors, missing env vars, etc.
```

### Port 8080 not accessible

```bash
# Check UFW
sudo ufw status

# Check Oracle iptables
sudo iptables -L -n | grep 8080

# Check container port mapping
docker ps
```

### Out of memory

```bash
free -h
docker stats

# Reduce concurrent compiles
# Edit .env: MAX_CONCURRENT_COMPILES=2
```

### Disk full

```bash
df -h
docker system prune -a  # Remove unused images/containers
sudo journalctl --vacuum-size=100M  # Trim system logs
```

### CI/CD fails

1. Check GitHub Actions logs
2. Common issues:
   - Docker Hub rate limit → use access token, not password
   - QEMU timeout → push again (ARM64 cross-compile is slow)
   - SSH key → ensure private key is in secret, not public
   - Oracle VM capacity → VM may have been reclaimed (rare)

---

## Security Hardening Checklist

- [ ] Change default API keys in `.env`
- [ ] Set `ALLOWED_ORIGINS` to your Flutter app domain only
- [ ] Disable SSH password auth: `sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config`
- [ ] Enable SSH key-only auth
- [ ] Set up fail2ban: `sudo apt install fail2ban`
- [ ] Review Oracle Cloud security list rules
- [ ] Consider adding Cloudflare for DDoS protection (free)

---

## Cost Summary

| Resource | Cost |
|----------|------|
| Oracle Cloud VM (A1.Flex, 4 OCPU, 24GB) | **Free** (Always Free tier) |
| Docker Hub (public repo) | **Free** |
| GitHub Actions (2,000 min/month) | **Free** |
| Cloudflare DNS + proxy | **Free** |
| UptimeRobot monitoring | **Free** |
| **Total** | **$0/month** |
