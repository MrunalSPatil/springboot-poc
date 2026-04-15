@echo off
REM CI/CD Setup Script for Spring Boot POC (Windows)

echo ==================================
echo Spring Boot POC - CI/CD Setup
echo ==================================
echo.

REM Check if git is installed
git --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Git is not installed. Please install Git first.
    exit /b 1
)

REM Check if Maven is installed
mvn --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Maven is not installed. Please install Maven first.
    exit /b 1
)

REM Check if Java is installed
java -version >nul 2>&1
if errorlevel 1 (
    echo ❌ Java is not installed. Please install Java 17+ first.
    exit /b 1
)

echo ✅ All prerequisites installed
echo.

REM Initialize Git
if not exist ".git\" (
    echo 📝 Initializing Git repository...
    call git init
    echo ✅ Git repository initialized
) else (
    echo ⚠️  Git repository already exists
)

echo.
echo 📦 Building the project...
call mvn clean package -DskipTests
echo ✅ Project built successfully

echo.
echo 🧪 Running tests...
call mvn test
echo ✅ Tests completed

echo.
echo 🐳 Building Docker image...
call docker build -t demo:latest .
echo ✅ Docker image built

echo.
echo ==================================
echo Setup Complete!
echo ==================================
echo.
echo 📚 Next steps:
echo 1. Create a GitHub repository
echo 2. Add your GitHub remote:
echo    git remote add origin https://github.com/YOUR_USERNAME/springboot-poc.git
echo 3. Push your code:
echo    git branch -M main
echo    git push -u origin main
echo 4. Go to GitHub Settings ^> Secrets and add:
echo    - DOCKER_USERNAME
echo    - DOCKER_PASSWORD
echo 5. GitHub Actions will automatically start!
echo.
echo 📖 For detailed information:
echo    - Read CI-CD-GUIDE.md for step-by-step setup
echo    - Read DEPLOYMENT-GUIDE.md for deployment options
echo    - Read README.md for project overview
echo.
pause
