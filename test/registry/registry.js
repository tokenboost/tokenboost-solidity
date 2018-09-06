const ERROR_MSG = 'VM Exception while processing transaction: revert';
const Registry = artifacts.require("Registry");
const Template = artifacts.require("Template");
const TokenRegistry = artifacts.require("TokenRegistry");
const ERC20TokenTemplate = artifacts.require("ERC20TokenTemplate");
const SaleRegistry = artifacts.require("SaleRegistry");
const ERC20SaleTemplate = artifacts.require("ERC20SaleTemplate");

contract('Registry', async (accounts) => {
    require('chai')
        .use(require('chai-as-promised'))
        .should();

    it("should register ERC20TokenTemplate", async () => {
        let registry = await TokenRegistry.new();
        let tokenTemplate = await ERC20TokenTemplate.new(web3.sha3(""), 0, 0);
        await registry.register("net.tokenboost.token.erc20", 1, tokenTemplate.address);

        assert.equal(await registry.numberOfIdentifiers(), 1);
        assert.equal(await registry.identifierAt(0), "net.tokenboost.token.erc20");
        let versions = await registry.versionsOf("net.tokenboost.token.erc20");
        assert.equal(versions.length, 1);
        assert.equal(versions[0], 1);
        assert.equal(await registry.templateOf("net.tokenboost.token.erc20", 1), tokenTemplate.address);
        assert.equal(await registry.latestTemplateOf("net.tokenboost.token.erc20"), tokenTemplate.address);
    });

    it("should register ERC20SaleTemplate", async () => {
        let registry = await SaleRegistry.new();
        let saleTemplate = await ERC20TokenTemplate.new(web3.sha3(""), 0, 0);
        await registry.register("net.tokenboost.sale.erc20", 1, saleTemplate.address);

        assert.equal(await registry.numberOfIdentifiers(), 1);
        assert.equal(await registry.identifierAt(0), "net.tokenboost.sale.erc20");
        let versions = await registry.versionsOf("net.tokenboost.sale.erc20");
        assert.equal(versions.length, 1);
        assert.equal(versions[0], 1);
        assert.equal(await registry.templateOf("net.tokenboost.sale.erc20", 1), saleTemplate.address);
        assert.equal(await registry.latestTemplateOf("net.tokenboost.sale.erc20"), saleTemplate.address);
    });

    it("should register multiple versions", async () => {
        let registry = await Registry.new(true);
        let testTemplate1 = await Template.new(web3.sha3(""), 0, 0);
        let testTemplate2 = await Template.new(web3.sha3(""), 0, 0);
        await registry.register("test", 1, testTemplate1.address);
        await registry.register("test", 2, testTemplate2.address);

        let versions = await registry.versionsOf("test");
        assert.equal(versions.length, 2);
        assert.equal(versions[1], 2);
        assert.equal(await registry.templateOf("test", 1), testTemplate1.address);
        assert.equal(await registry.templateOf("test", 2), testTemplate2.address);
        assert.equal(await registry.latestTemplateOf("test"), testTemplate2.address);
    });

    it("should register only for my identifier", async () => {
        let registry = await Registry.new(true);
        let testTemplate1 = await Template.new(web3.sha3(""), 0, 0);
        let testTemplate2 = await Template.new(web3.sha3(""), 0, 0);
        await registry.register("test", 1, testTemplate1.address, {from: accounts[1]});
        await registry.register("test", 2, testTemplate2.address, {from: accounts[0]}).should.be.rejectedWith(ERROR_MSG);
    });

    it("should register only newer versions", async () => {
        let registry = await Registry.new(true);
        let testTemplate1 = await Template.new(web3.sha3(""), 0, 0);
        let testTemplate2 = await Template.new(web3.sha3(""), 0, 0);
        await registry.register("test", 2, testTemplate2.address);
        await registry.register("test", 1, testTemplate1.address).should.be.rejectedWith(ERROR_MSG);
    });

    it("should register multiple identifiers", async () => {
        let registry = await Registry.new(true);
        let testTemplate = await Template.new(web3.sha3(""), 0, 0);
        let newTemplate = await Template.new(web3.sha3(""), 0, 0);
        await registry.register("test", 1, testTemplate.address);
        await registry.register("new", 1, newTemplate.address);

        assert.equal(await registry.numberOfIdentifiers(), 2);
        assert.equal(await registry.identifierAt(0), "test");
        assert.equal(await registry.identifierAt(1), "new");

        assert.equal(await registry.latestTemplateOf("test"), testTemplate.address);
        assert.equal(await registry.latestTemplateOf("new"), newTemplate.address);
    });
});
