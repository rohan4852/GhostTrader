// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

interface IAssetRegistry {
    function assets(uint256 assetId)
        external
        view
        returns (
            uint256,
            address,
            string memory,
            bool,
            address,
            uint256,
            uint256,
            uint256
        );
}

interface IRWAToken {
    function mint(address to, uint256 assetId, uint256 amount) external;
    function burnFrom(address from, uint256 assetId, uint256 amount) external;
}

/**
 * @title Marketplace
 * @notice Fixed-price buy/sell venue for ERC-1155 asset fractions.
 *         Supports ETH and an ERC-20 stablecoin (e.g. USDC).
 */
contract Marketplace is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    struct Prices {
        uint256 buyWeiPerToken;
        uint256 sellWeiPerToken;
        uint256 buyUsdcPerToken;
        uint256 sellUsdcPerToken;
    }

    IAssetRegistry public immutable registry;
    IRWAToken public immutable token;

    IERC20 public immutable usdc; // can be address(0) if unused in a dev deployment

    mapping(uint256 => Prices) public prices;

    event PricesUpdated(uint256 indexed assetId, Prices p);
    event BoughtWithETH(address indexed buyer, uint256 indexed assetId, uint256 amount, uint256 costWei);
    event SoldForETH(address indexed seller, uint256 indexed assetId, uint256 amount, uint256 payoutWei);
    event BoughtWithUSDC(address indexed buyer, uint256 indexed assetId, uint256 amount, uint256 costUsdc);
    event SoldForUSDC(address indexed seller, uint256 indexed assetId, uint256 amount, uint256 payoutUsdc);

    error AssetNotVerified();
    error PriceNotSet();
    error InsufficientPayment();
    error USDCNotConfigured();
    error InsufficientLiquidity();

    constructor(address initialOwner, address registry_, address token_, address usdc_) Ownable(initialOwner) {
        registry = IAssetRegistry(registry_);
        token = IRWAToken(token_);
        usdc = IERC20(usdc_);
    }

    receive() external payable {}

    function setAssetPrices(
        uint256 assetId,
        uint256 buyWeiPerToken,
        uint256 sellWeiPerToken,
        uint256 buyUsdcPerToken,
        uint256 sellUsdcPerToken
    ) external onlyOwner {
        prices[assetId] = Prices({
            buyWeiPerToken: buyWeiPerToken,
            sellWeiPerToken: sellWeiPerToken,
            buyUsdcPerToken: buyUsdcPerToken,
            sellUsdcPerToken: sellUsdcPerToken
        });
        emit PricesUpdated(assetId, prices[assetId]);
    }

    function buyWithETH(uint256 assetId, uint256 amount) external payable nonReentrant {
        _requireVerified(assetId);
        uint256 unitPrice = prices[assetId].buyWeiPerToken;
        if (unitPrice == 0) revert PriceNotSet();

        uint256 cost = unitPrice * amount;
        if (msg.value < cost) revert InsufficientPayment();

        token.mint(msg.sender, assetId, amount);

        // refund extra
        if (msg.value > cost) {
            unchecked {
                (bool ok, ) = msg.sender.call{value: msg.value - cost}("");
                require(ok, "refund failed");
            }
        }

        emit BoughtWithETH(msg.sender, assetId, amount, cost);
    }

    function sellForETH(uint256 assetId, uint256 amount) external nonReentrant {
        _requireVerified(assetId);
        uint256 unitPrice = prices[assetId].sellWeiPerToken;
        if (unitPrice == 0) revert PriceNotSet();

        uint256 payout = unitPrice * amount;
        if (address(this).balance < payout) revert InsufficientLiquidity();

        token.burnFrom(msg.sender, assetId, amount);

        (bool ok, ) = msg.sender.call{value: payout}("");
        require(ok, "payout failed");

        emit SoldForETH(msg.sender, assetId, amount, payout);
    }

    function buyWithUSDC(uint256 assetId, uint256 amount) external nonReentrant {
        _requireVerified(assetId);
        if (address(usdc) == address(0)) revert USDCNotConfigured();

        uint256 unitPrice = prices[assetId].buyUsdcPerToken;
        if (unitPrice == 0) revert PriceNotSet();

        uint256 cost = unitPrice * amount;
        usdc.safeTransferFrom(msg.sender, address(this), cost);

        token.mint(msg.sender, assetId, amount);

        emit BoughtWithUSDC(msg.sender, assetId, amount, cost);
    }

    function sellForUSDC(uint256 assetId, uint256 amount) external nonReentrant {
        _requireVerified(assetId);
        if (address(usdc) == address(0)) revert USDCNotConfigured();

        uint256 unitPrice = prices[assetId].sellUsdcPerToken;
        if (unitPrice == 0) revert PriceNotSet();

        uint256 payout = unitPrice * amount;

        // ensure USDC liquidity exists
        if (usdc.balanceOf(address(this)) < payout) revert InsufficientLiquidity();

        token.burnFrom(msg.sender, assetId, amount);
        usdc.safeTransfer(msg.sender, payout);

        emit SoldForUSDC(msg.sender, assetId, amount, payout);
    }

    function _requireVerified(uint256 assetId) internal view {
        (, , , bool verified, , , , ) = registry.assets(assetId);
        if (!verified) revert AssetNotVerified();
    }
}
