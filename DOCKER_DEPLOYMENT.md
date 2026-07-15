# 🐳 Docker Deployment Guide - SpamShield AI

## Prerequisites
- Docker installed: https://www.docker.com/products/docker-desktop
- Docker Compose installed (usually comes with Docker Desktop)

## Quick Deployment

### 1. Build and Run with Docker Compose
```bash
# Navigate to project root
cd spam-or-ham-detection

# Build and start all services
docker-compose up --build

# Run in background
docker-compose up -d --build
```

### 2. Access the Application
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **API Docs**: http://localhost:8000/docs

### 3. Stop Services
```bash
# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

---

## Individual Container Builds

### Build Backend Image
```bash
docker build -f Dockerfile.backend -t spamshield-backend:latest .
```

### Build Frontend Image
```bash
docker build -f Dockerfile.frontend -t spamshield-frontend:latest .
```

### Run Backend Container
```bash
docker run -d \
  -p 8000:8000 \
  -e ALLOWED_ORIGINS=http://localhost:3000 \
  -v ./backend/app/model:/app/backend/app/model:ro \
  --name spamshield-backend \
  spamshield-backend:latest
```

### Run Frontend Container
```bash
docker run -d \
  -p 3000:3000 \
  -e REACT_APP_API_URL=http://localhost:8000 \
  --name spamshield-frontend \
  spamshield-frontend:latest
```

---

## Production Configuration

### Environment Variables for Production

Create a `.env.prod` file:
```env
BACKEND_HOST=0.0.0.0
BACKEND_PORT=8000
ENVIRONMENT=production
LOG_LEVEL=WARNING
ALLOWED_ORIGINS=https://your-domain.com
RATE_LIMIT_CALLS=100
```

### Using Environment File with Docker Compose
```bash
docker-compose --env-file .env.prod up -d
```

---

## Health Checks

### Verify Backend Health
```bash
curl http://localhost:8000/api/health
# Expected: {"status":"running"}
```

### Verify Frontend
```bash
curl http://localhost:3000
# Expected: HTML response
```

### Check Container Status
```bash
docker-compose ps
```

---

## Logging

### View Backend Logs
```bash
docker-compose logs backend
docker-compose logs -f backend  # Follow logs
```

### View Frontend Logs
```bash
docker-compose logs frontend
```

### View All Logs
```bash
docker-compose logs -f
```

---

## Scaling & Performance

### Run Multiple Backend Instances
Edit `docker-compose.yml` and add load balancer:
```yaml
services:
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - backend1
      - backend2
  
  backend1:
    build:
      context: .
      dockerfile: Dockerfile.backend
    # ... backend config
  
  backend2:
    build:
      context: .
      dockerfile: Dockerfile.backend
    # ... backend config
```

---

## Troubleshooting

### Container won't start
```bash
# Check logs
docker-compose logs

# Check resource usage
docker stats

# Rebuild without cache
docker-compose build --no-cache
```

### Port already in use
```bash
# Change ports in docker-compose.yml
# Or kill process using port
docker ps  # Find container using port
docker stop <container-id>
```

### Network issues
```bash
# Check network
docker network ls
docker network inspect spamshield-network

# Test connectivity
docker exec spamshield-backend curl http://frontend:3000
```

---

## Cloud Deployment

### AWS Deployment (ECS)
1. Push images to ECR
2. Create ECS task definition
3. Deploy to ECS cluster
4. Configure load balancer
5. Set up CloudWatch monitoring

### Google Cloud Deployment (GKE)
1. Enable GKE API
2. Create cluster
3. Push images to Container Registry
4. Deploy using kubectl
5. Configure Cloud Load Balancer

### Azure Deployment (ACI)
1. Push images to Container Registry
2. Create container group
3. Configure networking
4. Set up Application Gateway

---

## Security Best Practices

✅ **Implemented in our Docker setup:**
- Non-root user (appuser, UID 1000)
- Health checks enabled
- Read-only model/dataset volumes
- Explicit port exposure
- Minimal base images

⚠️ **For Production:**
1. Use HTTPS/TLS
2. Implement secrets management (AWS Secrets Manager, Azure Key Vault)
3. Add Web Application Firewall (WAF)
4. Enable logging and monitoring
5. Set resource limits:
   ```yaml
   resources:
     limits:
       cpus: '1'
       memory: 512M
   ```
6. Configure network policies

---

## Monitoring & Observability

### Add Prometheus for Metrics
```yaml
services:
  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
```

### Add ELK Stack for Logs
```yaml
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.0.0
  
  kibana:
    image: docker.elastic.co/kibana/kibana:8.0.0
```

---

## Maintenance

### Update Images
```bash
# Pull latest base images
docker pull python:3.11-slim
docker pull node:20-alpine

# Rebuild
docker-compose build --pull

# Restart
docker-compose up -d
```

### Cleanup
```bash
# Remove unused images
docker image prune

# Remove unused volumes
docker volume prune

# Remove unused networks
docker network prune

# Complete cleanup
docker system prune -a
```

---

## Performance Optimization

### Frontend Optimization
- Gzip compression enabled in Nginx
- Asset caching configured
- Lazy loading implemented

### Backend Optimization
- Connection pooling
- Request batching
- Caching layer (consider Redis)

### Database (if added)
- Connection pooling
- Query optimization
- Indexing strategy

---

## Rollback Strategy

```bash
# Tag image with version
docker build -f Dockerfile.backend -t spamshield-backend:v1.0 .

# Push to registry
docker push spamshield-backend:v1.0

# Update docker-compose.yml to use specific version
# image: spamshield-backend:v1.0

# Rollback if needed
docker-compose pull
docker-compose up -d
```

---

## Support & Troubleshooting

For issues:
1. Check Docker logs: `docker-compose logs`
2. Verify network connectivity: `docker exec <container> ping <service>`
3. Check resource usage: `docker stats`
4. Review application logs in container

**Health check endpoints:**
- Backend: `GET /api/health`
- Frontend: `GET /`
