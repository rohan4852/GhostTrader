const hre = require('hardhat');

async function main() {
    const [deployer] = await hre.ethers.getSigners();

    console.log('Deployer:', deployer.address);

    // Deploy token
    const Token = await hre.ethers.getContractFactory('RealWorldAssetToken');
    const token = await Token.deploy(deployer.address);
    await token.waitForDeployment();

    // Deploy registry
    const Registry = await hre.ethers.getContractFactory('AssetRegistry');
    const registry = await Registry.deploy(deployer.address);
    await registry.waitForDeployment();

    // OPTIONAL: set a USDC address if you have one for your target network.
    // For local dev, you can pass address(0) and only use ETH flows.
    const usdcAddress = hre.ethers.ZeroAddress;

    // Deploy marketplace
    const Marketplace = await hre.ethers.getContractFactory('Marketplace');
    const marketplace = await Marketplace.deploy(deployer.address, await registry.getAddress(), await token.getAddress(), usdcAddress);
    await marketplace.waitForDeployment();

    // Wire roles
    const REGISTRY_ROLE = await token.REGISTRY_ROLE();
    const MARKETPLACE_ROLE = await token.MARKETPLACE_ROLE();

    await (await token.grantRole(REGISTRY_ROLE, await registry.getAddress())).wait();
    await (await token.grantRole(MARKETPLACE_ROLE, await marketplace.getAddress())).wait();

    // Configure registry's token pointer
    await (await registry.setToken(await token.getAddress())).wait();

    console.log('Deployed addresses:');
    console.log('  RealWorldAssetToken:', await token.getAddress());
    console.log('  AssetRegistry:', await registry.getAddress());
    console.log('  Marketplace:', await marketplace.getAddress());
    console.log('  USDC (configured):', usdcAddress);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
