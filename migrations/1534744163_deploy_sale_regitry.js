const SaleRegistry = artifacts.require("SaleRegistry");

module.exports = async function (deployer) {
    await deployer.deploy(SaleRegistry);
};
