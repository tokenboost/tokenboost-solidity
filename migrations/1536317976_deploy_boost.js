const Boost = artifacts.require("Boost");

module.exports = function (deployer) {
    deployer.deploy(Boost, {overwrite: false});
};
