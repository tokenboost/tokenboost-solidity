pragma solidity ^0.4.24;

contract Activatable {
    bool public activated;

    modifier whenActivated {
        require(activated);
        _;
    }

    modifier whenNotActivated {
        require(!activated);
        _;
    }

    function activate() public returns (bool) {
        activated = true;
        return true;
    }
}
