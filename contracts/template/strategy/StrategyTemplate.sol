pragma solidity ^0.4.24;

import "../Template.sol";
import "../../strategy/Strategy.sol";

contract StrategyTemplate is Template {
    constructor(
        bytes32 _bytecodeHash,
        uint _price,
        address _beneficiary
    ) public
    Template(
        _bytecodeHash,
        _price,
        _beneficiary
    ) {
    }

    function instantiate(bytes _bytecode, bytes _args) public payable returns (address contractAddress) {
        Strategy strategy = Strategy(super.instantiate(_bytecode, _args));
        // InterfaceId_Strategy
        require(strategy.supportsInterface(0x6e301925));
        return strategy;
    }
}
