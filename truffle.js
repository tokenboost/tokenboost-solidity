require("dotenv").config();
const HDWalletProvider = require("truffle-hdwallet-provider");
const ropstenMnemonic = process.env.ROPSTEN_MNEMONIC;
const infuraAccessToken = process.env.INFURA_ACCESS_TOKEN;

module.exports = {
    networks: {
        development: {
            host: "127.0.0.1",
            port: 7545,
            gas: 10000000,
            network_id: "*" // Match any network id
        },
        ropsten: {
            provider: () =>
                new HDWalletProvider(ropstenMnemonic, "https://ropsten.infura.io/" + infuraAccessToken),
            network_id: 3,
            gas: 4700000,
            gasPrice: 20000000000
        },
        mainnet: {
            provider: () =>
                new HDWalletProvider(ropstenMnemonic, "https://mainnet.infura.io/" + infuraAccessToken),
            network_id: 1,
            gas: 7900000,
            gasPrice: 20000000000
        }
    },
    solc: {
        optimizer: {
            enabled: true,
            runs: 200
        }
    }
};
