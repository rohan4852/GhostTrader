# Design Document

## Overview

The Chart Analysis Engine is implemented as a Chrome Extension (Manifest V3) that operates entirely within the popup context. The architecture follows a passive observer pattern with no content script injection, making it undetectable by trading platforms. The system captures screenshots of trading charts, sends them to Google Gemini AI with structured analysis rules, and displays actionable trading recommendations.

The design emphasizes:
- **Security**: API keys stored locally only, no cloud sync
- **Performance**: Optimized image capture and encoding
- **Reliability**: Comprehensive error handling and graceful degradation
- **Maintainability**: Modular class-based architecture with clear separation of concerns

## Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Chrome Extension Popup                   │
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  UI Manager  │  │   Storage    │  │    Image     │      │
│  │              │  │   Manager    │  │   Capture    │      │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘      │
│         │                  │                  │              │
│         └──────────────────┼──────────────────┘              │
│                            │                                 │
│                    ┌───────▼────────┐                        │
│                    │  Gemini API    │                        │
│                    │   Interface    │                        │
│                    └───────┬────────┘                        │
└────────────────────────────┼──────────────────────────────────┘
                             │
                             ▼
                  ┌──────────────────────┐
                  │  Google Gemini API   │
                  │  (1.5 Pro / Flash)   │
                  └──────────────────────┘
```

### Component Interaction Flow

```
User Action (Click Analyze)
    ↓
UI Manager (Show Loading)
    ↓
Storage Manager (Load API Key & Preferences)
    ↓
Image Capture (Screenshot Active Tab)
    ↓
Image Capture (Convert to Base64)
    ↓
Gemini API (Discover Available Models)
    ↓
Gemini API (Send Request with System Prompt + Image)
    ↓
Gemini API (Parse JSON Response)
    ↓
