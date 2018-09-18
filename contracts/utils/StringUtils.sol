pragma solidity ^0.4.24;

import "./strings.sol";

library StringUtils {
    using strings for *;

    function quoted(string _string) internal pure returns (string) {
        return '"'.toSlice().concat(_string.toSlice()).toSlice().concat('"'.toSlice());
    }
}