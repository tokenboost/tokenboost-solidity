const ERC20TokenRenderer = artifacts.require('ERC20TokenRenderer');
const RenderableERC20Token = artifacts.require('RenderableERC20Token');
const ERC20TokenTemplate = artifacts.require('ERC20TokenTemplate');
const TokenRegistry = artifacts.require('TokenRegistry');
const getAccounts = require('./getAccounts');
const updateTemplate = require('./updateTemplate.js');

module.exports = async function (callback) {
    try {
        await updateTemplate(
            web3,
            "net.tokenboost.token.erc20",
            RenderableERC20Token,
            ERC20TokenRenderer,
            ERC20TokenTemplate,
            TokenRegistry,
            0,
            (await getAccounts(web3))[0],
            'ERC20 Token',
            'You can create your own ERC20 tokens.'
        );
        callback();
    } catch (e) {
        callback(e);
    }
};

