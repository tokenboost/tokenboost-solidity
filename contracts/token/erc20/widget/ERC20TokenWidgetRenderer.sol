pragma solidity ^0.4.24;

import "../../../widget/WidgetRenderer.sol";
import "../ERC20Token.sol";

contract ERC20TokenWidgetRenderer is WidgetRenderer {
    function render(string _locale, ERC20Token _token) public view returns (string) {
        return "[]";
    }
}
