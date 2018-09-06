const StrategyRegistry = artifacts.require("StrategyRegistry");

module.exports = async function (deployer) {
    await deployer.deploy(StrategyRegistry);
};
