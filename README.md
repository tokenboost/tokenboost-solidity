# TokenBoost Solidity
[![npm version](https://badge.fury.io/js/tokenboost-solidity.svg)](https://www.npmjs.com/package/tokenboost-solidity)

Solidity contracts for [TokenBoost](https://tokenboost.net).

## Contracts
* Activatable.sol: Base class of contracts to be activated.
* [Boost.sol](https://etherscan.io/token/0x7c9ca19a8197b0f2147872dbd1cd4321082218a6#balances): Boost Token (ERC-20).
* Contract.sol: Base class of contracts to be contained in `Template`s.
* Migrations.sol: Truffle-backed migrations.
* [Raiser.sol](https://etherscan.io/token/0x16093acd98380bcf3621977ec0f06575ecadc32a): Raiser Token (ERC-721).

### Registry
* Registry.sol: Base class of concrete registries. Maintains `Template`s by their versions.
* [SaleRegistry.sol](https://etherscan.io/address/0xf806923e16bae8de2666bef603c8ecb70393d75b): `Registry` for `Sale`s.
* StrategyRegistry.sol: Base class of `Registry` for `Strategy`s.
* [TokenRegistry.sol](https://etherscan.io/address/0x11f4f0fc419226f8f8fd60a975823ebc471ae404): `Registry` for `Token`s.

### Sale
* Sale.sol: Base class of token sales.

### Strategy
* Strategy.sol: Base class of strategies.
* SaleStrategy.sol: Base class of strategies used for sales.

### Template
* Template.sol: Container of bytecode hash, price and beneficiary of a `Contract` to be instantiated.
* SaleTemplate.sol: `Template` for sales.
* StrategyTemplate.sol: `Template` for strategies.
* SaleStrategyTemplate.sol: `Template` for sale strategies.
* TokenTemplate.sol: `Template` for tokens.

### Token
* Token.sol: Base class of tokens.

### Utils
* AddressUtils
* BoolUtils
* ByteUtils
* StringUtils
* UintUtils
* strings

### Widgets
* Actions
* Elements
* Localizable
* Renderable
* Tables
* Widgets


## Install
```
npm install -E tokenboost-solidity
```

## Test
```
npm test
```

## License
TokenBoost Solidity is licensed under [GNU General Public License v3.0](https://github.com/tokenboost/tokenboost-solidity/blob/master/LICENSE)
