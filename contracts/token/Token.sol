pragma solidity ^0.4.24;

import "../Contract.sol";
import "../Activatable.sol";

contract Token is Contract, Activatable {

    /**
     * @notice this.owner.selector ^ this.renounceOwnership.selector ^ this.transferOwnership.selector
        ^ this.template.selector ^ this.activate.selector
        ^ this.name.selector ^ this.symbol.selector
     */
    bytes4 public constant InterfaceId_Token = 0xfd155c67;

    string public name;
    string public symbol;

    constructor(
        address _owner,
        string _name,
        string _symbol
    ) public Contract(_owner) {
        name = _name;
        symbol = _symbol;

        _registerInterface(InterfaceId_Token);
    }

    function activate() onlyOwner public returns (bool) {
        return super.activate();
    }
}
