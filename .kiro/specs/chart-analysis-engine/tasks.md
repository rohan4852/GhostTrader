# Implementation Plan

- [ ] 1. Set up testing infrastructure
  - Install Jest and fast-check testing libraries
  - Configure Jest for Chrome extension environment with jsdom
  - Create test directory structure (unit/, property/, integration/)
  - Set up mock implementations for Chrome APIs (chrome.storage, chrome.tabs)
  - _Requirements: All (testing foundation)_

- [ ] 2. Implement and test StorageManager class
  - Create StorageManager class with saveApiKey and loadApiKey methods
  - Create saveTradingPreferences and loadTradingPreferences methods
  - Implement error handling for storage operations
  - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5_

- [ ]* 2.1 Write property test for API key storage round trip
  - **Property 10: API key storage round trip**
  - **Validates: Requirements 8.1, 8.2, 8.4**

- [ ]* 2.2 Write property test for user preferences persistence
  - **Property 3: User preferences persistence**
  - **Validates: Requirements 2.1, 2.2**

- [ ]* 2.3 Write property test for local storage isolation
  - **Property 11: Local storage isolation**
  - **Validates: Requirements 8.3**

- [ ]* 2.4 Write unit tests for storage error handling
  - Test handling of storage quota exceeded
  - Test handling of missing data (empty state)
  - _Requirements: 8.5_

- [ ] 3. Implement and test ImageCapture class
  - Create ImageCapture class with captureVisibleTab method using chrome.tabs API
  - Implement convertDataUrlToBase64 method to extract base64 from data URL
  - Add error handling for capture failures
  - _Requirements: 1.1, 1.2, 1.3, 1.4_

- [ ]* 3.1 Write property test for screenshot capture
  - **Property 1: Screenshot capture produces valid image data**
  - **Validates: Requirements 1.1, 1.2**

- [ ]* 3.2 Write property test for base64 encoding round trip
  - **Property 2: Base64 encoding round trip**
  - **Validates: Requirements 1.3**

- [ ]* 3.3 Write unit tests for image capture error handling
  - Test error message when no active tab
  - Test error message when capture fails
  - _Requirements: 1.4_

- [ ] 4. Implement system prompt construction
  - Create constant SYSTEM_PROMPT with 4-step analysis methodology
  - Implement function to inject asset type and major trend into prompt
  - Ensure prompt includes HH/HL and LH/LL pattern detection
  - Ensure prompt includes trap detection for large candles
  - Ensure prompt includes rejection wick analysis
  - _Requirements: 2.5, 3.1, 3.2, 3.3, 3.4, 3.5_

- [ ]* 4.1 Write property test for system prompt includes user context
  - **Property 4: System prompt includes user context**
  - **Validates: Requirements 2.5**

- [ ]* 4.2 Write unit tests for system prompt content
  - Test prompt contains conservative rules for Real Pair + Ranging
  - Test prompt contains instruction to ignore news for Synthetic
  - Test prompt contains HH/HL and LH/LL pattern instructions
  - Test prompt contains trap detection instructions
  - Test prompt contains rejection wick instructions
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_

- [ ] 5. Implement and test GeminiAPI class - model discovery
  - Create GeminiAPI class with discoverAvailableModels method
  - Query both v1 and v1beta endpoints for model lists
  - Filter models that support generateContent method
  - Exclude deprecated, experimental, and learnlm models
  - Sort models to prioritize flash models
  - _Requirements: 4.1_

- [ ]* 5.1 Write unit tests for model discovery
  - Test model discovery with mock API responses
  - Test filtering of deprecated models
  - Test prioritization of flash models
  - _Requirements: 4.1_

- [ ] 6. Implement and test GeminiAPI class - request sending
  - Create sendAnalysisRequest method that constructs API payload
  - Implement model fallback logic (try each discovered model)
  - Add timeout handling for API requests
  - Implement error handling for HTTP status codes (400, 401, 429)
  - _Requirements: 4.1, 4.2, 4.3, 4.5_

- [ ]* 6.1 Write property test for API request structure completeness
  - **Property 5: API request structure completeness**
  - **Validates: Requirements 4.2**

