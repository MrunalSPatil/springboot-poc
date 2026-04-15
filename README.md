# Spring Boot POC with CI/CD Pipeline

A simple Spring Boot application demonstrating a complete CI/CD pipeline setup using GitHub Actions, Docker, and cloud deployment options.

## Project Structure

```
springboot-poc/
├── src/
│   ├── main/
│   │   ├── java/com/example/demo/
│   │   │   ├── DemoApplication.java
│   │   │   └── HelloController.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
│       └── java/com/example/demo/
│           └── HelloControllerTest.java
├── .github/workflows/
│   └── ci-cd-pipeline.yml
├── Dockerfile
├── docker-compose.yml
├── pom.xml
├── CI-CD-GUIDE.md
├── DEPLOYMENT-GUIDE.md
└── README.md
```

## Quick Start

### Prerequisites
- Java 17+
- Maven 3.8+
- Docker (optional)
- Git

### Local Development

1. **Clone the repository**
```bash
git clone https://github.com/your-username/springboot-poc.git
cd springboot-poc
```

2. **Build the project**
```bash
mvn clean install
```

3. **Run the application**
```bash
mvn spring-boot:run
```

4. **Access the application**
```
http://localhost:8080
```

### Running Tests

```bash
# Run all tests
mvn test

# Run with coverage
mvn test jacoco:report
```

### Building and Running with Docker

```bash
# Build Docker image
docker build -t demo:latest .

# Run container
docker run -p 8080:8080 demo:latest

# Or use Docker Compose
docker-compose up -d
```

## API Endpoints

- `GET /hello` - Hello endpoint
- `GET /actuator/health` - Health check
- `GET /actuator/metrics` - Application metrics
- `GET /actuator/info` - Application info

## CI/CD Pipeline

### Automated Stages

1. **Build & Test**
   - Compile code with Maven
   - Run all unit tests
   - Generate test coverage report

2. **Code Quality**
   - Run security scanning with Trivy
   - SAST analysis

3. **Docker Build**
   - Build multi-stage Docker image
   - Push to Docker Hub

4. **Deploy**
   - Deploy to cloud platform (configurable)

### Setup Instructions

Follow the [CI-CD-GUIDE.md](CI-CD-GUIDE.md) for complete setup instructions.

## Deployment

Multiple deployment options are supported:
- **AWS ECS** - Elastic Container Service
- **Azure Container Instances** - ACI
- **Google Cloud Run** - Fully managed serverless
- **Kubernetes** - K8s clusters
- **Docker Compose** - Local/VM deployment
- **Heroku** - Simple PaaS

See [DEPLOYMENT-GUIDE.md](DEPLOYMENT-GUIDE.md) for detailed instructions.

## Project Configuration

### Maven (pom.xml)
- Spring Boot 3.2.0
- Spring Web
- Spring Actuator
- JUnit 5
- JaCoCo (Code Coverage)

### Java
- Target Version: 17
- Source Version: 17

### Application Properties
Edit `src/main/resources/application.properties` to configure:
- Server port
- Logging levels
- Actuator endpoints
- Application metadata

## Development

### Adding Dependencies

Edit `pom.xml` and add:
```xml
<dependency>
    <groupId>...</groupId>
    <artifactId>...</artifactId>
    <version>...</version>
</dependency>
```

Then run: `mvn clean install`

### Writing Tests

Follow the example in `HelloControllerTest.java`:
```java
@WebMvcTest(YourController.class)
public class YourControllerTest {
    @Autowired
    private MockMvc mockMvc;
    
    @Test
    public void testEndpoint() throws Exception {
        mockMvc.perform(get("/endpoint"))
               .andExpect(status().isOk());
    }
}
```

## Monitoring

### Health Checks
- Liveness: `/actuator/health/live`
- Readiness: `/actuator/health/readiness`

### Metrics
View metrics at: `/actuator/metrics`

## Security

- Application runs as non-root user in Docker
- Secrets managed via GitHub Secrets
- SAST scanning enabled
- Dependency vulnerability scanning

## Contributing

1. Create a feature branch: `git checkout -b feature/new-feature`
2. Make changes and test locally: `mvn test`
3. Commit with clear messages
4. Push and create a Pull Request

## Troubleshooting

### Build Fails
```bash
# Clear cache and rebuild
mvn clean install -U
```

### Tests Fail
```bash
# Run tests with verbose output
mvn test -X
```

### Docker Issues
```bash
# Rebuild from scratch
docker build --no-cache -t demo:latest .
```

## Resources

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Docs](https://docs.docker.com/)
- [Maven Docs](https://maven.apache.org/)

## License

MIT License - see LICENSE file for details

## Support

For issues, questions, or improvements:
1. Check existing GitHub issues
2. Create a new issue with detailed description
3. Submit a Pull Request with fixes

---

**Happy coding! 🚀**
