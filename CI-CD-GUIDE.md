# CI/CD Pipeline Guide for Spring Boot POC

## Overview
This guide walks you through setting up a complete CI/CD pipeline for your Spring Boot application using GitHub Actions.

### What is CI/CD?
- **CI (Continuous Integration)**: Automatically build and test code on every push
- **CD (Continuous Deployment/Delivery)**: Automatically deploy tested code to production

## Prerequisites
1. GitHub account and repository
2. Docker Hub account (optional, for container deployments)
3. AWS/Azure/GCP account (optional, for cloud deployments)

## Step 1: Initialize Git Repository

```bash
# Navigate to your project
cd c:\Users\Mrunal Patil\Downloads\springboot-poc

# Initialize git
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Spring Boot POC"

# Add remote repository (replace with your GitHub repo URL)
git remote add origin https://github.com/YOUR_USERNAME/springboot-poc.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 2: GitHub Actions Workflow

The pipeline includes:
- **Build**: Compile and package the application
- **Test**: Run unit tests
- **Code Quality**: Analyze code with SonarQube (optional)
- **Security**: Scan for vulnerabilities
- **Docker Build**: Create container image
- **Deploy**: Push to Docker Hub/Deploy to cloud

### Files Created:
1. `.github/workflows/ci-cd-pipeline.yml` - Main CI/CD workflow
2. `.github/workflows/code-quality.yml` - Code quality and security checks
3. `Dockerfile` - Container configuration
4. `.dockerignore` - Exclude files from Docker build

## Step 3: Push to GitHub

Once you push your code to GitHub, the pipeline automatically:
1. Triggers on every push or pull request
2. Builds the application
3. Runs tests
4. Creates Docker image
5. Performs security checks
6. (Optionally) Deploys to your environment

## Step 4: GitHub Secrets Configuration

For sensitive data, configure these secrets in GitHub:

**Repository Settings → Secrets and variables → Actions → New repository secret**

### Required Secrets:
```
DOCKER_USERNAME     - Your Docker Hub username
DOCKER_PASSWORD     - Your Docker Hub token (not password)
DOCKER_REGISTRY     - docker.io (or your registry)
AWS_ACCESS_KEY_ID   - If deploying to AWS
AWS_SECRET_ACCESS_KEY - If deploying to AWS
```

### How to get Docker Token:
1. Go to hub.docker.com
2. Click your profile → Account Settings → Security
3. Create Personal Access Token
4. Use as DOCKER_PASSWORD

## Step 5: Understanding the Workflow

### Main Pipeline Stages:

```
┌─────────────────────────────────┐
│   Push to GitHub                │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│   Setup Java Environment (JDK)  │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│   Build Project (Maven)         │
│   - Compile                     │
│   - Run Tests                   │
│   - Package JAR                 │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│   Code Quality Analysis         │
│   - Static Code Analysis        │
│   - Security Scanning           │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│   Build Docker Image            │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│   Push to Docker Registry       │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│   Deploy (if on main branch)    │
└─────────────────────────────────┘
```

## Step 6: Deployment Options

### Option A: Docker Hub + Manual Deployment
- Push image to Docker Hub
- Deploy using: `docker run -p 8080:8080 username/demo:latest`

### Option B: AWS Deployment
- ECS (Elastic Container Service)
- EC2 with Docker
- Elastic Beanstalk

### Option C: Azure Deployment
- Container Instances
- App Service
- Kubernetes (AKS)

### Option D: GCP Deployment
- Cloud Run
- GKE (Kubernetes)

## Step 7: Running Tests Locally

```bash
# Run all tests
mvn test

# Run specific test
mvn test -Dtest=HelloControllerTest

# Run tests with code coverage
mvn test jacoco:report

# View coverage report
# Open target/site/jacoco/index.html in browser
```

## Step 8: Adding Tests to Your Project

Create a test file: `src/test/java/com/example/demo/HelloControllerTest.java`

```java
package com.example.demo;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(HelloController.class)
public class HelloControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    public void testHelloEndpoint() throws Exception {
        mockMvc.perform(get("/hello"))
               .andExpect(status().isOk());
    }
}
```

## Step 9: Monitoring Pipeline Execution

1. Go to GitHub repository
2. Click "Actions" tab
3. View workflow runs
4. Click on a run to see detailed logs
5. Each step shows status (✅ passed, ❌ failed)

## Step 10: Troubleshooting

### Build Fails
- Check Java version compatibility
- Run `mvn clean install` locally first
- Check for missing dependencies

### Docker Build Fails
- Verify Dockerfile syntax
- Ensure JAR file is built
- Check Docker Hub credentials

### Tests Fail
- Run locally: `mvn test`
- Check test logs in GitHub Actions
- Fix failing tests before pushing

## Best Practices

1. **Branching Strategy**
   - `main` branch: Production-ready code
   - `develop` branch: Integration branch
   - `feature/*` branches: Feature development

2. **Commit Messages**
   ```
   Good: "feat: Add user authentication"
   Bad: "fix stuff"
   ```

3. **Pull Requests**
   - Create PR before merging to main
   - Let CI/CD validation pass before merge
   - Request code reviews

4. **Security**
   - Never commit secrets (use GitHub Secrets)
   - Scan dependencies for vulnerabilities
   - Keep dependencies updated

5. **Monitoring**
   - Set up email notifications for failures
   - Monitor logs regularly
   - Track build times

## Next Steps

1. ✅ Push code to GitHub
2. ✅ Create GitHub repository
3. ✅ Add GitHub Secrets
4. ✅ Push code with workflows
5. ✅ Monitor first build
6. ✅ Fix any issues
7. ✅ Configure deployment target
8. ✅ Set up monitoring/alerts

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Spring Boot Testing Guide](https://spring.io/guides/gs/testing-web/)
- [Docker Documentation](https://docs.docker.com/)
- [Maven Documentation](https://maven.apache.org/guides/)

---

**Questions or Issues?**
- Check GitHub Actions logs for detailed error messages
- Review the workflow YAML files
- Test commands locally before relying on CI/CD
