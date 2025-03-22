# OneShot - Live Auction Platform

A real-time live auction platform built with Swift and Agora for video streaming.

## Project Structure

```
OneShot/
├── OneShot/              # Main application source code
├── OneShotTests/         # Unit tests
└── OneShotUITests/       # UI tests
```

## Development Setup

### Prerequisites
- Xcode 15.0+
- iOS 15.0+
- CocoaPods
- Agora SDK

### Installation
1. Clone the repository
   ```bash
   git clone https://github.com/twittermac/OneShot.git
   cd OneShot
   ```

2. Install dependencies:
   ```bash
   pod install
   ```

3. Open `OneShot.xcworkspace`
   ```bash
   open OneShot.xcworkspace
   ```

4. Build and run the project

## Development Workflow

### Branch Strategy
- `main`: Production branch
- `develop`: Development branch
- `feature/*`: Feature branches
- `hotfix/*`: Emergency fixes
- `release/*`: Release branches

### Making Changes
1. Create a feature branch:
   ```bash
   git checkout develop
   git checkout -b feature/your-feature-name
   ```

2. Make your changes and commit:
   ```bash
   # Update version if needed
   ./scripts/version.sh [major|minor|patch]
   
   # Commit changes
   git add .
   git commit -m "type(scope): description"
   ```

3. Push changes:
   ```bash
   git push origin feature/your-feature-name
   ```

4. Create a Pull Request on GitHub

### Commit Guidelines

We follow semantic commit messages:
```
type(scope): description

[optional body]
[optional footer]
```

Types:
- feat: New feature
- fix: Bug fix
- docs: Documentation
- style: Formatting
- refactor: Code restructuring
- test: Adding tests
- chore: Maintenance

## CI/CD Pipeline

Our CI/CD pipeline includes:
- Automated testing
- Code quality checks
- Build verification
- Deployment automation

## Backup Strategy

- Daily code repository backups
- Database backups
- Media file backups
- Configuration backups

## Monitoring

- Error tracking
- Performance monitoring
- User analytics
- System health checks

## Emergency Procedures

1. Issue Identification
2. Impact Assessment
3. Resolution Steps
4. Communication Plan
5. Post-mortem Analysis

## Contributing

1. Create a feature branch
2. Make your changes
3. Run tests
4. Submit a pull request
5. Get code review
6. Merge to develop

## License

[Your License Here] 