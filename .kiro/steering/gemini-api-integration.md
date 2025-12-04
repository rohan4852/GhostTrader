---
inclusion: always
---

# Gemini API Integration Guidelines

## API Configuration

### Endpoint Structure

```
https://generativelanguage.googleapis.com/{version}/models/{model}:generateContent?key={apiKey}
```

- **Version**: Use `v1beta` for latest features, `v1` for stable
- **Model**: Discover available models dynamically, prefer flash models
- **API Key**: Pass as query parameter, never in headers

## Model Selection Strategy

1. **Discovery First**
   - Always query available models before making requests
   - Cache model list for session (don't query every request)
   - Filter out deprecated and experimental models

2. **Prioritization**
   - Prefer `gemini-*-flash` models (faster, cheaper)
   - Fall back to `gemini-*-pro` models if flash unavailable
   - Sort by version number (newer is better)

3. **Fallback Logic**
   - Try each discovered model in order
   - If model returns deprecation error, skip to next
   - If all models fail, show clear error to user

## Request Structure

### Multimodal Requests (Text + Image)

```javascript
{
  contents: [{
    parts: [
      { text: "Your prompt here" },
      {
        inline_data: {
          mime_type: "image/jpeg",
          data: "base64_encoded_image"
        }
      }
    ]
  }]
}
```

### Best Practices

1. **Image Format**
   - Use JPEG for photos/screenshots (smaller)
   - Use PNG for diagrams/text (better quality)
   - Keep images under 4MB
   - Use 90-95% quality for JPEG

2. **Prompt Engineering**
   - Be specific and structured
   - Use step-by-step instructions
   - Request specific output format (JSON)
   - Include examples if needed

3. **System Prompts**
   - Define role clearly ("You are a market analyst")
   - List rules explicitly
   - Specify output format
   - Include edge case handling

## Response Handling

### Expected Response Structure

```javascript
{
  candidates: [{
    content: {
      parts: [{
        text: "Response text here"
      }]
    },
    finishReason: "STOP",
    safetyRatings: [...]
  }]
}
```

### Parsing Strategy

1. **Extract Text**
   - Navigate: `response.candidates[0].content.parts[0].text`
   - Check for null/undefined at each level
   - Handle empty candidates array

2. **JSON Extraction**
   - Try direct JSON.parse() first
   - If fails, look for markdown code blocks: ```json ... ```
   - Use regex: `/\{[\s\S]*\}/` to extract JSON
   - Validate required fields after parsing

3. **Error Handling**
   - Check `response.error` field
   - Handle specific error codes (400, 401, 429)
   - Provide user-friendly error messages

## Error Codes and Handling

| Code | Meaning | User Message | Action |
|------|---------|--------------|--------|
| 400 | Bad Request | "Invalid request. Please try again." | Check payload structure |
| 401 | Unauthorized | "Invalid API key. Please check your key." | Verify API key |
| 403 | Forbidden | "Access denied. Check API permissions." | Check API key permissions |
| 429 | Rate Limit | "Too many requests. Please wait." | Implement backoff |
| 500 | Server Error | "Service temporarily unavailable." | Retry with backoff |

## Rate Limiting

1. **Free Tier Limits**
   - 60 requests per minute
   - 1,500 requests per day
   - Monitor usage in Google AI Studio

2. **Handling Rate Limits**
   - Don't implement automatic retry (let user retry)
   - Show clear message about rate limits
   - Suggest waiting before retrying

3. **Best Practices**
   - Debounce user actions
   - Don't send requests on every keystroke
   - Cache results when appropriate

## Security Considerations

1. **API Key Protection**
   - Never commit API keys to git
   - Store in chrome.storage.local only
   - Never log API keys to console
   - Mask API keys in UI (use password input)

2. **Request Validation**
   - Validate API key format before sending
   - Check image size before encoding
   - Sanitize user inputs in prompts

3. **Response Validation**
   - Validate response structure
   - Sanitize response before displaying
   - Handle unexpected response formats

## Testing with Gemini API

1. **Unit Tests**
   - Mock API responses
   - Test parsing logic with various response formats
   - Test error handling for each error code

2. **Integration Tests**
   - Use test API key (separate from production)
   - Test with real API in CI/CD
   - Monitor API usage during tests

3. **Manual Testing**
   - Test with various image types
   - Test with different prompt lengths
   - Test error scenarios (invalid key, rate limit)

## Prompt Engineering for Trading Analysis

### Structure

1. **Role Definition**
   ```
   You are an ultra-precise, systematic market analyst.
   You are emotionless and 100% data-driven.
   ```

2. **Step-by-Step Instructions**
   ```
   STEP 1: Analyze trend bias (last 8-10 candles)
   STEP 2: Analyze candle dominance (last 5 candles)
   STEP 3: Analyze wick rejection (last 3 candles)
   STEP 4: Check key zones (support/resistance)
   ```

3. **Decision Logic**
   ```
   BET UP: All 4 steps align bullish
   BET DOWN: All 4 steps align bearish
   NO TRADE: Any contradiction or uncertainty
   ```

4. **Output Format**
   ```json
   {
     "decision": "BET UP" | "BET DOWN" | "NO TRADE",
     "confidence": "HIGH CONFIDENCE" | "LOW CONFIDENCE",
     "confidencePercentage": 0-100,
     "reason": "One-line explanation"
   }
   ```

### Best Practices

- Use clear, unambiguous language
- Provide specific criteria for decisions
- Request structured output (JSON)
- Include default behavior (NO TRADE when uncertain)
- Test prompts with various chart types
- Iterate based on response quality

## Performance Optimization

1. **Image Optimization**
   - Compress images before sending
   - Use appropriate quality settings
   - Consider image dimensions (don't send 4K screenshots)

2. **Request Optimization**
   - Keep prompts concise but clear
   - Don't send unnecessary data
   - Use streaming API for faster initial response (future enhancement)

3. **Response Optimization**
   - Parse responses efficiently
   - Don't store large responses unnecessarily
   - Clear response data after processing

## Monitoring and Debugging

1. **Logging**
   - Log all API requests (without API key)
   - Log response times
   - Log error details
   - Use console.group() for organized logs

2. **Debugging**
   - Test with curl/Postman first
   - Verify payload structure
   - Check response in browser DevTools
   - Use Google AI Studio for prompt testing

3. **Metrics to Track**
   - Request success rate
   - Average response time
   - Error frequency by type
   - Model fallback frequency
