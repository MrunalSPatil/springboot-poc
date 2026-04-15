# Quick Reference Guide - CI/CD Pipeline

## 📋 Your Project Structure Overview

```
springboot-poc/
├── .github/workflows/
│   └── ci-cd-pipeline.yml          # GitHub Actions workflow
├── src/
│   ├── main/java/com/example/demo/ # Source code
│   ├── main/resources/             # Application properties
│   └── test/java/com/example/demo/ # Unit tests
├── Dockerfile                       # Docker image configuration
├── docker-compose.yml               # Local development stack
├── pom.xml                          # Maven configuration + dependencies
├── CI-CD-GUIDE.md                   # Complete setup guide
├── DEPLOYMENT-GUIDE.md              # Cloud deployment options
├── README.md                        # Project overview
├── setup.sh / setup.bat            # Automated setup script
└── .gitignore                      # Git ignore rules
```

---

## 🚀 Quick Commands

### Local Development

```bash
# Build project
mvn clean install

# Run application
mvn spring-boot:run

# Run tests
mvn test

# Generate code coverage
mvn test jacoco:report

# Format and check code
mvn checkstyle:check
```

### Docker Operations

```bash
# Build image
docker build -t demo:latest .

# Run container
docker run -p 8080:8080 demo:latest

# Docker Compose (start all services)
docker-compose up -d

# Docker Compose (stop services)
docker-compose down

# View logs
docker-compose logs -f demo-app
```

### Git Operations

```bash
# Initialize repository
git init
git add .
git commit -m "Initial commit"

# Add GitHub remote
git remote add origin https://github.com/YOUR_USERNAME/springboot-poc.git

# Push to GitHub
git branch -M main
git push -u origin main

# Create feature branch
git checkout -b feature/your-feature
git push -u origin feature/your-feature
```

---

## 📌 CI/CD Pipeline Stages

### 1. **Build & Test** (Automatic on every push)
- ✅ Compiles Java code with Maven
- ✅ Runs all unit tests
- ✅ Generates test coverage reports
- ✅ Uploads artifacts

### 2. **Code Quality** (After build)
- ✅ Security scanning with Trivy
- ✅ SAST (Static Application Security Testing)
- ✅ Uploads results to GitHub Security tab

### 3. **Docker Build** (On main/develop)
- ✅ Builds multi-stage Docker image
- ✅ Pushes to Docker Hub
- ✅ Tags images with branch and SHA

### 4. **Deploy** (On main branch only)
- ✅ Pulls latest image
- ✅ Ready for cloud deployment
- ✅ (Optional) Deploys to AWS/Azure/GCP

---

## 🔐 GitHub Secrets Setup

**Location**: Settings → Secrets and variables → Actions → New repository secret

### Required Secrets

| Secret | Value | Where to Get |
|--------|-------|------------|
| `DOCKER_USERNAME` | Your Docker Hub username | docker.io profile |
| `DOCKER_PASSWORD` | Docker Hub access token | Hub > Account > Security |
| `AWS_ACCESS_KEY_ID` | (Optional) AWS credential | AWS IAM console |
| `AWS_SECRET_ACCESS_KEY` | (Optional) AWS credential | AWS IAM console |

### How to Generate Docker Token

1. Go to https://hub.docker.com
2. Click your profile → Account Settings
3. Click "Security" in left menu
4. Click "New Access Token"
5. Name it "GitHub Actions"
6. Copy the token (shows only once!)
7. Add as `DOCKER_PASSWORD` in GitHub Secrets

---

## 🔍 API Endpoints

```bash
# Application running
GET http://localhost:8080/hello

# Health check
GET http://localhost:8080/actuator/health

# Application metrics
GET http://localhost:8080/actuator/metrics

# Application info
GET http://localhost:8080/actuator/info
```

### Health Check Response
```json
{
  "status": "UP",
  "components": {
    "db": {"status": "UP"},
    "diskSpace": {"status": "UP"}
  }
}
```

---

## 🐛 Troubleshooting

### Build Fails
```bash
# Clean and rebuild
mvn clean install -U

# with verbose output
mvn clean install -X
```

### Tests Fail
```bash
# Run tests locally first
mvn test

# Run specific test
mvn test -Dtest=HelloControllerTest

# See detailed output
mvn test -X
```

### Docker Issues
```bash
# Rebuild from scratch (no cache)
docker build --no-cache -t demo:latest .

# Check image
docker images

# Remove old images
docker image prune -a
```

### GitHub Actions Fails
1. Go to repository → Actions tab
2. Click the failed workflow
3. Click the failed job
4. Expand each step to see error details
5. Check logs for specific error message

---

## 📊 Monitoring & Metrics

### View Test Results
- GitHub Actions → Artifacts tab
- Download "test-results" artifact

### View Code Coverage
- GitHub Actions → Artifacts tab
- Download "coverage-reports" artifact
- Extract and open `index.html` in browser

### View Logs
- GitHub Actions → Click workflow run
- Expand "Build" step → See all logged output

---

## 🌐 Deployment Checklist

- [ ] Code pushed to GitHub
- [ ] GitHub Secrets configured
- [ ] First CI/CD run successful
- [ ] Docker image in Docker Hub
- [ ] Security scan passed
- [ ] Tests passing (100% or target coverage)
- [ ] Cloud account setup (if deploying)
- [ ] Environment variables configured
- [ ] Database/services provisioned
- [ ] SSL/HTTPS configured
- [ ] Monitoring alerts setup

---

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| `README.md` | Project overview and quick start |
| `CI-CD-GUIDE.md` | Step-by-step setup guide |
| `DEPLOYMENT-GUIDE.md` | Cloud deployment instructions |
| `QUICK-REFERENCE.md` | This file - quick commands |

---

## 🔗 Useful Links

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Maven Documentation](https://maven.apache.org/guides/)
- [Spring Boot Docs](https://spring.io/projects/spring-boot)
- [Docker Docs](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com)

---

## ✨ Best Practices

1. **Always test locally first**
   ```bash
   mvn test
   ```

2. **Use feature branches**
   ```bash
   git checkout -b feature/new-feature
   ```

3. **Write meaningful commit messages**
   ```bash
   git commit -m "feat: Add new API endpoint"
   ```

4. **Keep dependencies updated**
   ```bash
   mvn versions:display-dependency-updates
   ```

5. **Review GitHub Actions logs**
   - Always check Actions tab for failures
   - Fix issues immediately

6. **Monitor Docker Hub**
   - Check image size
   - Review vulnerability scans
   - Clean up old images

---

## 🎯 Next Steps

1. ✅ Review all documentation
2. ✅ Run setup script: `./setup.sh` or `setup.bat`
3. ✅ Create GitHub repository
4. ✅ Add remote and push code
5. ✅ Configure secrets
6. ✅ Watch first CI/CD run
7. ✅ Verify Docker image built
8. ✅ Deploy to your platform

---

**Happy coding! 🚀**
