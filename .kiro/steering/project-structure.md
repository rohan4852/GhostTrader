---
inclusion: always
---

# AITrader Project Structure

## Project Overview

AITrader is a Chrome Extension (Manifest V3) that provides passive chart analysis using Google Gemini AI. The extension operates entirely within the popup context with no content script injection, making it undetectable by trading platforms.

## Directory Structure

```
AITrader/
├── .kiro/
│   ├── specs/
│   │   └── chart-analysis-engine/
│   │       ├── requirements.md
│   │       ├── design.md
│   │       └── tasks.md
│   ├── hooks/
│   │   ├── test-on-save.json
│   │   ├── validate-manifest.json
│   │   ├── security-review.json
│   │   └── pre-release-checklist.json
│   └── steering/
│       ├── chrome-extension-standards.md
│       ├── gemini-api-integration.md
│       ├── trading-analysis-domain.md
│       └── project-structure.md
├── tests/
│   ├── unit/
│   │   ├── storage.test.js
│   │   ├── image-capture.test.js
│   │   ├── gemini-api.test.js
│   │   └── ui-manager.test.js
│   ├── property/
│   │   ├── encoding.property.test.js
│   │   ├── storage.property.test.js
│   │   ├── parsing.property.test.js
│   │   └── api-structure.property.test.js
│   └── integration/
│       ├── analysis-flow.test.js
│       └── model-fallback.test.js
├── manifest.json
├── popup.html
├── popup.js
├── styles.css
├── package.json
├── jest.config.js
├── README.md
├── QUICKSTART.md
├── TECHNICAL_REFERENCE.md
└── CHANGELOG.md
```

## Core Files

### manifest.json

Chrome extension configuration file (Manifest V3):

- **Purpose**: Defines extension metadata, permissions, and entry points
- **Key Fields**:
  - `manifest_version: 3`
  - `permissions`: activeTab, storage, scripting
  - `host_permissions`: Google Gemini API domain
  - `action.default_popup`: popup.html

### popup.html

User interface markup:

- **Purpose**: Defines the extension popup UI structure
- **Components**:
  - API key input with show/hide toggle
  - Asset type dropdown (Real Pair, Synthetic)
  - Major trend dropdown (Bullish, Bearish, Ranging)
  - "Summon Prediction" button (Halloween-themed with ghost and crystal ball emojis)
  - Loading spinner with orange glow
  - Result display area with spooky styling
  - Error display area with pink/red glow

### popup.js

Core application logic:

- **Purpose**: Implements all extension functionality
- **Classes**:
  - `StorageManager`: API key and preferences persistence
  - `ImageCapture`: Screenshot capture and encoding
  - `GeminiAPI`: API communication and response parsing
  - `UIManager`: UI state management with spooky loading states
- **Constants**:
  - `SYSTEM_PROMPT`: "Ghost of Wall Street" persona - Trading analysis with spooky metaphors
  - `DOM`: References to HTML elements
- **UI Text**:
  - Button: "SUMMON PREDICTION"
  - Loading: "Summoning Spirits..."

### styles.css

Visual styling:

