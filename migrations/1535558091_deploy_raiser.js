const Boost = artifacts.require("Boost");
const Raiser = artifacts.require("Raiser");

module.exports = function (deployer) {
    return deployer.then(async () => {
        await deployer.deploy(Boost);
        await deployer.deploy(Raiser, Boost.address);
    });
};