UI Manager (Display Result with Color Coding)
```

## Components and Interfaces

### 1. StorageManager Class

**Responsibility**: Manage persistent storage of API keys and user preferences using Chrome Storage API.

**Interface**:
```javascript
class StorageManager {
    static async saveApiKey(apiKey: string): Promise<void>
    static async loadApiKey(): Promise<string>
    static async saveTradingPreferences(asset: string, trend: string): Promise<void>
    static async loadTradingPreferences(): Promise<{asset: string, trend: string}>
}
```

**Storage Schema**:
- `geminiApiKey`: string (encrypted by Chrome)
- `tradingAsset`: string (e.g., "Real Pair (EUR/USD)")
- `tradingTrend`: string (e.g., "Bullish")

### 2. ImageCapture Class

**Responsibility**: Capture and process screenshots of the active browser tab.

**Interface**:
```javascript
class ImageCapture {
    static async captureVisibleTab(): Promise<string>  // Returns data URL
    static convertDataUrlToBase64(dataUrl: string): string  // Returns base64 string
}
```

**Implementation Details**:
- Uses `chrome.tabs.captureVisibleTab()` API
- Format: JPEG with 90% quality (balance between size and clarity)
- Removes data URL prefix to extract pure base64

### 3. GeminiAPI Class

**Responsibility**: Handle all communication with Google Gemini AI service.

**Interface**:
```javascript
class GeminiAPI {
    static async discoverAvailableModels(apiKey: string): Promise<string[]>
    static async sendAnalysisRequest(apiKey: string, imageBase64: string): Promise<object>
    static parseAnalysisResponse(apiResponse: object): Promise<AnalysisResult>
}
```

**AnalysisResult Type**:
```javascript
{
    decision: "BET UP" | "BET DOWN" | "NO TRADE",
    confidence: "HIGH CONFIDENCE" | "LOW CONFIDENCE",
    confidencePercentage: number,  // 0-100
    reason: string
}
```

**Model Discovery Strategy**:
1. Query both v1 and v1beta endpoints for available models
2. Filter models that support `generateContent` method
3. Exclude deprecated, experimental, and learnlm models
4. Prioritize flash models for faster response times
5. Fallback through model list if primary model fails

### 4. UIManager Class

**Responsibility**: Manage all UI state changes and user feedback.

**Interface**:
```javascript
class UIManager {
    static showError(message: string): void
    static hideError(): void
    static showLoading(show: boolean): void
    static displayResult(analysis: AnalysisResult): void
}
```

**UI States**:
- **Idle**: Ready for analysis
- **Loading**: Capturing and analyzing
- **Result**: Displaying recommendation
- **Error**: Showing error message

## Data Models

### System Prompt Structure

The system prompt is a hardcoded constant that defines the AI's analysis methodology:

```javascript
const SYSTEM_PROMPT = `
STEP-BY-STEP ANALYSIS:

1. Trend Bias (Local Structure)
   - Analyze last 8-10 candles
   - Identify HH/HL (Bullish) or LH/LL (Bearish)
   - Default to NO TRADE if uncertain

2. Candle Dominance (Recent Momentum)
   - Analyze last 5 candles
   - Count strong green vs red candles
   - Default to NO TRADE if mixed

3. Wick Rejection & Control (Last 3 Candles)
   - Check for rejection wicks at key zones
   - Identify control (bodies closing near highs/lows)
   - Default to NO TRADE if indecision

4. Key Zone Check (Support/Resistance)
   - Identify nearest support/resistance
   - Check if price is reacting or breaking
   - Default to NO TRADE if choppy

DECISION LOGIC (Confluence Check):
- BET UP: All 4 steps align bullish
- BET DOWN: All 4 steps align bearish
- NO TRADE: Any contradiction or uncertainty

OUTPUT FORMAT (JSON ONLY): {...}
`
```

### API Request Payload

```javascript
{
    contents: [{
        parts: [
            {
                text: SYSTEM_PROMPT
            },
            {
                inline_data: {
                    mime_type: "image/jpeg",
                    data: "<base64_encoded_image>"
                }
            }
        ]
    }]
}
```

### API Response Structure

```javascript
{
    candidates: [{
        content: {
            parts: [{
                text: "{\"decision\": \"BET UP\", \"confidence\": \"HIGH CONFIDENCE\", \"confidencePercentage\": 85, \"reason\": \"Clear HH/HL structure with bullish rejection\"}"
            }]
        }
    }]
}
```

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*


### Property Reflection

After reviewing all testable properties from the prework, I've identified the following consolidations:

- Properties 2.1 and 2.2 (storing asset type and trend) can be combined into a single property about storing user preferences
- Properties 5.2, 5.3, and 5.4 (extracting decision, confidence, reason) can be combined into a single property about complete response parsing
- Properties 6.4 and 6.5 (displaying confidence and reason) can be combined into a single property about displaying all result fields
- Properties 8.1 and 8.4 (saving and loading API key) are part of the round-trip property 8.2

### Core Properties

Property 1: Screenshot capture produces valid image data
*For any* active browser tab, when the analyze button is clicked, the screenshot capture should return a valid data URL in JPEG format
**Validates: Requirements 1.1, 1.2**

Property 2: Base64 encoding round trip
*For any* valid image data URL, converting to base64 and then decoding should produce equivalent image data
**Validates: Requirements 1.3**

Property 3: User preferences persistence
*For any* valid asset type and major trend selection, storing and then loading preferences should return the same values
**Validates: Requirements 2.1, 2.2**

Property 4: System prompt includes user context
*For any* asset type and major trend selection, the constructed system prompt should contain both values
**Validates: Requirements 2.5**

Property 5: API request structure completeness
*For any* valid system prompt and image data, the API request payload should include both the text prompt and inline image data with correct MIME type
**Validates: Requirements 4.2**

Property 6: API key inclusion in requests
*For any* API request, the user's API key should be present as a query parameter in the request URL
**Validates: Requirements 4.3**

Property 7: Response parsing extracts all required fields
*For any* valid JSON response from Gemini AI, parsing should successfully extract decision, confidence, and reason fields
**Validates: Requirements 5.2, 5.3, 5.4**

Property 8: Result display includes all fields
*For any* valid analysis result, the UI should display the decision, confidence percentage, and reason text
**Validates: Requirements 6.4, 6.5**

Property 9: Error logging for all failures
*For any* error that occurs during analysis, the error details should be logged to the browser console
**Validates: Requirements 7.5**

Property 10: API key storage round trip
*For any* valid API key string, saving to storage and then loading should return the same key value
**Validates: Requirements 8.1, 8.2, 8.4**

Property 11: Local storage isolation
*For any* API key storage operation, the system should use chrome.storage.local and never chrome.storage.sync
**Validates: Requirements 8.3**

## Error Handling

### Error Categories

1. **User Input Errors**
   - Missing API key
   - Invalid API key format
   - Empty selections

2. **Screenshot Capture Errors**
   - No active tab
   - Permission denied
   - Tab capture API failure

3. **API Communication Errors**
   - Network failures
   - HTTP 400 (Bad Request)
   - HTTP 401 (Unauthorized)
   - HTTP 429 (Rate Limit)
   - Timeout errors

4. **Response Processing Errors**
   - Invalid JSON format
   - Missing required fields
   - Unexpected response structure

5. **Storage Errors**
   - Storage quota exceeded
   - Permission denied
   - Corruption errors

### Error Handling Strategy

```javascript
try {
    // Operation
} catch (error) {
    console.error('Context:', error);
    UIManager.showError(getUserFriendlyMessage(error));
    // Graceful degradation - maintain UI state
}
```

### Error Messages

| Error Type | User Message | Technical Log |
|------------|--------------|---------------|
| Missing API Key | "Please enter your Gemini API Key" | N/A |
| Invalid API Key | "Invalid API key. Please check your key." | HTTP 401 response |
| Screenshot Failure | "Failed to capture chart image. Ensure a tab is active." | Chrome API error |
| Network Error | "Network error - check your connection" | Fetch error details |
| Parse Error | "Failed to parse AI response" | JSON parse error |
| Model Unavailable | "All available models failed. Please check your API key." | Model list and errors |

### Retry Logic

- **Screenshot Capture**: No retry (user can click again)
- **API Requests**: Automatic fallback through available models
- **Storage Operations**: Single attempt with error display

## Testing Strategy

### Unit Testing

The Chart Analysis Engine will use **Jest** as the testing framework for unit tests. Unit tests will focus on:

1. **Storage Operations**
   - Test saving and loading API keys
   - Test saving and loading preferences
   - Test handling of missing data

2. **Image Processing**
   - Test data URL to base64 conversion
   - Test handling of invalid image formats

3. **Response Parsing**
   - Test parsing valid JSON responses
   - Test extracting JSON from markdown code blocks
   - Test handling of missing fields

4. **UI State Management**
   - Test error display
   - Test loading state transitions
   - Test result display with different decision types

5. **Error Handling**
   - Test specific error messages for different failure types
   - Test console logging for errors

### Property-Based Testing

The Chart Analysis Engine will use **fast-check** as the property-based testing library. Property-based tests will verify universal properties across many randomly generated inputs:

1. **Configuration**: Each property test will run a minimum of 100 iterations
2. **Tagging**: Each test will include a comment with the format: `**Feature: chart-analysis-engine, Property {number}: {property_text}**`
3. **Coverage**: Each correctness property from the design document will have exactly one corresponding property-based test

**Property Test Examples**:

```javascript
// **Feature: chart-analysis-engine, Property 2: Base64 encoding round trip**
test('base64 encoding preserves image data', () => {
    fc.assert(
        fc.property(fc.string(), (dataUrl) => {
            const base64 = ImageCapture.convertDataUrlToBase64(dataUrl);
            const reconstructed = `data:image/jpeg;base64,${base64}`;
            return reconstructed === dataUrl;
        }),
        { numRuns: 100 }
    );
});

