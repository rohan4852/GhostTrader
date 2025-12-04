# Requirements Document

## Introduction

The Chart Analysis Engine is the core feature of the AITrader Chrome Extension that enables users to capture trading chart screenshots and receive AI-powered trading recommendations. The system integrates with Google Gemini AI to analyze chart patterns, market structure, and provide actionable trading decisions (BET UP, BET DOWN, or NO TRADE) with confidence levels and reasoning.

## Glossary

- **Chart Analysis Engine**: The system component responsible for capturing screenshots, communicating with Gemini AI, and processing trading recommendations
- **Trading Chart**: A visual representation of price movements displayed in a web browser tab
- **Gemini AI**: Google's generative AI model (Gemini 1.5 Pro) used for image analysis
- **Asset Type**: The classification of the trading instrument (Real Pair or Synthetic)
- **Major Trend**: The H1 timeframe trend direction (Bullish, Bearish, or Ranging)
- **System Prompt**: The instruction set sent to Gemini AI containing analysis rules and context
- **Trading Decision**: The output recommendation (BET UP, BET DOWN, or NO TRADE)
- **Confidence Score**: A percentage value (0-100%) indicating the AI's certainty in its decision
- **Screenshot Capture**: The process of capturing the visible browser tab as a JPEG image
- **Base64 Encoding**: The conversion of binary image data to text format for API transmission

## Requirements

### Requirement 1

**User Story:** As a trader, I want to capture the current trading chart as an image, so that I can send it to the AI for analysis.

#### Acceptance Criteria

1. WHEN a user clicks the analyze button THEN the Chart Analysis Engine SHALL capture a screenshot of the active browser tab
2. WHEN the screenshot is captured THEN the Chart Analysis Engine SHALL convert the image to JPEG format with quality setting of 95
3. WHEN the image conversion completes THEN the Chart Analysis Engine SHALL encode the image data as base64 format
4. IF the screenshot capture fails THEN the Chart Analysis Engine SHALL display an error message "Failed to capture chart image"
5. WHEN the screenshot process begins THEN the Chart Analysis Engine SHALL update the UI to show "Capturing chart..." status

### Requirement 2

**User Story:** As a trader, I want to provide context about my trading setup, so that the AI can make more informed recommendations.

#### Acceptance Criteria

1. WHEN a user selects an asset type THEN the Chart Analysis Engine SHALL store the selection for inclusion in the analysis prompt
2. WHEN a user selects a major trend THEN the Chart Analysis Engine SHALL store the selection for inclusion in the analysis prompt
3. THE Chart Analysis Engine SHALL support asset types including "Real Pair (EUR/USD)" and "Synthetic (Asia Composite)"
4. THE Chart Analysis Engine SHALL support major trends including "Bullish", "Bearish", and "Ranging"
5. WHEN constructing the system prompt THEN the Chart Analysis Engine SHALL include both asset type and major trend values

### Requirement 3

**User Story:** As a trader, I want the AI to analyze charts using specific trading rules, so that I receive consistent and reliable recommendations.

#### Acceptance Criteria

1. WHEN the asset type is "Real Pair" and major trend is "Ranging" THEN the Chart Analysis Engine SHALL instruct Gemini AI to apply conservative analysis rules
2. WHEN the asset type is "Synthetic" THEN the Chart Analysis Engine SHALL instruct Gemini AI to ignore external news context
3. WHEN analyzing chart structure THEN the Chart Analysis Engine SHALL instruct Gemini AI to identify Higher Highs/Higher Lows or Lower Highs/Lower Lows patterns
4. WHEN analyzing candles THEN the Chart Analysis Engine SHALL instruct Gemini AI to detect abnormally large candles as potential traps
5. WHEN analyzing price action THEN the Chart Analysis Engine SHALL instruct Gemini AI to identify rejection wicks at support or resistance zones

### Requirement 4

**User Story:** As a trader, I want to send the chart image and analysis rules to Gemini AI, so that I can receive trading recommendations.

#### Acceptance Criteria

