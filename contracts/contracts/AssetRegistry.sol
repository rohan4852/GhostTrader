// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

interface IRealWorldAssetToken {
    function createAssetToken(
        uint256 assetId,
        uint256 maxSupply,
        string calldata tokenUri
    ) external;
}

/**
 * @title AssetRegistry
 * @notice Registers real-world assets and allows authorized auditors to verify + tokenize them.
 *         Tokenization is performed by calling the ERC-1155 token contract.
 */
contract AssetRegistry is Ownable {
    struct Asset {
        uint256 assetId;
        address issuer;
        string detailsURI; // off-chain data pointer (JSON/IPFS/HTTPS)
        bool verified;
        address auditor;
        uint256 appraisedValue; // units decided by the app (e.g. USD * 1e2)
        uint256 totalFractions;
        uint256 verifiedAt;
    }

    uint256 public nextAssetId = 1;

    mapping(uint256 => Asset) public assets;
    mapping(address => bool) public isAuditor;

    IRealWorldAssetToken public rwaToken;

    event AuditorUpdated(address indexed auditor, bool allowed);
    event AssetRegistered(uint256 indexed assetId, address indexed issuer, string detailsURI);
    event AssetVerified(
        uint256 indexed assetId,
        address indexed auditor,
        uint256 appraisedValue,
        uint256 totalFractions,
        string tokenUri
    );

    error NotAuditor();
    error AssetNotFound();
    error AssetAlreadyVerified();
    error TokenNotConfigured();

    modifier onlyAuditor() {
        if (!isAuditor[msg.sender]) revert NotAuditor();
        _;
    }

    constructor(address initialOwner) Ownable(initialOwner) {}

    function setAuditor(address auditor, bool allowed) external onlyOwner {
        isAuditor[auditor] = allowed;
        emit AuditorUpdated(auditor, allowed);
    }

    /**
     * @notice Configure the token contract that will mint ERC-1155 fractions.
     * @dev This can be changed by the owner (for upgrades) in this reference implementation.
     */
    function setToken(address token) external onlyOwner {
        rwaToken = IRealWorldAssetToken(token);
    }

    function registerAsset(string calldata detailsURI) external returns (uint256 assetId) {
        assetId = nextAssetId;
        nextAssetId = assetId + 1;

        assets[assetId] = Asset({
            assetId: assetId,
            issuer: msg.sender,
            detailsURI: detailsURI,
            verified: false,
            auditor: address(0),
            appraisedValue: 0,
            totalFractions: 0,
            verifiedAt: 0
        });

        emit AssetRegistered(assetId, msg.sender, detailsURI);
    }

    /**
     * @notice Auditor verifies the asset and triggers creation of its fractional token.
     * @param assetId Registered asset id.
     * @param appraisedValue Off-chain valuation result (define units in your app).
     * @param totalFractions Max supply of ERC-1155 tokens for this asset (fractionalization).
     * @param tokenUri Per-asset token metadata (e.g. ipfs://... or https://...).
     */
    function verifyAndTokenizeAsset(
        uint256 assetId,
        uint256 appraisedValue,
        uint256 totalFractions,
        string calldata tokenUri
    ) external onlyAuditor {
        Asset storage a = assets[assetId];
        if (a.issuer == address(0)) revert AssetNotFound();
        if (a.verified) revert AssetAlreadyVerified();
        if (address(rwaToken) == address(0)) revert TokenNotConfigured();

        a.verified = true;
        a.auditor = msg.sender;
        a.appraisedValue = appraisedValue;
        a.totalFractions = totalFractions;
        a.verifiedAt = block.timestamp;

        rwaToken.createAssetToken(assetId, totalFractions, tokenUri);

        emit AssetVerified(assetId, msg.sender, appraisedValue, totalFractions, tokenUri);
    }
}
