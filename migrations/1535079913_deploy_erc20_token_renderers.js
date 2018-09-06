const TotalSupplyWidgetRenderer = artifacts.require("TotalSupplyWidgetRenderer");
const TokenAddressWidgetRenderer = artifacts.require("TokenAddressWidgetRenderer");
const MaxMintableWidgetRenderer = artifacts.require("MaxMintableWidgetRenderer");
const MintTokensWidgetRenderer = artifacts.require("MintTokensWidgetRenderer");
const BurnTokensWidgetRenderer = artifacts.require("BurnTokensWidgetRenderer");
const PauseWidgetRenderer = artifacts.require("PauseWidgetRenderer");
const UnpauseWidgetRenderer = artifacts.require("UnpauseWidgetRenderer");
const MyBalanceWidgetRenderer = artifacts.require("MyBalanceWidgetRenderer");
const TransferWidgetRenderer = artifacts.require("TransferWidgetRenderer");
const ERC20TokenInputsRenderer = artifacts.require("ERC20TokenInputsRenderer");
const ERC20TokenRenderer = artifacts.require("ERC20TokenRenderer");

module.exports = function (deployer) {
    return deployer.then(async () => {
        let erc20TokenRenderer = await deployer.deploy(ERC20TokenRenderer);
        let totalSupplyWidget = await deployer.deploy(TotalSupplyWidgetRenderer);
        let tokenAddressWidget = await deployer.deploy(TokenAddressWidgetRenderer);
        let maxMintableWidget = await deployer.deploy(MaxMintableWidgetRenderer);
        let mintTokensWidgetRenderer = await deployer.deploy(MintTokensWidgetRenderer);
        let burnTokensWidgetRenderer = await deployer.deploy(BurnTokensWidgetRenderer);
        let pauseWidgetRenderer = await deployer.deploy(PauseWidgetRenderer);
        let unpauseWidgetRenderer = await deployer.deploy(UnpauseWidgetRenderer);
        let myBalanceWidgetRenderer = await deployer.deploy(MyBalanceWidgetRenderer);
        let transferWidgetRenderer = await deployer.deploy(TransferWidgetRenderer);
        let erc20TokenInputsRenderer = await deployer.deploy(ERC20TokenInputsRenderer);

        await erc20TokenRenderer.addAdminWidgetRenderers([
            totalSupplyWidget.address,
            tokenAddressWidget.address,
            maxMintableWidget.address,
            mintTokensWidgetRenderer.address,
            burnTokensWidgetRenderer.address,
            pauseWidgetRenderer.address,
            unpauseWidgetRenderer.address
        ]);
        await erc20TokenRenderer.addUserWidgetRenderers([
            myBalanceWidgetRenderer.address,
            transferWidgetRenderer.address,
            burnTokensWidgetRenderer.address
        ]);
        await erc20TokenRenderer.setInputsRenderer(erc20TokenInputsRenderer.address);
    });
};
