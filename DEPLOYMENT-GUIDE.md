# Deployment Guide

## Local Testing with Docker

### Prerequisites
- Docker and Docker Compose installed
- Project built successfully

### Running Locally

```bash
# Build Docker image
docker build -t demo:latest .

# Run container
docker run -p 8080:8080 demo:latest

# Or use Docker Compose (with database and cache)
docker-compose up -d

# Check logs
docker-compose logs -f demo-app

# Stop services
docker-compose down
```

### Testing the Application

```bash
# Test the endpoint
curl http://localhost:8080/hello

# Check application health
curl http://localhost:8080/actuator/health

# View logs
docker logs springboot-demo
```

---

## Cloud Deployment Options

### Option 1: AWS ECS (Elastic Container Service)

#### Prerequisites
- AWS Account
- AWS CLI installed and configured
- Docker image pushed to ECR (Elastic Container Registry)

#### Steps

1. **Create ECR Repository**
```bash
aws ecr create-repository --repository-name demo --region us-east-1
```

2. **Push Image to ECR**
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 123456789.dkr.ecr.us-east-1.amazonaws.com

docker tag demo:latest 123456789.dkr.ecr.us-east-1.amazonaws.com/demo:latest

docker push 123456789.dkr.ecr.us-east-1.amazonaws.com/demo:latest
```

3. **Create ECS Task Definition** (task-definition.json)
```json
{
  "family": "demo-app",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "256",
  "memory": "512",
  "containerDefinitions": [
    {
      "name": "demo-app",
      "image": "123456789.dkr.ecr.us-east-1.amazonaws.com/demo:latest",
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080,
          "protocol": "tcp"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/demo-app",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
}
```

4. **Register Task Definition**
```bash
aws ecs register-task-definition --cli-input-json file://task-definition.json
```

5. **Create ECS Cluster and Service**
```bash
# Create cluster
aws ecs create-cluster --cluster-name demo-cluster

# Create service
aws ecs create-service \
  --cluster demo-cluster \
  --service-name demo-service \
  --task-definition demo-app \
  --desired-count 2 \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[subnet-xxxxx],securityGroups=[sg-xxxxx]}"
```

6. **Update GitHub Secrets**
```
AWS_ACCOUNT_ID: 123456789
AWS_REGION: us-east-1
AWS_ECR_REPOSITORY: demo
```

---

### Option 2: Azure Container Instances

#### Prerequisites
- Azure Account
- Azure CLI installed
- Azure Container Registry

#### Steps

1. **Create Container Registry**
```bash
az acr create --resource-group mygroup --name demoregistry --sku Basic
```

2. **Push Image**
```bash
az acr build --registry demoregistry --image demo:latest .
```

3. **Deploy Container Instance**
```bash
az container create \
  --resource-group mygroup \
  --name demo-app \
  --image demoregistry.azurecr.io/demo:latest \
  --ports 8080 \
  --environment-variables SPRING_PROFILES_ACTIVE=prod \
  --registry-login-server demoregistry.azurecr.io \
  --registry-username <username> \
  --registry-password <password>
```

4. **Get Public IP**
```bash
az container show --resource-group mygroup --name demo-app --query ipAddress.ip
```

---

### Option 3: Google Cloud Run

#### Prerequisites
- GCP Account
- gcloud CLI installed
- Artifact Registry enabled

#### Steps

1. **Authorize Docker**
```bash
gcloud auth configure-docker
```

2. **Tag and Push Image**
```bash
docker tag demo:latest gcr.io/PROJECT-ID/demo:latest
docker push gcr.io/PROJECT-ID/demo:latest
```

3. **Deploy to Cloud Run**
```bash
gcloud run deploy demo-app \
  --image gcr.io/PROJECT-ID/demo:latest \
  --platform managed \
  --region us-central1 \
  --port 8080 \
  --allow-unauthenticated
```

---

### Option 4: Heroku

#### Prerequisites
- Heroku Account
- Heroku CLI installed

#### Steps

1. **Create Procfile**
```
web: java -jar target/demo-*.jar
```

2. **Create Heroku App**
```bash
heroku create demo-app
```

3. **Deploy**
```bash
git push heroku main
```

4. **View Logs**
```bash
heroku logs --tail
```

---

### Option 5: Kubernetes (K8s)

#### Prerequisites
- Kubernetes cluster (local minikube or cloud)
- kubectl installed
- Docker image in registry

#### Create Deployment and Service

1. **deployment.yaml**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: demo
  template:
    metadata:
      labels:
        app: demo
    spec:
      containers:
      - name: demo
        image: username/demo:latest
        ports:
        - containerPort: 8080
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /actuator/health
            port: 8080
          initialDelaySeconds: 40
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /actuator/health/readiness
            port: 8080
          initialDelaySeconds: 20
          periodSeconds: 5
```

2. **service.yaml**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: demo-service
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: demo
```

3. **Deploy**
```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Check status
kubectl get deployments
kubectl get services
kubectl describe service demo-service
```

---

## Monitoring and Logging

### Add Actuator Endpoint

Update `pom.xml`:
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

Update `application.properties`:
```properties
management.endpoints.web.exposure.include=health,metrics,info
management.endpoint.health.show-details=always
```

### Health Check Endpoints

- `/actuator/health` - Basic health status
- `/actuator/metrics` - Application metrics
- `/actuator/info` - Application info

### Container Logs

```bash
# Docker
docker logs -f containerName

# Kubernetes
kubectl logs -f deployment/demo-app

# ECS
aws logs tail /ecs/demo-app --follow
```

---

## Rollback Procedures

### Docker Hub
```bash
# Pull previous version
docker pull username/demo:v1.0.0

# Run previous version
docker run -p 8080:8080 username/demo:v1.0.0
```

### Kubernetes
```bash
# Check rollout history
kubectl rollout history deployment/demo-app

# Rollback to previous version
kubectl rollout undo deployment/demo-app

# Rollback to specific revision
kubectl rollout undo deployment/demo-app --to-revision=2
```

### ECS
```bash
# Update service with previous task definition
aws ecs update-service \
  --cluster demo-cluster \
  --service demo-service \
  --task-definition demo-app:1 \
  --force-new-deployment
```

---

## Troubleshooting

### Container won't start
- Check logs: `docker logs containerName`
- Verify port availability
- Check resource limits (memory, CPU)

### Application inside container fails
- Verify JAR file exists
- Check Java version compatibility
- Review environment variables

### Health checks failing
- Ensure actuator endpoints are exposed
- Check startup time (increase `initialDelaySeconds`)
- Verify port mappings

### Performance issues
- Monitor CPU and memory usage
- Scale horizontally (more containers)
- Optimize database queries
- Enable caching

---

## Scaling Strategies

### Horizontal Scaling (Add more instances)
```bash
# Kubernetes
kubectl scale deployment demo-app --replicas=5

# ECS
aws ecs update-service --cluster demo-cluster --service demo-service --desired-count 5

# Docker Compose
docker-compose up -d --scale demo-app=3
```

### Vertical Scaling (More CPU/Memory)
- Increase container resource limits
- Use larger machine types
- Update environment variables

---

## Security Best Practices

1. **Use non-root user** (already in Dockerfile)
2. **Scan images for vulnerabilities**
```bash
docker scout cves username/demo:latest
trivy image username/demo:latest
```

3. **Use secrets management**
- Keep sensitive data in environment variables
- Use cloud provider secret stores

4. **Enable HTTPS/TLS**
- Use reverse proxy (nginx, traefik)
- Use load balancer with SSL termination

5. **Network security**
- Use VPC and security groups
- Implement network policies in Kubernetes
