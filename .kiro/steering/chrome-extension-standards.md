---
inclusion: always
---

# Chrome Extension Development Standards

## Manifest V3 Requirements

This project uses Chrome Extension Manifest V3. Always ensure:

1. **Manifest Structure**
   - Use `manifest_version: 3`
   - Include `name`, `version`, `description`
   - Use `action` instead of `browser_action` or `page_action`
   - Use service workers instead of background pages

2. **Permissions**
   - Request minimal permissions necessary
   - Use `activeTab` instead of broad `tabs` permission when possible
   - Justify each permission in code comments
   - Use `host_permissions` for external API calls

3. **Content Security Policy**
   - No inline scripts in HTML
   - No `eval()` or `new Function()`
   - All scripts must be in separate .js files

## Security Best Practices

1. **API Key Management**
   - Store API keys in `chrome.storage.local` (encrypted by Chrome)
   - Never use `chrome.storage.sync` for sensitive data
   - Never hardcode API keys in source code
   - Use `type="password"` for API key input fields

2. **Data Privacy**
   - Minimize data collection
   - Never send user data to third parties (except necessary APIs)
   - Clear temporary data after use
   - Document data handling in privacy policy

3. **XSS Prevention**
   - Use `textContent` instead of `innerHTML` when possible
   - Sanitize any user input before rendering
   - Validate all data from external APIs

## Code Organization

1. **Class-Based Architecture**
   - Use ES6 classes for logical grouping
   - Keep classes focused on single responsibility
   - Use static methods for utility functions

2. **Error Handling**
   - Wrap all async operations in try-catch
   - Log errors to console for debugging
   - Show user-friendly error messages
   - Never expose technical details to users

3. **Async/Await**
   - Prefer async/await over promises
   - Always handle promise rejections
   - Use Promise.all() for parallel operations

## Testing Standards

1. **Unit Tests**
   - Test each class method independently
   - Mock Chrome APIs using jest.mock()
   - Test error conditions and edge cases
   - Aim for >80% code coverage

2. **Property-Based Tests**
   - Use fast-check for property testing
   - Run minimum 100 iterations per property
   - Tag tests with feature and property number
   - Test universal properties, not specific examples

3. **Integration Tests**
   - Test complete user flows
   - Mock external API calls
   - Verify UI state changes
   - Test error recovery

## Performance Guidelines

1. **Image Optimization**
   - Use JPEG for screenshots (smaller than PNG)
   - Balance quality vs file size (90-95% quality)
   - Don't persist images unnecessarily

2. **API Efficiency**
   - Implement timeout for API calls
   - Use model fallback for reliability
   - Don't retry failed requests automatically (let user retry)

3. **Memory Management**
   - Clear large data structures after use
   - Avoid memory leaks in event listeners
   - Use weak references where appropriate

## UI/UX Standards

1. **Loading States**
   - Show loading indicator for async operations
   - Disable buttons during processing
   - Provide progress feedback for long operations

2. **Error Messages**
   - Be specific about what went wrong
   - Suggest corrective actions
   - Use friendly, non-technical language
   - Log technical details to console

3. **Accessibility**
   - Use semantic HTML elements
   - Provide alt text for images
   - Ensure keyboard navigation works
   - Use sufficient color contrast

## Documentation

1. **Code Comments**
   - Document complex logic
   - Explain "why" not "what"
   - Keep comments up to date
   - Use JSDoc for function documentation

2. **README**
   - Include installation instructions
   - Document all features
   - Provide troubleshooting guide
   - Include screenshots

3. **Version Control**
   - Use semantic versioning (MAJOR.MINOR.PATCH)
   - Document changes in CHANGELOG
   - Tag releases in git
