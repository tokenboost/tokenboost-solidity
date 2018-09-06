pragma solidity ^0.4.24;

import "../../../widget/WidgetRenderer.sol";
import "../ERC20Sale.sol";

contract ERC20SaleWidgetRenderer is WidgetRenderer {
    function render(string _locale, ERC20Sale _sale) public view returns (string) {
        return "[]";
    }
}
