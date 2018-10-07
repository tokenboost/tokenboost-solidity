pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol";
import "./template/Template.sol";

contract Contract is Ownable, SupportsInterfaceWithLookup {
    /**
     * @notice this.owner.selector ^ this.renounceOwnership.selector ^ this.transferOwnership.selector
        ^ this.template.selector
     */
    bytes4 public constant InterfaceId_Contract = 0x6125ede5;

    Template public template;

    constructor(address _owner) public {
        require(_owner != address(0));

        template = Template(msg.sender);
        owner = _owner;

        _registerInterface(InterfaceId_Contract);
    }
}