1. WHEN sending an API request THEN the Chart Analysis Engine SHALL use the endpoint "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent"
2. WHEN constructing the API request THEN the Chart Analysis Engine SHALL include the system prompt as text and the screenshot as inline image data
3. WHEN sending the request THEN the Chart Analysis Engine SHALL include the user's API key as a query parameter
4. WHEN the API request is in progress THEN the Chart Analysis Engine SHALL update the UI to show "Analyzing with AI..." status
5. IF the API request fails THEN the Chart Analysis Engine SHALL display an error message with the failure reason

### Requirement 5

**User Story:** As a trader, I want to receive structured trading recommendations from the AI, so that I can make informed trading decisions.

#### Acceptance Criteria

1. WHEN Gemini AI responds THEN the Chart Analysis Engine SHALL parse the response as JSON format
2. WHEN parsing the response THEN the Chart Analysis Engine SHALL extract the decision field with values "BET UP", "BET DOWN", or "NO TRADE"
3. WHEN parsing the response THEN the Chart Analysis Engine SHALL extract the confidence field as a numeric percentage value
4. WHEN parsing the response THEN the Chart Analysis Engine SHALL extract the reason field as a text explanation
5. IF the response is not valid JSON THEN the Chart Analysis Engine SHALL attempt to extract JSON from markdown code blocks

### Requirement 6

**User Story:** As a trader, I want to see the AI's recommendation displayed clearly, so that I can quickly understand the trading decision.

#### Acceptance Criteria

1. WHEN displaying a "BET UP" decision THEN the Chart Analysis Engine SHALL show the decision text in green color
2. WHEN displaying a "BET DOWN" decision THEN the Chart Analysis Engine SHALL show the decision text in red color
3. WHEN displaying a "NO TRADE" decision THEN the Chart Analysis Engine SHALL show the decision text in orange color
4. WHEN displaying the result THEN the Chart Analysis Engine SHALL show the confidence score as a percentage
5. WHEN displaying the result THEN the Chart Analysis Engine SHALL show the reasoning explanation text

### Requirement 7

**User Story:** As a trader, I want the system to handle errors gracefully, so that I understand what went wrong and can take corrective action.

#### Acceptance Criteria

1. IF the API key is missing THEN the Chart Analysis Engine SHALL display "Please enter your API key first"
2. IF the API returns a 401 error THEN the Chart Analysis Engine SHALL display "Invalid API key"
3. IF the API returns a 400 error THEN the Chart Analysis Engine SHALL display "Bad request - check your inputs"
4. IF the network request fails THEN the Chart Analysis Engine SHALL display "Network error - check your connection"
5. WHEN an error occurs THEN the Chart Analysis Engine SHALL log the error details to the browser console

### Requirement 8

**User Story:** As a trader, I want my API key to be stored securely, so that I don't have to enter it every time I use the extension.

#### Acceptance Criteria

1. WHEN a user enters an API key THEN the Chart Analysis Engine SHALL save the key to chrome.storage.local
2. WHEN the popup opens THEN the Chart Analysis Engine SHALL load the saved API key from chrome.storage.local
3. THE Chart Analysis Engine SHALL store the API key only in local storage and never sync to cloud
4. WHEN the API key is loaded THEN the Chart Analysis Engine SHALL populate the input field with the saved value
5. IF no API key is saved THEN the Chart Analysis Engine SHALL leave the input field empty

### Requirement 9

**User Story:** As a developer, I want the analysis process to be performant, so that traders receive timely recommendations.

#### Acceptance Criteria

1. WHEN capturing a screenshot THEN the Chart Analysis Engine SHALL complete the capture within 1000 milliseconds
2. WHEN encoding the image THEN the Chart Analysis Engine SHALL complete the encoding within 200 milliseconds
3. WHEN the total analysis completes THEN the Chart Analysis Engine SHALL complete within 10 seconds from button click
4. WHEN processing the API response THEN the Chart Analysis Engine SHALL parse and display results within 200 milliseconds
5. THE Chart Analysis Engine SHALL use JPEG format with 95% quality to balance image quality and file size
