---
inclusion: always
---

# Trading Analysis Domain Knowledge

## Chart Pattern Recognition

### Market Structure

1. **Bullish Structure**
   - **Higher Highs (HH)**: Each peak is higher than the previous peak
   - **Higher Lows (HL)**: Each trough is higher than the previous trough
   - **Indication**: Upward momentum, buyers in control

2. **Bearish Structure**
   - **Lower Highs (LH)**: Each peak is lower than the previous peak
   - **Lower Lows (LL)**: Each trough is lower than the previous trough
   - **Indication**: Downward momentum, sellers in control

3. **Ranging/Consolidation**
   - Price moves sideways between support and resistance
   - No clear HH/HL or LH/LL pattern
   - **Indication**: Indecision, wait for breakout

### Candlestick Analysis

1. **Candle Components**
   - **Body**: Distance between open and close
   - **Wick/Shadow**: Distance from body to high/low
   - **Color**: Green (bullish), Red (bearish)

2. **Strong Candles**
   - Large body relative to wick
   - Closes near high (bullish) or low (bearish)
   - **Indication**: Strong momentum

3. **Weak Candles (Dojis, Spinners)**
   - Small body, large wicks
   - Open and close are similar
   - **Indication**: Indecision, potential reversal

### Rejection Wicks

1. **Bullish Rejection**
   - Long lower wick at support level
   - Price tested lower but buyers pushed back
   - **Indication**: Support holding, potential upward move

2. **Bearish Rejection**
   - Long upper wick at resistance level
   - Price tested higher but sellers pushed back
   - **Indication**: Resistance holding, potential downward move

### Support and Resistance

1. **Support**
   - Price level where buying pressure prevents further decline
   - Previous lows, round numbers, moving averages
   - **Action**: Look for bounces (buy opportunities)

2. **Resistance**
   - Price level where selling pressure prevents further rise
   - Previous highs, round numbers, moving averages
   - **Action**: Look for rejections (sell opportunities)

3. **Breakouts**
   - Price moves through support/resistance with momentum
   - Confirmed by strong candle and volume
   - **Action**: Trade in direction of breakout

## Trading Decision Framework

### Confluence Analysis

A high-probability trade requires multiple factors aligning:

1. **Trend Alignment**
   - Trade direction matches overall trend
   - Don't fight the trend

2. **Structure Confirmation**
   - Clear HH/HL (bullish) or LH/LL (bearish)
   - No mixed signals

3. **Momentum Confirmation**
   - Recent candles show dominance in trade direction
   - Strong bodies, minimal wicks

4. **Zone Reaction**
   - Price at key support/resistance
   - Clear rejection or breakout

### Risk Management Principles

1. **NO TRADE is a Valid Decision**
   - When signals conflict
   - When structure is unclear
   - When in middle of range
   - When candles show indecision

2. **Conservative Approach**
   - Prefer high-confidence setups
   - Avoid trading in choppy markets
   - Wait for clear confluence

3. **Trap Detection**
   - Abnormally large candles may be traps
   - Sudden spikes often reverse
   - Wait for confirmation

## Asset Type Considerations

### Real Pairs (e.g., EUR/USD)

1. **Characteristics**
   - Influenced by economic news
   - More predictable patterns
   - Lower volatility (generally)

2. **Analysis Approach**
   - Consider fundamental factors
   - Be more conservative in ranging markets
   - Respect major support/resistance levels

### Synthetic Indices

1. **Characteristics**
   - Not influenced by real-world events
   - Purely technical patterns
   - Can be more volatile

2. **Analysis Approach**
   - Focus purely on technical analysis
   - Ignore news and fundamentals
   - Patterns may be more reliable

## Timeframe Considerations

### H1 (1-Hour) Timeframe

1. **Characteristics**
   - Medium-term view
   - Balances noise and trend
   - Good for swing trading

2. **Analysis Window**
   - Look at last 8-10 candles for trend
   - Last 5 candles for momentum
   - Last 3 candles for immediate setup

3. **Prediction Horizon**
   - Next 1-3 candles (1-3 hours)
   - Short-term directional bias

## Common Trading Mistakes to Avoid

1. **Trading Against the Trend**
   - Don't try to catch falling knives
   - Don't fight strong momentum

2. **Overtrading**
   - Not every chart needs a trade
   - Wait for high-confidence setups

3. **Ignoring Context**
   - Don't trade in isolation
   - Consider overall market structure

4. **Chasing Price**
   - Don't enter after big moves
   - Wait for pullbacks or confirmations

5. **Ignoring Risk Signals**
   - Large wicks on both sides = indecision
   - Mixed candle colors = uncertainty
   - Choppy price action = stay out

## Analysis Checklist

Before making a trading decision, verify:

- [ ] **Trend**: Is there a clear HH/HL or LH/LL pattern?
- [ ] **Momentum**: Do recent candles show dominance?
- [ ] **Rejection**: Are there clear rejection wicks at key zones?
- [ ] **Zone**: Is price at support/resistance?
- [ ] **Confluence**: Do all factors align?
- [ ] **Risk**: Are there any trap signals?

If any answer is unclear or negative, default to **NO TRADE**.

## Confidence Levels

### HIGH CONFIDENCE (70-100%)

- All 4 factors align perfectly
- Clear trend, momentum, and zone reaction
- No conflicting signals
- Strong candle patterns

### MEDIUM CONFIDENCE (50-69%)

- 3 out of 4 factors align
- Some minor conflicting signals
- Acceptable setup but not perfect

### LOW CONFIDENCE (0-49%)

- 2 or fewer factors align
- Significant conflicting signals
- Unclear structure or momentum
- **Recommendation**: NO TRADE

## Output Format Guidelines

### Decision Types

1. **BET UP**
   - Clear bullish confluence
   - All factors support upward move
   - High confidence in bullish direction

2. **BET DOWN**
   - Clear bearish confluence
   - All factors support downward move
   - High confidence in bearish direction

3. **NO TRADE**
   - Conflicting signals
   - Unclear structure
   - Low confidence
   - Better to wait

### Reason Format

Keep reasons concise and specific:

- ✅ "Clear HH/HL structure with bullish rejection at support"
- ✅ "Strong bearish momentum with rejection at resistance"
- ✅ "Mixed signals - ranging structure with indecision candles"
- ❌ "The market looks good"
- ❌ "Price might go up"
- ❌ "Technical analysis suggests..."

## Testing and Validation

When implementing trading analysis:

1. **Test with Various Chart Types**
   - Trending markets
   - Ranging markets
   - Volatile markets
   - Calm markets

2. **Validate Decision Logic**
   - Ensure NO TRADE is common (conservative approach)
   - Verify confluence requirements
   - Check trap detection works

3. **Review Output Quality**
   - Decisions should be clear
   - Reasons should be specific
   - Confidence should match setup quality
