pragma solidity ^0.4.24;

import "../Contract.sol";
import "../Activatable.sol";

contract Strategy is Contract, Activatable {
    /**
     * @notice this.owner.selector ^ this.renounceOwnership.selector ^ this.transferOwnership.selector
        ^ this.template.selector ^ this.activate.selector
     */
    bytes4 public constant InterfaceId_Strategy = 0x6e301925;

    constructor(address _owner) public Contract(_owner) {
        _registerInterface(InterfaceId_Strategy);
    }

    function activate() onlyOwner public returns (bool) {
        return super.activate();
    }
}
