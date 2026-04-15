#!/bin/bash
# CI/CD Setup Script for Spring Boot POC

echo "=================================="
echo "Spring Boot POC - CI/CD Setup"
echo "=================================="
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install Git first."
    exit 1
fi

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "❌ Maven is not installed. Please install Maven first."
    exit 1
fi

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo "❌ Java is not installed. Please install Java 17+ first."
    exit 1
fi

echo "✅ All prerequisites installed"
echo ""

# Initialize Git
if [ ! -d ".git" ]; then
    echo "📝 Initializing Git repository..."
    git init
    echo "✅ Git repository initialized"
else
    echo "⚠️  Git repository already exists"
fi

echo ""
echo "📦 Building the project..."
mvn clean package -DskipTests
echo "✅ Project built successfully"

echo ""
echo "🧪 Running tests..."
mvn test
echo "✅ Tests completed"

echo ""
echo "🐳 Building Docker image..."
docker build -t demo:latest .
echo "✅ Docker image built"

echo ""
echo "=================================="
echo "Setup Complete!"
echo "=================================="
echo ""
echo "📚 Next steps:"
echo "1. Create a GitHub repository"
echo "2. Add your GitHub remote:"
echo "   git remote add origin https://github.com/YOUR_USERNAME/springboot-poc.git"
echo "3. Push your code:"
echo "   git branch -M main"
echo "   git push -u origin main"
echo "4. Go to GitHub Settings → Secrets and add:"
echo "   - DOCKER_USERNAME"
echo "   - DOCKER_PASSWORD"
echo "5. GitHub Actions will automatically start!"
echo ""
echo "📖 For detailed information:"
echo "   - Read CI-CD-GUIDE.md for step-by-step setup"
echo "   - Read DEPLOYMENT-GUIDE.md for deployment options"
echo "   - Read README.md for project overview"
echo ""
