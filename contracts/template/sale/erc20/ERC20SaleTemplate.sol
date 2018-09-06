pragma solidity ^0.4.24;

import "../SaleTemplate.sol";
import "../../../sale/erc20/ERC20Sale.sol";

contract ERC20SaleTemplate is SaleTemplate {
    constructor(
        bytes32 _bytecodeHash,
        uint _price,
        address _beneficiary
    ) public
    SaleTemplate(
        _bytecodeHash,
        _price,
        _beneficiary
    ) {
    }

    function instantiate(bytes _bytecode, bytes _args) public payable returns (address contractAddress) {
        ERC20Sale sale = ERC20Sale(super.instantiate(_bytecode, _args));
        // InterfaceId_ERC20Sale
        require(sale.supportsInterface(0x95b5cfcb));
        return sale;
    }
}
