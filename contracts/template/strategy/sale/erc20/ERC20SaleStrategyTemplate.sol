pragma solidity ^0.4.24;

import "../SaleStrategyTemplate.sol";
import "../../../../strategy/sale/erc20/ERC20SaleStrategy.sol";

contract ERC20SaleStrategyTemplate is SaleStrategyTemplate {
    constructor(
        bytes32 _bytecodeHash,
        uint _price,
        address _beneficiary
    ) public
    SaleStrategyTemplate(
        _bytecodeHash,
        _price,
        _beneficiary
    ) {
    }

    function instantiate(bytes _bytecode, bytes _args) public payable returns (address contractAddress) {
        ERC20SaleStrategy strategy = ERC20SaleStrategy(super.instantiate(_bytecode, _args));
        // InterfaceId_ERC20SaleStrategy
        require(strategy.supportsInterface(0xa0d0304b));
        return strategy;
    }
}
