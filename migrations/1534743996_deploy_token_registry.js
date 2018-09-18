const TokenRegistry = artifacts.require("TokenRegistry");

module.exports = function (deployer) {
    deployer.deploy(TokenRegistry, {overwrite: false});
};
