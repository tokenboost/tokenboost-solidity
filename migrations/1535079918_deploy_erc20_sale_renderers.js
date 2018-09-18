const FundsRaisedWidgetRenderer = artifacts.require("FundsRaisedWidgetRenderer");
const SaleAddressWidgetRenderer = artifacts.require("SaleAddressWidgetRenderer");
const TokenInfoWidgetRenderer = artifacts.require("TokenInfoWidgetRenderer");
const WithdrawFundsWidgetRenderer = artifacts.require("WithdrawFundsWidgetRenderer");
const ClaimRefundWidgetRenderer = artifacts.require("ClaimRefundWidgetRenderer");
const ERC20SaleInputsRenderer = artifacts.require("ERC20SaleInputsRenderer");
const ERC20SaleRenderer = artifacts.require("ERC20SaleRenderer");

module.exports = function (deployer) {
    return deployer.then(async () => {
        let erc20SaleRenderer = await deployer.deploy(ERC20SaleRenderer);
        let fundsRaisedWidgetRenderer = await deployer.deploy(FundsRaisedWidgetRenderer);
        let saleAddressWidgetRenderer = await deployer.deploy(SaleAddressWidgetRenderer);
        let tokenInfoWidgetRenderer = await deployer.deploy(TokenInfoWidgetRenderer);
        let withdrawFundsWidgetRenderer = await deployer.deploy(WithdrawFundsWidgetRenderer);
        let claimRefundWidgetRenderer = await deployer.deploy(ClaimRefundWidgetRenderer);
        let erc20SaleInputsRenderer = await deployer.deploy(ERC20SaleInputsRenderer);

        await erc20SaleRenderer.setAdminWidgetRenderers([
            fundsRaisedWidgetRenderer.address,
            saleAddressWidgetRenderer.address,
            tokenInfoWidgetRenderer.address,
            withdrawFundsWidgetRenderer.address
        ]);
        await erc20SaleRenderer.setUserWidgetRenderers([
            claimRefundWidgetRenderer.address
        ]);
        await erc20SaleRenderer.setInputsRenderer(erc20SaleInputsRenderer.address);
    });
};