// **Feature: chart-analysis-engine, Property 3: User preferences persistence**
test('preferences round trip preserves values', async () => {
    fc.assert(
        fc.asyncProperty(
            fc.constantFrom('Real Pair (EUR/USD)', 'Synthetic (Asia Composite)'),
            fc.constantFrom('Bullish', 'Bearish', 'Ranging'),
            async (asset, trend) => {
                await StorageManager.saveTradingPreferences(asset, trend);
                const loaded = await StorageManager.loadTradingPreferences();
                return loaded.asset === asset && loaded.trend === trend;
            }
        ),
        { numRuns: 100 }
    );
});

// **Feature: chart-analysis-engine, Property 7: Response parsing extracts all required fields**
test('response parsing extracts all fields', () => {
    fc.assert(
        fc.property(
            fc.constantFrom('BET UP', 'BET DOWN', 'NO TRADE'),
            fc.constantFrom('HIGH CONFIDENCE', 'LOW CONFIDENCE'),
            fc.integer(0, 100),
            fc.string(),
            (decision, confidence, percentage, reason) => {
                const mockResponse = {
                    candidates: [{
                        content: {
                            parts: [{
                                text: JSON.stringify({ decision, confidence, confidencePercentage: percentage, reason })
                            }]
                        }
                    }]
                };
                const result = GeminiAPI.parseAnalysisResponse(mockResponse);
                return result.decision === decision &&
                       result.confidence === confidence &&
                       result.confidencePercentage === percentage &&
                       result.reason === reason;
            }
        ),
        { numRuns: 100 }
    );
});
```

### Integration Testing

Integration tests will verify the complete analysis flow:

1. **End-to-End Analysis Flow**
   - Mock Chrome APIs (tabs, storage)
   - Mock Gemini API responses
   - Verify complete flow from button click to result display

2. **Model Discovery and Fallback**
   - Test model discovery with various API responses
   - Test fallback behavior when primary model fails
   - Verify error handling when all models fail

3. **Storage Integration**
   - Test persistence across popup sessions
   - Verify data isolation (local vs sync storage)

### Test Organization

```
tests/
├── unit/
│   ├── storage.test.js
│   ├── image-capture.test.js
│   ├── gemini-api.test.js
│   └── ui-manager.test.js
├── property/
│   ├── encoding.property.test.js
│   ├── storage.property.test.js
│   ├── parsing.property.test.js
│   └── api-structure.property.test.js
└── integration/
    ├── analysis-flow.test.js
    └── model-fallback.test.js
