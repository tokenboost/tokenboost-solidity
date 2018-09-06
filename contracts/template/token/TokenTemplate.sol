pragma solidity ^0.4.24;

import "../Template.sol";
import "../../token/Token.sol";

contract TokenTemplate is Template {
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
        Token token = Token(super.instantiate(_bytecode, _args));
        // InterfaceId_Token
        require(token.supportsInterface(0xfd155c67));
        return token;
    }
}
