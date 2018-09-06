const ERC20SaleRenderer = artifacts.require('ERC20SaleRenderer');
const RenderableERC20Sale = artifacts.require('RenderableERC20Sale');
const ERC20SaleTemplate = artifacts.require('ERC20SaleTemplate');
const SaleRegistry = artifacts.require('SaleRegistry');
const getAccounts = require('./getAccounts');
const updateTemplate = require('./updateTemplate.js');

module.exports = async function (callback) {
    try {
        await updateTemplate(
            web3,
            "net.tokenboost.sale.erc20",
            RenderableERC20Sale,
            ERC20SaleRenderer,
            ERC20SaleTemplate,
            SaleRegistry,
            0,
            (await getAccounts(web3))[0],
            'ERC20 Sale',
            'You can start fundraising for ERC20 tokens.'
        );
        callback();
    } catch (e) {
        callback(e);
    }
};
