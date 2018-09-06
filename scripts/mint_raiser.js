require("dotenv").config();
const SaleRegistry = artifacts.require('SaleRegistry');
const SaleTemplate = artifacts.require('SaleTemplate');
const Raiser = artifacts.require('Raiser');
const coder = require('web3/lib/solidity/coder');
const getAccounts = require('./getAccounts');
const bytecode = process.env.BYTECODE;
const boostAddress = process.env.BOOST_ADDRESS;

module.exports = async function (callback) {
    try {
        let registry = await SaleRegistry.deployed();
        let template = SaleTemplate.at(await registry.latestTemplateOf("net.tokenboost.sale.erc20"));
        let account = (await getAccounts(web3))[0];

        let raiser = await Raiser.deployed();
        let args = '0x' + coder.encodeParams(['address', 'string', 'string', 'address'], [account, 'Tokenboost', 'Private Sale', boostAddress]);
        let result = await raiser.mint("slug", template.address, bytecode, args);

        let tokenId = result.logs[1].args.tokenId;
        console.log("TokenId: " + web3.toHex(tokenId));
        let slug = await raiser.slugOf(tokenId);
        console.log("Slug: " + slug);
        let sale = await raiser.saleOf(tokenId);
        console.log("Sale: " + sale);

        callback();
    } catch (e) {
        callback(e);
    }
};
