pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract Localizable is Ownable {
    mapping(string => mapping(string => string)) resources;

    function setResource(string locale, string key, string value) public onlyOwner {
        resources[locale][key] = value;
    }

    function resource(string locale, string key) public view returns (string) {
        return resources[locale][key];
    }
}
