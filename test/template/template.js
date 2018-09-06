const ERROR_MSG = 'VM Exception while processing transaction: revert';
const TokenTemplate = artifacts.require("TokenTemplate");
const SaleTemplate = artifacts.require("SaleTemplate");
const ERC20Token = artifacts.require("ERC20Token");
const ERC20Sale = artifacts.require("ERC20Sale");
const coder = require('web3/lib/solidity/coder');

contract('Template', async (accounts) => {
    require('chai')
        .use(require('chai-as-promised'))
        .should();

    it("should instantiate ERC20Token", async () => {
        let tokenTemplate = await TokenTemplate.new(
            web3.sha3(ERC20Token.bytecode, {encoding: 'hex'}),
            0,
            0
        );
        let result = await tokenTemplate.instantiate(
            ERC20Token.bytecode,
            '0x' + coder.encodeParams(['address', 'string', 'string'], [accounts[0], 'Bitcoin', 'BTC'])
        );

        let token = ERC20Token.at(result.logs[0].args.contractAddress);
        assert.equal(await token.owner(), accounts[0]);
        assert.equal(await token.name(), 'Bitcoin');
        assert.equal(await token.symbol(), 'BTC');

        let saleTemplate = await SaleTemplate.new(
            web3.sha3(ERC20Token.bytecode, {encoding: 'hex'}),
            0,
            0
        );
        await saleTemplate.instantiate(
            ERC20Token.bytecode,
            '0x' + coder.encodeParams(['address', 'string', 'string'], [accounts[0], 'Bitcoin', 'BTC'])
        ).should.be.rejectedWith(ERROR_MSG);
    });

    it("should instantiate ERC20Sale", async () => {
        let saleTemplate = await SaleTemplate.new(
            web3.sha3(ERC20Sale.bytecode, {encoding: 'hex'}),
            0,
            0
        );
        let token = await ERC20Token.new(accounts[0], 'Bitcion', 'BTC');
        let result = await saleTemplate.instantiate(
            ERC20Sale.bytecode,
            '0x' + coder.encodeParams(['address', 'string', 'string', 'address'], [accounts[0], 'P2P E-Cash', 'Presale', token.address])
        );

        let sale = ERC20Sale.at(result.logs[0].args.contractAddress);
        assert.equal(await sale.owner(), accounts[0]);
        assert.equal(await sale.projectName(), 'P2P E-Cash');
        assert.equal(await sale.name(), 'Presale');
        assert.equal(await sale.token(), token.address);

        let tokenTemplate = await TokenTemplate.new(
            web3.sha3(ERC20Sale.bytecode, {encoding: 'hex'}),
            0,
            0
        );
        await tokenTemplate.instantiate(
            ERC20Sale.bytecode,
            '0x' + coder.encodeParams(['address', 'string', 'string', 'address'], [accounts[0], 'P2P E-Cash', 'Presale', token.address])
        ).should.be.rejectedWith(ERROR_MSG);
    });
});
