pragma solidity ^0.4.24;

import "../Template.sol";
import "../../sale/Sale.sol";

contract SaleTemplate is Template {
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
        Sale sale = Sale(super.instantiate(_bytecode, _args));
        // InterfaceId_Sale
        require(sale.supportsInterface(0x5efbb022));
        return sale;
    }
}
