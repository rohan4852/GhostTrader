---
inclusion: always
---

# Halloween Theme Design Guide

## Overview

The AITrader extension features a Halloween/spooky dark theme that maintains professional functionality while adding atmospheric visual effects. This guide ensures consistency when making UI changes.

## Color Palette

### Primary Colors

```css
/* Main Accent - Orange/Fire */
--primary-orange: #ff6b00;
--primary-orange-light: #ff8800;
--primary-orange-dark: #cc4400;

/* Backgrounds - Deep Purple/Black */
--bg-darkest: #0a0a0a;
--bg-dark-purple: #1a0a1a;
--bg-medium-purple: #2a0a2a;
--bg-light-purple: #3a1a3a;

/* Text Colors */
--text-primary: #d4d4d4;
--text-secondary: #b0b0b0;
--text-muted: #888;
--text-hint: #666;
```

### Decision Colors

```css
/* Trading Decisions */
--bet-up: #00ff88;      /* Bright green with glow */
--bet-down: #ff3366;    /* Hot pink with glow */
--no-trade: #ffaa00;    /* Orange with glow */
```

### Glow Effects

All primary UI elements should include glowing effects using `text-shadow` and `box-shadow`:

```css
/* Text Glow - Orange */
text-shadow: 0 0 15px rgba(255, 107, 0, 0.6), 0 0 30px rgba(255, 107, 0, 0.3);

/* Box Glow - Orange */
box-shadow: 0 4px 15px rgba(255, 107, 0, 0.5), 0 0 20px rgba(255, 107, 0, 0.3);

/* Input Focus Glow */
box-shadow: 0 0 12px rgba(255, 107, 0, 0.4);
```

## Typography

### Headers

```css
.header h1 {
    color: #ff6b00;
    text-shadow: 0 0 15px rgba(255, 107, 0, 0.6), 0 0 30px rgba(255, 107, 0, 0.3);
    letter-spacing: 1px;
}
```

### Labels

```css
.label {
    color: #ff6b00;
    text-shadow: 0 0 8px rgba(255, 107, 0, 0.4);
    text-transform: uppercase;
    letter-spacing: 0.5px;
}
```

### Body Text

```css
body {
    color: #d4d4d4;
}

.result-details p {
    color: #b0b0b0;
}
```

## Button Design

### Primary Button ("Summon Prediction")

```css
.analyze-btn {
    background: linear-gradient(135deg, #ff6b00 0%, #cc4400 100%);
    border: 2px solid #ff8800;
    color: #0a0a0a;
    box-shadow: 0 4px 15px rgba(255, 107, 0, 0.5), 0 0 20px rgba(255, 107, 0, 0.3);
    text-transform: uppercase;
    letter-spacing: 1px;
}

.analyze-btn:hover {
    box-shadow: 0 6px 25px rgba(255, 107, 0, 0.7), 0 0 30px rgba(255, 107, 0, 0.5);
    background: linear-gradient(135deg, #ff8800 0%, #ff6b00 100%);
}
```

### Button Decorations

```css
/* Ghost emoji on left */
.analyze-btn::before {
    content: '👻';
    position: absolute;
    left: 10px;
    animation: float 2s ease-in-out infinite;
}

/* Crystal ball emoji on right */
.analyze-btn::after {
    content: '🔮';
    position: absolute;
    right: 10px;
    animation: float 2s ease-in-out infinite 1s;
}
```

### Button States

- **Default**: "SUMMON PREDICTION"
- **Loading**: "Summoning Spirits..."
- **Disabled**: Reduced opacity (0.6)

## Animations

### Floating Animation

Used for button emojis:

```css
@keyframes float {
    0%, 100% {
        transform: translateY(0);
    }
    50% {
        transform: translateY(-3px);
    }
}
```

### Loading Animation

Orange gradient sliding effect:

```css
@keyframes loading {
    0% {
        transform: translateX(-100%);
    }
    100% {
        transform: translateX(100%);
    }
}

.loading-spinner::after {
    background: linear-gradient(90deg, #ff6b00, #ff8800, #ff6b00);
    box-shadow: 0 0 10px rgba(255, 107, 0, 0.6);
}
```

### Pulse Animation

Used for status indicators:

```css
@keyframes pulse {
    0%, 100% {
        opacity: 1;
    }
    50% {
        opacity: 0.5;
    }
}
```

## Input Fields

### Default State

```css
.input {
    background: #1a0a1a;
    border: 1.5px solid #3a1a3a;
    color: #d4d4d4;
}
```

### Focus State

```css
.input:focus {
    border-color: #ff6b00;
    box-shadow: 0 0 12px rgba(255, 107, 0, 0.4);
    background: #2a1a2a;
}
```

### Placeholder

```css
.input::placeholder {
    color: #666;
}
```

## Result Display

### Result Box

```css
.result-box {
    background: #1a0a1a;
    border: 2px solid #ff6b00;
    box-shadow: 0 0 20px rgba(255, 107, 0, 0.3), inset 0 0 10px rgba(255, 107, 0, 0.1);
}
```

### Decision Text

```css
/* BET UP */
.decision-text.bet-up {
    color: #00ff88;
    text-shadow: 0 0 15px rgba(0, 255, 136, 0.6);
}

/* BET DOWN */
.decision-text.bet-down {
    color: #ff3366;
    text-shadow: 0 0 15px rgba(255, 51, 102, 0.6);
}

/* NO TRADE */
.decision-text.no-trade {
    color: #ffaa00;
    text-shadow: 0 0 15px rgba(255, 170, 0, 0.6);
}
```

