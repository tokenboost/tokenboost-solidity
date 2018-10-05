require("dotenv").config();
const HDWalletProvider = require("truffle-hdwallet-provider");

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
                new HDWalletProvider(process.env.ROPSTEN_MNEMONIC, process.env.ROPSTEN_PROVIDER_URL),
            network_id: 3,
            gasPrice: 20000000000
        },
        mainnet: {
            provider: () =>
                new HDWalletProvider(process.env.MAINNET_MNEMONIC, process.env.MAINNET_PROVIDER_URL),
            network_id: 1,
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
