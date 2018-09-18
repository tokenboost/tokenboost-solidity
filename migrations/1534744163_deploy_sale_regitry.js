const SaleRegistry = artifacts.require("SaleRegistry");

module.exports = function (deployer) {
    deployer.deploy(SaleRegistry, {overwrite: false});
};
