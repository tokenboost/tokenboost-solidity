pragma solidity ^0.4.24;

contract Renderable {
    function adminWidgets(string locale) public view returns (string json);

    function userWidgets(string locale) public view returns (string json);

    function inputs(string locale) public view returns (string json);
}
