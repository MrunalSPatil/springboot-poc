# Getting Started Checklist

Complete this checklist to successfully set up CI/CD for your Spring Boot project.

## ✅ Phase 1: Local Setup

- [ ] **Java 17+ Installed**
  - Run: `java -version`
  - Expected: Java version 17 or higher
  - If not: Download from [adoptopenjdk.net](https://adoptopenjdk.net)

- [ ] **Maven Installed**
  - Run: `mvn --version`
  - Expected: Maven 3.8+
  - If not: Download from [maven.apache.org](https://maven.apache.org)

- [ ] **Git Installed**
  - Run: `git --version`
  - Expected: git version 2.0+
  - If not: Download from [git-scm.com](https://git-scm.com)

- [ ] **Docker Installed** (Optional but recommended)
  - Run: `docker --version`
  - If not: Download from [docker.com](https://docker.com)

- [ ] **Project Builds Successfully**
  - Run: `mvn clean install`
  - Expected: BUILD SUCCESS
  - If fails: Check Java version, check network connection

- [ ] **Tests Pass Locally**
  - Run: `mvn test`
  - Expected: BUILD SUCCESS, all tests pass
  - If fails: Fix failing tests, review test output

- [ ] **Application Runs Locally**
  - Run: `mvn spring-boot:run`
  - Expected: Application starts on port 8080
  - Test endpoint: `curl http://localhost:8080/hello`
  - Stop: Press Ctrl+C

---

## ✅ Phase 2: Docker Setup

- [ ] **Docker Image Builds**
  - Run: `docker build -t demo:latest .`
  - Expected: Build succeeds, image created
  - Verify: `docker images | grep demo`

- [ ] **Docker Container Runs**
  - Run: `docker run -p 8080:8080 demo:latest`
  - Expected: Container starts, app accessible
  - Test: `curl http://localhost:8080/hello`
  - Stop: Press Ctrl+C

- [ ] **Docker Compose Works** (Optional)
  - Run: `docker-compose up -d`
  - Expected: All services start
  - Verify: `docker-compose ps`
  - Stop: `docker-compose down`

---

## ✅ Phase 3: GitHub Setup

- [ ] **GitHub Account Created**
  - Visit: [github.com](https://github.com)
  - Sign up if needed

- [ ] **New Repository Created**
  - Click: "+" → New repository
  - Name: `springboot-poc`
  - Description: "Spring Boot with CI/CD Pipeline"
  - Visibility: Public (recommended) or Private
  - Don't initialize with files

- [ ] **Git Repository Initialized Locally**
  ```bash
  cd path/to/springboot-poc
  git init
  git add .
  git commit -m "Initial commit: Spring Boot POC with CI/CD"
  ```

- [ ] **Remote Added**
  ```bash
  git remote add origin https://github.com/YOUR_USERNAME/springboot-poc.git
  ```
  - Replace YOUR_USERNAME with your GitHub username

- [ ] **Code Pushed to GitHub**
  ```bash
  git branch -M main
  git push -u origin main
  ```
  - Verify on GitHub: Refresh repository page, see files

---

## ✅ Phase 4: GitHub Secrets Configuration

- [ ] **Docker Hub Account Created**
  - Visit: [hub.docker.com](https://hub.docker.com)
  - Sign up if needed

- [ ] **Docker Access Token Generated**
  1. Go to hub.docker.com
  2. Click your profile → Account Settings
  3. Click "Security" in left menu
  4. Click "New Access Token"
  5. Name: "GitHub Actions"
  6. Copy the token (shows only once!)

- [ ] **DOCKER_USERNAME Secret Added**
  1. Go to GitHub repository
  2. Settings → Secrets and variables → Actions
  3. "New repository secret"
  4. Name: `DOCKER_USERNAME`
  5. Value: Your Docker Hub username
  6. Add secret

- [ ] **DOCKER_PASSWORD Secret Added**
  1. Settings → Secrets and variables → Actions
  2. "New repository secret"
  3. Name: `DOCKER_PASSWORD`
  4. Value: Your Docker access token
  5. Add secret

- [ ] **Secrets Verified**
  - Go to Settings → Secrets and variables → Actions
  - Should see both secrets listed (values hidden)

---

## ✅ Phase 5: CI/CD Pipeline First Run

- [ ] **Workflow Files Present**
  - Repository → .github/workflows/
  - Should see: `ci-cd-pipeline.yml`

- [ ] **Actions Tab Working**
  1. Go to repository
  2. Click "Actions" tab
  3. Should see workflow definition

- [ ] **First Pipeline Run Triggered**
  - Make a small change and push:
    ```bash
    git add .
    git commit -m "Trigger CI/CD pipeline"
    git push
    ```

- [ ] **Pipeline Started**
  1. Go to Actions tab
  2. Should see a new workflow run
  3. Wait for "Build and Test" job

- [ ] **Build Succeeded**
  - Actions tab shows ✅ green checkmark
  - All jobs completed successfully

- [ ] **Docker Image Built**
  - Actions completed without errors
  - Check Docker Hub for new image

- [ ] **Docker Image Appears in Docker Hub**
  1. Go to hub.docker.com
  2. Click your profile → Repositories
  3. Should see `demo` repository
  4. Click it → Tags
  5. Should see images tagged with:
     - `main-SHA` (commit hash)
     - `latest` (most recent)

---

## ✅ Phase 6: Testing the Pipeline

- [ ] **Pull and Run Docker Image Locally**
  ```bash
  docker pull YOUR_USERNAME/demo:latest
  docker run -p 8080:8080 YOUR_USERNAME/demo:latest
  ```
  - Replace YOUR_USERNAME
  - Application should start
  - Test: `curl http://localhost:8080/hello`

- [ ] **Make a Code Change**
  1. Edit: `src/main/java/com/example/demo/HelloController.java`
  2. Make a small change (e.g., add a comment)
  3. Save file

- [ ] **Commit and Push**
  ```bash
  git add .
  git commit -m "Test: Update HelloController"
  git push
  ```

- [ ] **Watch Pipeline Execute**
  1. Go to GitHub Actions tab
  2. Watch workflow run in real-time
  3. Verify test results
  4. Check build log for details

- [ ] **Verify All Stages Completed**
  - ✅ Build and Test
  - ✅ Code Quality Analysis
  - ✅ Build Docker Image
  - ✅ Deploy (or ready)

---

## ✅ Phase 7: Advanced Configuration (Optional)

- [ ] **Enable Security Scanning**
  - Settings → Security → Code security and analysis
  - Enable "Dependabot alerts"
  - Enable "Dependabot security updates"

- [ ] **Configure Branch Protection**
  - Settings → Branches
  - Add rule for `main` branch
  - Require CI/CD to pass before merge
  - Require pull request reviews

- [ ] **Set Up Notifications**
  - Settings → Notifications
  - Choose how to be notified of failures

- [ ] **Deploy to Cloud** (Choose one)
  - [ ] AWS ECS (see DEPLOYMENT-GUIDE.md)
  - [ ] Azure Container Instances
  - [ ] Google Cloud Run
  - [ ] Kubernetes
  - [ ] Heroku

- [ ] **Configure Monitoring Alerts**
  - Set up health check monitor
  - Get alerts on deployment failures
  - Monitor application performance

---

## 🧪 Testing Your Setup

### Test 1: Local Build
```bash
mvn clean install
# Expected: BUILD SUCCESS
```

### Test 2: Local Tests
```bash
mvn test
# Expected: All tests pass
```

### Test 3: Local Docker Build
```bash
docker build -t demo:latest .
docker run -p 8080:8080 demo:latest
curl http://localhost:8080/hello
# Expected: Hello endpoint works
```

### Test 4: GitHub Pipeline
```bash
git push
# Expected: GitHub Actions runs all jobs successfully
```

### Test 5: Docker Hub Push
- Expected: Image appears in Docker Hub within 5-10 minutes
- Verify: `docker pull YOUR_USERNAME/demo:latest`

---

## 📊 Success Criteria

You've successfully set up CI/CD when:

✅ Local build passes: `mvn clean install`
✅ Tests pass: `mvn test`
✅ Docker image builds: `docker build ...`
✅ GitHub repository has code
✅ GitHub Secrets are configured
✅ GitHub Actions shows ✅ green status
✅ Docker image appears in Docker Hub
✅ Can pull and run Docker image locally

---

## 🆘 Common Issues & Solutions

### Issue: Maven command not found
**Solution**: Maven not in PATH
- Reinstall Maven
- Add to PATH environment variable
- Restart terminal

### Issue: Docker build fails
**Solution**: Check output for specific error
- Usually Java not found or JAR not built
- Run `mvn clean install` first
- Check Docker version

### Issue: Tests fail in CI but pass locally
**Solution**: Environment differences
- Check Java version (should be 17+)
- Check timezone settings
- Run with verbose: `mvn test -X`

### Issue: GitHub Actions fails with secrets
**Solution**: Secrets not configured correctly
- Verify secret names: `DOCKER_USERNAME`, `DOCKER_PASSWORD`
- Verify secret values (no extra spaces)
- Test locally with `docker login`

### Issue: Docker image doesn't push to Docker Hub
**Solution**: Authentication failed
- Verify DOCKER_PASSWORD is correct token (not password)
- Try logging in locally: `docker login`
- Check Docker Hub for access tokens

---

## 📞 Need Help?

1. **Check logs**: GitHub Actions → Click workflow → Expand step
2. **Read guide**: Review CI-CD-GUIDE.md for detailed instructions
3. **Test locally**: Run commands on your machine first
4. **GitHub docs**: https://docs.github.com/en/actions
5. **Docker docs**: https://docs.docker.com

---

## 🎉 After Setup Complete

1. ✅ Celebrate! Your CI/CD pipeline is ready!
2. ✅ Read DEPLOYMENT-GUIDE.md for cloud deployment
3. ✅ Set up monitoring and alerts
4. ✅ Configure branch protection
5. ✅ Invite team members as collaborators

---

**Status**: ___________________
**Date Completed**: ___________________
**Notes**: ___________________________

---