- [ ]* 6.2 Write property test for API key inclusion in requests
  - **Property 6: API key inclusion in requests**
  - **Validates: Requirements 4.3**

- [ ]* 6.3 Write unit tests for API error handling
  - Test error message for missing API key
  - Test error message for 401 (invalid API key)
  - Test error message for 400 (bad request)
  - Test error message for network failures
  - _Requirements: 4.5, 7.1, 7.2, 7.3, 7.4_

- [ ] 7. Implement and test GeminiAPI class - response parsing
  - Create parseAnalysisResponse method to extract JSON from response
  - Implement fallback to extract JSON from markdown code blocks
  - Validate and extract decision field (BET UP, BET DOWN, NO TRADE)
  - Validate and extract confidence field
  - Validate and extract confidencePercentage as integer (0-100)
  - Validate and extract reason field
  - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_

- [ ]* 7.1 Write property test for response parsing extracts all required fields
  - **Property 7: Response parsing extracts all required fields**
  - **Validates: Requirements 5.2, 5.3, 5.4**

- [ ]* 7.2 Write unit tests for response parsing edge cases
  - Test parsing JSON from markdown code blocks
  - Test handling of missing required fields
  - Test handling of invalid JSON
  - _Requirements: 5.5_

- [ ] 8. Implement and test UIManager class
  - Create UIManager class with showError and hideError methods
  - Implement showLoading method to toggle loading spinner
  - Implement displayResult method to show analysis results
  - Add color coding for decisions (green for BET UP, red for BET DOWN, orange for NO TRADE)
  - Ensure all result fields are displayed (decision, confidence, reason)
  - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5_

- [ ]* 8.1 Write property test for result display includes all fields
  - **Property 8: Result display includes all fields**
  - **Validates: Requirements 6.4, 6.5**

- [ ]* 8.2 Write unit tests for UI state management
  - Test error display and hiding
  - Test loading state transitions
  - Test result display with BET UP (green color)
  - Test result display with BET DOWN (red color)
  - Test result display with NO TRADE (orange color)
  - _Requirements: 6.1, 6.2, 6.3_

- [ ] 9. Implement error logging
  - Add console.error logging to all catch blocks
  - Ensure error details are logged for debugging
  - Implement getUserFriendlyMessage function to convert technical errors to user messages
  - _Requirements: 7.5_

- [ ]* 9.1 Write property test for error logging
  - **Property 9: Error logging for all failures**
  - **Validates: Requirements 7.5**

- [ ] 10. Wire up event listeners and main analysis flow
  - Implement DOMContentLoaded listener to load saved API key on popup open
  - Implement API key input blur listener to save API key
  - Implement toggle API key visibility button
  - Implement analyze button click listener with complete flow:
    - Validate API key is present
    - Show loading state
    - Capture screenshot via ImageCapture
    - Convert to base64
    - Send to Gemini via GeminiAPI
    - Parse response
    - Display result via UIManager
    - Handle errors gracefully
  - _Requirements: 1.5, 4.4, 8.2, 8.4_

- [ ]* 10.1 Write integration tests for complete analysis flow
  - Test end-to-end flow from button click to result display
  - Test model discovery and fallback behavior
  - Test error handling in complete flow
  - _Requirements: All_

- [ ] 11. Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 12. Create manifest.json and HTML/CSS files
  - Create manifest.json with Manifest V3 configuration
  - Add required permissions (activeTab, storage, scripting)
  - Add host_permissions for generativelanguage.googleapis.com
  - Create popup.html with UI structure
  - Create styles.css with dark trading dashboard theme
  - _Requirements: All (UI and configuration)_

- [ ]* 12.1 Write unit tests for manifest validation
  - Test manifest has correct permissions
  - Test manifest has correct host_permissions
  - Test manifest is valid JSON

- [ ] 13. Final testing and validation
  - Manually test extension loading in Chrome
  - Test API key save and load functionality
  - Test screenshot capture with real trading charts
  - Test complete analysis flow with real Gemini API
  - Verify error handling with invalid inputs
  - Test UI responsiveness and color coding
  - _Requirements: All_

- [ ] 14. Final Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.
