# QuantumTrader Contracts (PS-004: Real-World Asset Tokenization)

This folder contains the on-chain components for the **RWA Tokenization Dashboard**.

## Protocol flow (intended)

1) **Register** an asset (issuer)
- `AssetRegistry.registerAsset(detailsURI)`

2) **Audit + valuation** (authorized auditor)
- Use Gemini (off-chain) to produce an audit summary + recommended valuation.
- On-chain: `AssetRegistry.verifyAndTokenizeAsset(assetId, appraisedValue, totalFractions, tokenUri)`
  - Marks the asset verified
  - Creates an ERC-1155 token id matching `assetId`
  - Sets the maximum supply to `totalFractions`

3) **Set market prices / trading** (market owner)
- `Marketplace.setAssetPrices(assetId, buyPriceWeiPerToken, sellPriceWeiPerToken, buyPriceUsdcPerToken, sellPriceUsdcPerToken)`

4) **Buy / sell fractions** (users)
- Buy with ETH: `Marketplace.buyWithETH(assetId, amount)`
- Buy with USDC: `Marketplace.buyWithUSDC(assetId, amount)`
- Sell back for ETH/USDC:
  - First approve the marketplace as an operator for the ERC-1155 token: `setApprovalForAll(marketplace, true)`
  - Then call `sellForETH` / `sellForUSDC`

## Notes
- This is a **baseline reference implementation** (fixed-price dealer style), designed to be easy to call from the Chrome extension.
- For production: consider formal audits, stronger market design (AMM / order book), role governance, and oracle-based valuation.