## Error Display

```css
.error-box {
    background: rgba(255, 51, 102, 0.15);
    border: 1.5px solid #ff3366;
    box-shadow: 0 0 15px rgba(255, 51, 102, 0.3);
}

#errorMessage {
    color: #ff6699;
    text-shadow: 0 0 5px rgba(255, 102, 153, 0.4);
}
```

## Scrollbar

```css
.container::-webkit-scrollbar-track {
    background: #1a0a1a;
}

.container::-webkit-scrollbar-thumb {
    background: #3a1a3a;
}

.container::-webkit-scrollbar-thumb:hover {
    background: #ff6b00;
    box-shadow: 0 0 10px rgba(255, 107, 0, 0.5);
}
```

## AI Persona - "Ghost of Wall Street"

### System Prompt Theme

The AI uses spooky metaphors while maintaining technical accuracy:

**Bullish Signals**:
- "Rising from the grave"
- "The spirits are ascending"
- "Bulls rising from their graves"

**Bearish Signals**:
- "Descending into the abyss"
- "A bloodbath awaits"
- "Price being dragged down to hell"

**Uncertain/Ranging**:
- "Lost in the purgatory fog"
- "The fog is too thick"
- "The spirits are silent"

### Response Format

```json
{
  "decision": "BET UP" | "BET DOWN" | "NO TRADE",
  "confidence": "HIGH CONFIDENCE" | "LOW CONFIDENCE",
  "confidencePercentage": 75,
  "reason": "A one-sentence spooky synthesis (e.g., 'Rejection at the graveyard ceiling suggests a fall into the abyss')"
}
```

## Design Principles

### 1. Atmospheric Lighting

- Use multiple layered shadows for depth
- Combine `text-shadow` and `box-shadow` for glowing effects
- Vary opacity and blur radius for atmospheric feel

### 2. Color Consistency

- Orange (#ff6b00) is the primary accent throughout
- Purple/black backgrounds create dark atmosphere
- Decision colors are bright with glow for visibility

### 3. Subtle Animations

- Floating effects should be gentle (2-3px movement)
- Use `ease-in-out` timing for smooth motion
- Stagger animations for visual interest (1s delay)

### 4. Readability First

- Despite dark theme, maintain sufficient contrast
- Glowing effects enhance rather than obscure text
- Use lighter text colors (#d4d4d4) on dark backgrounds

### 5. Professional Spooky

- Halloween theme is atmospheric, not cartoonish
- Maintain trading dashboard professionalism
- Spooky elements are tasteful and functional

## Accessibility

### Color Contrast

- Text on dark backgrounds: minimum 4.5:1 ratio
- Orange on black: sufficient contrast maintained
- Glowing effects improve visibility

### Interactive Elements

- All buttons have clear hover states
- Focus states use orange glow for visibility
- Disabled states reduce opacity to 0.6

### Animations

- Animations are decorative, not essential
- No flashing or rapid movements
- Respects `prefers-reduced-motion` (future enhancement)

## Testing Checklist

When making UI changes, verify:

- [ ] Orange accent color used consistently
- [ ] Glowing effects applied to primary elements
- [ ] Text shadows enhance readability
- [ ] Hover states increase glow intensity
- [ ] Animations are smooth and subtle
- [ ] Dark backgrounds maintain atmosphere
- [ ] Decision colors are bright and distinct
- [ ] Button emojis float correctly
- [ ] Loading states show spooky text
- [ ] Error messages have pink/red glow

## Future Enhancements

Potential additions to the Halloween theme:

1. **Particle Effects**: Floating ghost particles in background
2. **Sound Effects**: Optional spooky sounds on button click
3. **Seasonal Toggle**: Switch between Halloween and normal theme
4. **More Animations**: Flickering candle effect on borders
5. **Custom Cursor**: Ghost or crystal ball cursor
6. **Fog Effect**: Subtle animated fog overlay
7. **Moon Phase**: Display current moon phase in header

## Code Examples

### Adding a New Glowing Element

```css
.new-element {
    color: #ff6b00;
    text-shadow: 0 0 10px rgba(255, 107, 0, 0.5);
    border: 1px solid #ff6b00;
    box-shadow: 0 0 15px rgba(255, 107, 0, 0.3);
}

.new-element:hover {
    text-shadow: 0 0 15px rgba(255, 107, 0, 0.7);
    box-shadow: 0 0 20px rgba(255, 107, 0, 0.5);
}
```

### Adding a New Animation

```css
@keyframes spooky-effect {
    0% {
        opacity: 0.8;
        transform: scale(1);
    }
    50% {
        opacity: 1;
        transform: scale(1.05);
    }
    100% {
        opacity: 0.8;
        transform: scale(1);
    }
}

.spooky-element {
    animation: spooky-effect 3s ease-in-out infinite;
}
```

## Maintenance

### Regular Updates

- Test theme with new Chrome versions
- Verify glow effects render correctly
- Check animation performance
- Update colors if needed for accessibility

### Consistency Checks

- All orange values should use #ff6b00
- All backgrounds should use purple/black palette
- All glows should use consistent rgba values
- All animations should use ease-in-out timing

---

**Remember**: The Halloween theme should enhance the user experience while maintaining the professional functionality of a trading analysis tool. Spooky aesthetics should never compromise usability or readability.
