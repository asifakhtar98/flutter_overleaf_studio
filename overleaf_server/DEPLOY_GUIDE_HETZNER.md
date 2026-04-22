# 🚀 Production Deploy Guide — Overleaf Server

> Step-by-step guide to deploy the Overleaf Server on Hetzner CAX11 (ARM64).

> [!IMPORTANT]
> Replace all occurrences of `YOUR_HETZNER_IP`, `YOUR_USERNAME`, `YOUR_DOCKERHUB_USERNAME`, and `YOUR_API_KEY` with your actual values before running any command.

---

## Prerequisites Checklist

| #   | Item                                    | Status |
| --- | --------------------------------------- | ------ |
| 1   | Hetzner Cloud account + project created | ❓      |
| 2   | GitHub account + repo created           | ❓      |
| 3   | Docker Hub account (free)               | ❓      |
| 4   | SSH key pair (`ed25519`)                | ❓      |
| 5   | Local machine with Docker installed     | ❓      |

---

## Step 1: Provision Hetzner CAX11 Server

### 1.1 Create Server

1. Login to [Hetzner Cloud Console](https://console.hetzner.cloud)
2. Select your project → **Add Server**
3. Configure:

| Setting        | Value                                            |
| -------------- | ------------------------------------------------ |
| **Name**       | `overleaf-server`                                |
| **Location**   | Pick closest to your users (e.g., `Falkenstein`) |
| **Image**      | Ubuntu 22.04                                     |
| **Type**       | `CAX11` (2 ARM vCPU, 4GB RAM, 40GB disk)         |
| **Networking** | Public IPv4 enabled                              |
| **SSH Key**    | Upload your public key                           |
| **Firewall**   | Create new (configure below)                     |

4. Click **Create & Buy Now** (~€3.29/month)

> [!NOTE]
> Unlike Oracle Cloud, Hetzner provisioning is instant. No capacity errors.

### 1.2 Configure Firewall

In Hetzner Console → **Firewalls → Create Firewall**:

Add the following **Inbound** rules:

| Protocol | Port | Source                               |
| -------- | ---- | ------------------------------------ |
| TCP      | 22   | `0.0.0.0/0` (or restrict to your IP) |
| TCP      | 80   | `0.0.0.0/0`                          |
| TCP      | 443  | `0.0.0.0/0`                          |
| TCP      | 8080 | `0.0.0.0/0`                          |

Attach the firewall to your `overleaf-server`.

> [!TIP]
> Restrict port 22 to your own IP only for better security.

### 1.3 Note Your Public IP

Copy the public IPv4 from your server details. You'll need it for:
- SSH access
- GitHub secrets
- API access

---

## Step 2: Initial Server Setup

SSH into your server:

```bash
ssh -i ~/.ssh/your_key root@YOUR_HETZNER_IP
```

> [!NOTE]
> Hetzner Ubuntu images log in as `root` by default, unlike Oracle's `ubuntu` user. Create a non-root user if preferred.

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
- ✅ Creates `~/overleaf-server/` directory with `.env` template
- ✅ Sets up Docker log rotation

> [!NOTE]
> No Oracle-specific iptables rules needed. Hetzner's firewall is managed at the network level via the console.

**After the script:**

```bash
# Reload shell for Docker group membership (or re-login)
newgrp docker

# Verify Docker works
docker run --rm hello-world
```

---

## Step 3: Configure Production Environment

Edit the environment file on the server:

```bash
nano ~/overleaf-server/.env
```

**Critical values to set:**

```bash
# Generate strong API keys
API_KEYS=$(openssl rand -hex 32),$(openssl rand -hex 32)

# Set in .env
API_KEYS=<paste-your-generated-keys>
ALLOWED_ORIGINS=*    # Lock down to your app domain later
LOG_LEVEL=info
WORKERS=2            # CAX11 has 2 vCPUs — don't exceed this
CACHE_MAX_SIZE=100   # CAX11 has 4GB RAM — be conservative
USE_TMPFS=true
MAX_CONCURRENT_COMPILES=2   # Match your vCPU count
```

> [!WARNING]
> CAX11 has 4GB RAM. Keep `MAX_CONCURRENT_COMPILES=2` and `WORKERS=2`. Pushing beyond this will cause OOM kills under load.

Copy the deploy script and prod compose to the server:

```bash
# From your local machine
scp -i ~/.ssh/your_key scripts/deploy.sh root@YOUR_HETZNER_IP:~/overleaf-server/scripts/
scp -i ~/.ssh/your_key docker-compose.prod.yml root@YOUR_HETZNER_IP:~/overleaf-server/
```

---

## Step 4: Configure GitHub Secrets

In your GitHub repo → **Settings → Secrets and variables → Actions**:

| Secret               | How to get the value                                        |
| -------------------- | ----------------------------------------------------------- |
| `DOCKERHUB_USERNAME` | Your Docker Hub username                                    |
| `DOCKERHUB_TOKEN`    | Docker Hub → Account Settings → Security → New Access Token |
| `HETZNER_HOST`       | Your server's public IPv4 address                           |
| `HETZNER_SSH_USER`   | `root` (default for Hetzner Ubuntu)                         |
| `HETZNER_SSH_KEY`    | `cat ~/.ssh/your_key` — the PRIVATE key                     |

### Generate Docker Hub access token

1. Go to [hub.docker.com](https://hub.docker.com)
2. Account Settings → Security → New Access Token
3. Name: `overleaf-server-ci`
4. Permissions: Read & Write
5. Copy the token — you won't see it again

> [!IMPORTANT]
> Update your GitHub Actions workflow: replace `ORACLE_HOST`, `ORACLE_SSH_USER`, `ORACLE_SSH_KEY` secret references with `HETZNER_HOST`, `HETZNER_SSH_USER`, `HETZNER_SSH_KEY`.

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

### Option B: Manual first deploy

SSH into the server:

```bash
ssh -i ~/.ssh/your_key root@YOUR_HETZNER_IP

# Pull and start manually
cd ~/overleaf-server
docker pull YOUR_DOCKERHUB_USERNAME/overleaf-server:latest
bash scripts/deploy.sh YOUR_DOCKERHUB_USERNAME/overleaf-server:latest
```

### Verify deployment

```bash
# From your local machine — health check
curl -s http://YOUR_HETZNER_IP:8080/api/v1/health | python3 -m json.tool

# Test compilation
curl -X POST http://YOUR_HETZNER_IP:8080/api/v1/compile \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"source": "\\documentclass{article}\\begin{document}Hello from Hetzner!\\end{document}"}' \
  -o /tmp/test.pdf

# Verify PDF
file /tmp/test.pdf
# Expected: /tmp/test.pdf: PDF document, version 1.5

# Interactive API docs (open in browser)
# http://YOUR_HETZNER_IP:8080/docs   — Swagger UI
# http://YOUR_HETZNER_IP:8080/redoc  — ReDoc
```

---

## Step 6: Ongoing Operations

### View logs

```bash
ssh root@YOUR_HETZNER_IP
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

### Using Cloudflare (recommended)

1. Register domain (or use existing)
2. Add to Cloudflare (free plan)
3. Create A record: `api.yourdomain.com → YOUR_HETZNER_IP`
4. Enable Proxy (orange cloud) — gives free TLS
5. Set SSL mode to **Full**
6. Update `ALLOWED_ORIGINS` in `.env`:
   ```
   ALLOWED_ORIGINS=https://yourdomain.com,https://api.yourdomain.com
   ```

### Using Let's Encrypt + Nginx (self-hosted)

```bash
# On the server
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
2. Add monitor: `http://YOUR_HETZNER_IP:8080/api/v1/health`
3. Check interval: 5 minutes
4. Alert contacts: your email

### Manual health check cron (on server)

```bash
crontab -e

# Check health every 5 minutes, restart container if down
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

# Check Hetzner firewall — verify rules in Hetzner Console
# UFW + Hetzner firewall are independent layers — both must allow the port

# Check container port mapping
docker ps
```

### Out of memory (most likely issue on CAX11)

```bash
free -h
docker stats

# Reduce load in .env:
# MAX_CONCURRENT_COMPILES=1
# WORKERS=1
```

> [!WARNING]
> 4GB RAM is the real constraint on CAX11. If you hit OOM regularly with 10 users, upgrade to **CAX21** (4 ARM vCPU, 8GB RAM, 80GB disk) at ~€7.49/month.

### Disk full

```bash
df -h
docker system prune -a      # Remove unused images/containers
sudo journalctl --vacuum-size=100M   # Trim system logs
```

> [!NOTE]
> 40GB disk is tight with TeX Live full (~7GB) + OS + Docker images. Monitor `df -h` regularly.

### CI/CD fails

1. Check GitHub Actions logs
2. Common issues:
   - Wrong SSH user — Hetzner uses `root`, not `ubuntu`
   - Secret names — ensure you updated from `ORACLE_*` to `HETZNER_*`
   - Docker Hub rate limit → use access token, not password
   - QEMU timeout → ARM64 cross-compile is slow, push again

---

## Security Hardening Checklist

- [ ] Change default API keys in `.env`
- [ ] Set `ALLOWED_ORIGINS` to your app domain only
- [ ] Disable SSH password auth: `sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && systemctl restart sshd`
- [ ] Restrict port 22 in Hetzner Firewall to your IP only
- [ ] Install fail2ban: `sudo apt install fail2ban`
- [ ] Add Cloudflare proxy for DDoS protection (free)
- [ ] Consider creating a non-root user for SSH and Docker

---

## Cost Summary

| Resource                                       | Cost                          |
| ---------------------------------------------- | ----------------------------- |
| Hetzner CAX11 (2 ARM vCPU, 4GB RAM, 40GB disk) | **~€3.29/month**              |
| Docker Hub (public repo)                       | **Free**                      |
| GitHub Actions (2,000 min/month)               | **Free**                      |
| Cloudflare DNS + proxy                         | **Free**                      |
| UptimeRobot monitoring                         | **Free**                      |
| **Total**                                      | **~€3.29/month (~$3.60 USD)** |

> Upgrade path: CAX21 (8GB RAM) at ~€7.49/month if 4GB becomes a bottleneck.