```

## Security Considerations

### API Key Protection

1. **Storage**: API keys are stored in `chrome.storage.local`, which is:
   - Encrypted by Chrome
   - Never synced to cloud
   - Isolated per extension

2. **Transmission**: API keys are only sent to Google's Gemini API endpoint via HTTPS

3. **Display**: API key input field uses `type="password"` by default with toggle visibility

### Screenshot Privacy

1. **Local Processing**: Screenshots are captured and encoded locally in the browser
2. **No Persistence**: Images are not saved to disk or storage
3. **Single Use**: Each screenshot is used once and discarded after analysis

### Content Security

1. **No Content Scripts**: Extension does not inject code into web pages
2. **No DOM Access**: Extension cannot read or modify trading platform content
3. **Popup Isolation**: All logic runs in isolated popup context

### Permissions Justification

- `activeTab`: Required to capture screenshot of current tab
- `storage`: Required to save API key and preferences locally
- `scripting`: Required for popup functionality
- `host_permissions`: Limited to Google's Gemini API domain only

## Performance Optimization

### Image Capture

- **Format**: JPEG (smaller than PNG)
- **Quality**: 90% (balance between clarity and size)
- **Expected Size**: 100-500KB per screenshot
- **Capture Time**: ~400-600ms

### API Communication

- **Model Selection**: Prioritize flash models for faster response
- **Timeout**: 30 seconds for API requests
- **Retry Strategy**: Automatic fallback through model list
- **Expected Response Time**: 3-5 seconds

### UI Responsiveness

- **Async Operations**: All I/O operations are asynchronous
- **Loading States**: Immediate feedback for user actions
- **Error Recovery**: Graceful degradation without blocking UI

### Memory Management

- **Image Disposal**: Base64 strings are not retained after API call
- **Response Caching**: No caching (each analysis is independent)
- **Storage Limits**: Minimal data stored (< 1KB)

## Deployment Considerations

### Chrome Web Store Requirements

1. **Manifest V3**: Fully compliant with latest Chrome extension standards
2. **Permissions**: Minimal permissions requested
3. **Privacy Policy**: Required for API key storage
4. **Content Security Policy**: Default restrictive policy

### Version Management

- **Semantic Versioning**: MAJOR.MINOR.PATCH
- **Update Strategy**: Auto-update via Chrome Web Store
- **Backward Compatibility**: Storage schema versioning for future updates

### Monitoring and Analytics

- **Error Tracking**: Console logging for debugging
- **Usage Metrics**: Not implemented (privacy-first approach)
- **Performance Monitoring**: Client-side timing logs only

## Future Enhancements

### Potential Features

1. **Multiple Chart Analysis**: Analyze multiple charts simultaneously
2. **Historical Analysis**: Save and review past analyses
3. **Custom Rules**: Allow users to modify system prompt
4. **Model Selection**: Let users choose specific Gemini models
5. **Batch Processing**: Analyze charts at scheduled intervals
6. **Export Results**: Download analysis results as CSV/JSON

### Technical Improvements

1. **Caching**: Cache model discovery results
2. **Compression**: Compress images before sending
3. **Streaming**: Use streaming API for faster initial response
4. **Offline Mode**: Queue analyses when offline
5. **Multi-language**: Support for non-English prompts

### Architecture Evolution

1. **Background Service Worker**: Move heavy processing to background
2. **IndexedDB**: Store analysis history
3. **WebAssembly**: Faster image processing
4. **Progressive Enhancement**: Graceful degradation for older browsers


## UI Theme and Visual Design

### Halloween/Spooky Theme

The Chart Analysis Engine features a Halloween-inspired dark theme with atmospheric visual effects:

**Color Palette**:
- **Primary Accent**: Orange/Fire (#ff6b00) - Used for headers, labels, borders, and primary UI elements
- **Background**: Deep purple/black gradients (#0a0a0a, #1a0a1a, #2a0a2a)
- **Text**: Light gray (#d4d4d4, #b0b0b0)
- **Decision Colors**:
  - BET UP: Bright green (#00ff88) with glow
  - BET DOWN: Hot pink (#ff3366) with glow
  - NO TRADE: Orange (#ffaa00) with glow

**Visual Effects**:
- **Glowing Text**: All primary elements have text-shadow with orange glow (rgba(255, 107, 0, 0.4-0.6))
- **Box Shadows**: Multiple layered shadows for depth and atmospheric lighting
- **Animations**:
  - Floating animation on button emojis (👻 and 🔮)
  - Loading spinner with orange gradient
  - Hover effects with increased glow intensity

**Button Design**:
- **Text**: "SUMMON PREDICTION" (replaces "ANALYZE CHART")
- **Loading State**: "Summoning Spirits..." (replaces "Analyzing...")
- **Decorative Elements**: Ghost emoji (👻) on left, Crystal ball emoji (🔮) on right
- **Animation**: Floating effect on emojis (2s ease-in-out infinite)
- **Gradient**: Orange to dark orange (#ff6b00 to #cc4400)
- **Border**: 2px solid #ff8800
- **Shadow**: Multiple layers for glowing effect

**System Prompt Theme**:
The AI persona has been updated to "Ghost of Wall Street" - a 100-year-old spirit that provides technical analysis with spooky metaphors:
- Bullish: "Rising from the grave"
- Bearish: "Descending into the abyss"
- Uncertain: "Lost in the purgatory fog"
- Responses include haunted language while maintaining technical accuracy

**Accessibility Considerations**:
- Sufficient color contrast maintained despite dark theme
- Glowing effects enhance readability rather than obscure
- All interactive elements have clear hover states
- Button text remains readable with emoji decorations
