# PS-004 — Valuation & Audit Protocol (Gemini → On-chain)

This project uses Gemini **off-chain** to convert real-world asset documentation (text/JSON) into a **structured valuation payload** that can be submitted **on-chain**.

## Why this exists
- The smart contracts intentionally avoid complicated business logic/oracles.
- The valuation step is performed off-chain but is made **auditable** by requiring:
  - explicit JSON output,
  - consistent units,
  - and a human/role gate (authorized auditor) to submit on-chain.

## Inputs
- Any text or JSON describing the asset (deed, certificate, appraisal notes, custody proof, liens, location, etc.)

## Output (strict JSON)
Gemini must return **ONLY JSON** with this schema:

```json
{
  "appraisedValue": 123456789,
  "appraisedValueUnit": "USD_CENTS",
  "totalFractions": 100000,
  "tokenUri": "ipfs://... or https://...",
  "buyWeiPerToken": 100000000000000,
  "sellWeiPerToken": 95000000000000,
  "buyUsdcPerToken": 100,
  "sellUsdcPerToken": 95,
  "riskSummary": "...",
  "assumptions": ["...", "..."],
  "redFlags": ["...", "..."]
}
```

### Field meanings
- `appraisedValue`: integer valuation.
- `appraisedValueUnit`: **must** be `USD_CENTS` (so $1.23 → 123).
- `totalFractions`: ERC-1155 max supply for the asset (e.g., 100,000 fractions).
- `tokenUri`: metadata pointer for the tokenized asset.
- `buyWeiPerToken`, `sellWeiPerToken`: fixed-price quotes in wei per fraction.
- `buyUsdcPerToken`, `sellUsdcPerToken`: fixed-price quotes in **USDC base units** (typically 6 decimals).
- `riskSummary`: short narrative (1 paragraph).
- `assumptions`, `redFlags`: arrays for auditability.

## On-chain submission flow
1. Owner authorizes an auditor: `AssetRegistry.setAuditor(auditor, true)`
2. Issuer registers asset: `AssetRegistry.registerAsset(detailsURI)`
3. Auditor submits valuation + tokenization:
   - `AssetRegistry.verifyAndTokenizeAsset(assetId, appraisedValue, totalFractions, tokenUri)`
4. Market owner sets pricing:
   - `Marketplace.setAssetPrices(assetId, buyWeiPerToken, sellWeiPerToken, buyUsdcPerToken, sellUsdcPerToken)`

## Security notes
- This is a **reference** protocol. Treat Gemini output as advisory; the auditor is responsible.
- In production, use independent data sources, a formal audit process, and consider oracle integrations.
