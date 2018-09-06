pragma solidity ^0.4.24;

import "../StrategyTemplate.sol";
import "../../../strategy/sale/SaleStrategy.sol";

contract SaleStrategyTemplate is StrategyTemplate {
    constructor(
        bytes32 _bytecodeHash,
        uint _price,
        address _beneficiary
    ) public
    StrategyTemplate(
        _bytecodeHash,
        _price,
        _beneficiary
    ) {
    }

    function instantiate(bytes _bytecode, bytes _args) public payable returns (address contractAddress) {
        SaleStrategy strategy = SaleStrategy(super.instantiate(_bytecode, _args));
        // InterfaceId_SaleStrategy
        require(strategy.supportsInterface(0x04c8123d));
        return strategy;
    }
}
