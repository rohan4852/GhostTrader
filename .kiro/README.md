# Kiro Configuration for AITrader

This directory contains Kiro-specific configuration files for the AITrader Chrome Extension project.

## Contents

### 📋 Specs

Located in `.kiro/specs/chart-analysis-engine/`:

- **requirements.md**: Complete requirements document with 9 user stories and 45 acceptance criteria following EARS (Easy Approach to Requirements Syntax) and INCOSE quality standards
- **design.md**: Comprehensive design document including architecture, components, data models, 11 correctness properties, error handling, and testing strategy
- **tasks.md**: Implementation plan with 14 top-level tasks and multiple sub-tasks, organized for incremental development

### 🪝 Agent Hooks

Located in `.kiro/hooks/`:

1. **test-on-save.json**: Automatically runs relevant tests when JavaScript files are saved
2. **validate-manifest.json**: Validates manifest.json structure and permissions when modified
3. **theme-consistency-check.json**: Verifies Halloween theme consistency when UI files are modified
4. **security-review.json**: Manual trigger for comprehensive security review
5. **pre-release-checklist.json**: Manual trigger for pre-release verification checklist

### 🎯 Agent Steering

Located in `.kiro/steering/`:

1. **chrome-extension-standards.md**: Chrome Extension Manifest V3 best practices, security guidelines, code organization, testing standards, and documentation requirements
2. **gemini-api-integration.md**: Comprehensive guide for integrating with Google Gemini API including endpoint structure, model selection, request/response handling, error codes, and prompt engineering
3. **trading-analysis-domain.md**: Trading domain knowledge including chart patterns, candlestick analysis, support/resistance, confluence analysis, and decision framework
4. **project-structure.md**: Complete project structure documentation, file organization, development workflow, and maintenance guidelines
5. **halloween-theme-guide.md**: Halloween/spooky theme design guide with color palette, visual effects, animations, AI persona guidelines, and consistency standards

## How to Use

### Working with Specs

1. **Review Requirements**: Start by reading `specs/chart-analysis-engine/requirements.md` to understand what the system should do
2. **Understand Design**: Review `specs/chart-analysis-engine/design.md` for architecture and implementation details
3. **Execute Tasks**: Open `specs/chart-analysis-engine/tasks.md` in Kiro and click "Start task" next to any task to begin implementation

### Using Agent Hooks

- **Automatic Hooks**: test-on-save, validate-manifest, and theme-consistency-check run automatically when you save files
- **Manual Hooks**: Use the command palette or Agent Hooks view to trigger security-review and pre-release-checklist

### Leveraging Agent Steering

All steering files are automatically included in Kiro's context when you interact with the agent. They provide:

- Best practices for Chrome extension development
- Guidelines for Gemini API integration
- Trading domain knowledge for analysis features
- Project structure and workflow guidance

## Spec-Driven Development Workflow

1. **Requirements Phase**: Define what needs to be built (COMPLETED ✅)
2. **Design Phase**: Plan how to build it (COMPLETED ✅)
3. **Implementation Phase**: Build it following the task list
4. **Testing Phase**: Verify correctness with unit and property-based tests
5. **Deployment Phase**: Release to Chrome Web Store

## Key Features of This Configuration

### Requirements Document

- 9 comprehensive user stories covering all aspects of chart analysis
- 45 EARS-compliant acceptance criteria
- Clear glossary of domain terms
- Covers functionality, security, performance, and error handling

### Design Document

- Modular class-based architecture (StorageManager, ImageCapture, GeminiAPI, UIManager)
- 11 correctness properties for property-based testing
- Comprehensive error handling strategy
- Security and performance considerations
- Testing strategy with Jest and fast-check

### Task List

- 14 main tasks with sub-tasks
- Optional test tasks marked with * for faster MVP
- Clear requirements traceability
- Checkpoint tasks to ensure quality
- Property-based test tasks linked to design properties

### Agent Hooks

- Automated testing on file save
- Manifest validation on changes
- Halloween theme consistency checks
- Security review checklist
- Pre-release verification

### Agent Steering

- Chrome Extension Manifest V3 standards
- Gemini API integration best practices
- Trading analysis domain knowledge
- Project structure and conventions

## Testing Strategy

### Unit Tests (Jest)

- Test individual components in isolation
- Mock Chrome APIs
- Test error conditions
- Target >80% code coverage

### Property-Based Tests (fast-check)

- Test universal properties across many inputs
- Minimum 100 iterations per property
- Each correctness property has one test
- Tagged with feature and property number

### Integration Tests

- Test complete user flows
- Mock external APIs
- Verify UI state changes
- Test error recovery

## Next Steps

1. **Start Implementation**: Open `specs/chart-analysis-engine/tasks.md` and begin with Task 1
2. **Run Tests**: Execute tests as you implement features
3. **Use Hooks**: Let automatic hooks help maintain quality
4. **Reference Steering**: Consult steering files for best practices
5. **Iterate**: Update specs as you learn and refine requirements

## Documentation

All documentation follows these principles:

- **Clear**: Easy to understand for developers
- **Comprehensive**: Covers all aspects of the system
- **Actionable**: Provides specific guidance
- **Maintainable**: Easy to update as project evolves

## Support

For questions about:

- **Specs**: Review the requirements and design documents
- **Implementation**: Check the task list and steering files
- **Testing**: Refer to the testing strategy in design.md
- **Chrome Extensions**: See chrome-extension-standards.md
- **Gemini API**: See gemini-api-integration.md
- **Trading Analysis**: See trading-analysis-domain.md

---

**Created**: December 5, 2025
**Project**: AITrader Chrome Extension
**Version**: 1.0.0
