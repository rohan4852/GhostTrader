// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {ERC1155Supply} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import {ERC1155URIStorage} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";

/**
 * @title RealWorldAssetToken
 * @notice ERC-1155 token where each `assetId` is also the token id.
 *         Supply is capped per asset (fractionalization).
 */
contract RealWorldAssetToken is ERC1155, ERC1155Supply, ERC1155URIStorage, AccessControl {
    bytes32 public constant REGISTRY_ROLE = keccak256("REGISTRY_ROLE");
    bytes32 public constant MARKETPLACE_ROLE = keccak256("MARKETPLACE_ROLE");

    mapping(uint256 => uint256) public maxSupply;
    mapping(uint256 => bool) public assetCreated;

    event AssetTokenCreated(uint256 indexed assetId, uint256 maxSupply, string tokenUri);

    error AssetAlreadyCreated();
    error AssetNotCreated();
    error SupplyExceeded();
    error NotApprovedForMarketplace();

    constructor(address admin) ERC1155("") {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
    }

    function createAssetToken(
        uint256 assetId,
        uint256 _maxSupply,
        string calldata tokenUri
    ) external onlyRole(REGISTRY_ROLE) {
        if (assetCreated[assetId]) revert AssetAlreadyCreated();
        assetCreated[assetId] = true;
        maxSupply[assetId] = _maxSupply;
        _setURI(assetId, tokenUri);
        emit AssetTokenCreated(assetId, _maxSupply, tokenUri);
    }

    function mint(address to, uint256 assetId, uint256 amount) external onlyRole(MARKETPLACE_ROLE) {
        if (!assetCreated[assetId]) revert AssetNotCreated();
        if (totalSupply(assetId) + amount > maxSupply[assetId]) revert SupplyExceeded();
        _mint(to, assetId, amount, "");
    }

    /**
     * @notice Burns tokens from a user when they sell back to the marketplace.
     * @dev Requires the user to approve the marketplace as an operator via setApprovalForAll.
     */
    function burnFrom(address from, uint256 assetId, uint256 amount) external onlyRole(MARKETPLACE_ROLE) {
        if (!isApprovedForAll(from, msg.sender)) revert NotApprovedForMarketplace();
        _burn(from, assetId, amount);
    }

    // ---- Overrides ----

    function uri(uint256 tokenId)
        public
        view
        override(ERC1155, ERC1155URIStorage)
        returns (string memory)
    {
        return ERC1155URIStorage.uri(tokenId);
    }

    function _update(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) internal override(ERC1155, ERC1155Supply) {
        super._update(from, to, ids, values);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
