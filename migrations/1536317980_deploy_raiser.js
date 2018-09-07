const Boost = artifacts.require("Boost");
const Raiser = artifacts.require("Raiser");

module.exports = function (deployer) {
    deployer.deploy(Raiser, Boost.address);
};
