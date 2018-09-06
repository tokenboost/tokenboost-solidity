pragma solidity ^0.4.24;

import "../TokenTemplate.sol";
import "../../../token/erc20/ERC20Token.sol";

contract ERC20TokenTemplate is TokenTemplate {
    constructor(
        bytes32 _bytecodeHash,
        uint _price,
        address _beneficiary
    ) public
    TokenTemplate(
        _bytecodeHash,
        _price,
        _beneficiary
    ) {
    }

    function instantiate(bytes _bytecode, bytes _args) public payable returns (address contractAddress) {
        ERC20Token token = ERC20Token(super.instantiate(_bytecode, _args));
        // InterfaceId_ERC20Token
        require(token.supportsInterface(0x98b0f321));
        return token;
    }
}
