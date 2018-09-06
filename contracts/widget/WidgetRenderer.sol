pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "../utils/strings.sol";

contract WidgetRenderer is Ownable {
    using strings for *;

    mapping(string => mapping(string => string)) resources;

    function setResource(string locale, string key, string value) public onlyOwner {
        resources[locale][key] = value;
    }

    function resource(string locale, string key) public view returns (string) {
        return resources[locale][key];
    }

    function render(string _locale) public view returns (string) {
        return "[]";
    }

    function quote(string _string) internal pure returns (string) {
        return '"'.toSlice().concat(_string.toSlice()).toSlice().concat('"'.toSlice());
    }
}
