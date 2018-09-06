pragma solidity ^0.4.24;

library BoolUtils {
    function toString(bool _self) internal pure returns (string memory) {
        if (_self) {
            return "true";
        } else {
            return "false";
        }
    }
}
