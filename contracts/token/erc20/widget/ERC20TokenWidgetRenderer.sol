pragma solidity ^0.4.24;

import "../../../widget/Localizable.sol";
import "../ERC20Token.sol";

contract ERC20TokenWidgetRenderer is Localizable {
    function render(string _locale, ERC20Token _token) public view returns (string) {
        return "[]";
    }
}