- **Purpose**: Halloween/Spooky dark theme
- **Features**:
  - Deep purple/black gradient backgrounds (#0a0a0a, #1a0a1a, #2a0a2a)
  - Orange/fire accent color (#ff6b00) with glowing effects
  - Color-coded decisions with glow: green (#00ff88), pink (#ff3366), orange (#ffaa00)
  - Floating animations on button emojis (👻 🔮)
  - Text shadows and atmospheric lighting throughout
  - Responsive design with spooky aesthetics

## Testing Files

### jest.config.js

Jest testing framework configuration:

- **Purpose**: Configure test environment for Chrome extension
- **Settings**:
  - Test environment: jsdom
  - Coverage thresholds
  - Mock setup files

### tests/unit/

Unit tests for individual components:

- **storage.test.js**: StorageManager class tests
- **image-capture.test.js**: ImageCapture class tests
- **gemini-api.test.js**: GeminiAPI class tests
- **ui-manager.test.js**: UIManager class tests

### tests/property/

Property-based tests using fast-check:

- **encoding.property.test.js**: Base64 encoding properties
- **storage.property.test.js**: Storage round-trip properties
- **parsing.property.test.js**: Response parsing properties
- **api-structure.property.test.js**: API request structure properties

### tests/integration/

Integration tests for complete flows:

- **analysis-flow.test.js**: End-to-end analysis flow
- **model-fallback.test.js**: Model discovery and fallback

## Documentation Files

### README.md

Main documentation:

- **Purpose**: Comprehensive project documentation
- **Sections**:
  - Features overview
  - Installation instructions
  - Usage guide
  - File structure
  - Security notes
  - Troubleshooting
  - API details

### QUICKSTART.md

Quick setup guide:

- **Purpose**: Get users started in 5 minutes
- **Content**: Minimal steps to install and use

### TECHNICAL_REFERENCE.md

Technical details:

- **Purpose**: Deep dive into implementation
- **Content**: API details, architecture, code examples

### CHANGELOG.md

Version history:

- **Purpose**: Track changes between versions
- **Format**: Semantic versioning with categorized changes

## Configuration Files

### package.json

Node.js project configuration:

- **Purpose**: Define dependencies and scripts
- **Dependencies**:
  - jest (testing framework)
  - fast-check (property-based testing)
  - @types/chrome (TypeScript definitions)
- **Scripts**:
  - `test`: Run all tests
  - `test:unit`: Run unit tests only
  - `test:property`: Run property tests only
  - `test:watch`: Run tests in watch mode

## Development Workflow

### Adding New Features

1. Update requirements.md in specs/
2. Update design.md with architecture changes
3. Update tasks.md with implementation steps
4. Implement feature in popup.js
5. Write unit tests
6. Write property tests (if applicable)
7. Update documentation
8. Test manually in Chrome

### Making Changes

1. Create feature branch
2. Make changes
3. Run tests: `npm test`
4. Update CHANGELOG.md
5. Commit with descriptive message
6. Create pull request

### Testing Workflow

1. Write tests first (TDD approach)
2. Implement feature
3. Run tests: `npm test`
4. Check coverage: `npm run test:coverage`
5. Fix any failing tests
6. Manual testing in Chrome

### Release Workflow

1. Update version in manifest.json
2. Update CHANGELOG.md
3. Run full test suite
4. Manual testing checklist
5. Security review
6. Create git tag
7. Build extension package
8. Submit to Chrome Web Store

## File Naming Conventions

- **JavaScript**: camelCase (e.g., `popup.js`, `imageCapture.js`)
- **CSS**: kebab-case (e.g., `styles.css`)
- **HTML**: kebab-case (e.g., `popup.html`)
- **Tests**: `*.test.js` for unit tests, `*.property.test.js` for property tests
- **Documentation**: UPPERCASE.md for main docs, kebab-case.md for guides

## Code Organization Principles

1. **Separation of Concerns**
   - Each class has single responsibility
   - UI logic separate from business logic
   - Storage separate from processing

2. **Modularity**
   - Classes are independent
   - Easy to test in isolation
   - Easy to replace or extend

3. **Error Handling**
   - Try-catch in all async operations
   - User-friendly error messages
   - Technical details logged to console

4. **Testability**
   - Pure functions where possible
   - Dependency injection for testing
   - Mock-friendly architecture

## Dependencies

### Runtime Dependencies

- **None**: Pure vanilla JavaScript, no external libraries

### Development Dependencies

- **jest**: Testing framework
- **fast-check**: Property-based testing library
- **@types/chrome**: TypeScript definitions for Chrome APIs

### Why No Runtime Dependencies?

- Faster load times
- Smaller extension size
- No security vulnerabilities from dependencies
- Easier to audit and maintain
- Chrome extension best practice

## Build Process

### No Build Step Required

This extension uses pure JavaScript with no transpilation or bundling:

- No webpack/rollup/vite
- No TypeScript compilation
- No CSS preprocessing
- No minification (for development)

### For Production

Optional optimizations:

1. Minify JavaScript (optional)
2. Minify CSS (optional)
3. Optimize images (if any)
4. Remove console.log statements

## Chrome Extension Specifics

### Popup Lifecycle

1. User clicks extension icon
2. popup.html loads
3. popup.js executes
4. DOMContentLoaded event fires
5. Load saved API key from storage
6. User interacts with UI
7. User closes popup (state is lost)

### Storage Persistence

- API key persists across sessions
- Preferences persist across sessions
- UI state does NOT persist (resets on close)

### Permissions Usage

- **activeTab**: Used for screenshot capture
- **storage**: Used for API key and preferences
- **scripting**: Used for popup functionality
- **host_permissions**: Used for Gemini API calls

## Security Considerations

### Sensitive Data

- API keys stored in chrome.storage.local (encrypted)
- Screenshots not persisted (memory only)
- No user tracking or analytics

### External Communications

- Only communicates with Google Gemini API
- All requests over HTTPS
- No third-party services

### Code Security

- No eval() or new Function()
- No inline scripts
- Input validation on all user inputs
- Output sanitization before display

## Performance Considerations

### Optimization Strategies

1. **Image Optimization**
   - JPEG format (smaller than PNG)
   - 90% quality (balance size/quality)
   - No unnecessary processing

2. **API Efficiency**
   - Model discovery cached per session
   - Automatic fallback for reliability
   - Timeout handling

3. **Memory Management**
   - Clear large data after use
   - No memory leaks in event listeners
   - Efficient DOM manipulation

### Performance Targets

- Popup load: < 100ms
- Screenshot capture: < 1000ms
- Total analysis: < 10 seconds
- Memory usage: < 50MB

## Maintenance

### Regular Tasks

- Update dependencies monthly
- Review security advisories
- Test with latest Chrome version
- Update documentation as needed

### Monitoring

- Check Chrome Web Store reviews
- Monitor error reports
- Track API usage and costs
- Review performance metrics

### Support

- Respond to user issues
- Update FAQ based on common questions
- Improve error messages based on feedback
- Add features based on user requests
