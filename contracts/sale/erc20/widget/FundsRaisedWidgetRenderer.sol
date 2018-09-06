pragma solidity ^0.4.24;

import "./ERC20SaleWidgetRenderer.sol";
import "../../../widget/Widgets.sol";

contract FundsRaisedWidgetRenderer is ERC20SaleWidgetRenderer {
    using Widgets for Widgets.Widget;
    using UintUtils for uint;

    string public constant FUNDS_RAISED = "funds_raised";
    string public constant SHORT_DESC = "short_desc";
    string public constant LONG_DESC = "long_desc";

    function render(string _locale, ERC20Sale _sale) public view returns (string) {
        Elements.Element[] memory elements = new Elements.Element[](1);
        elements[0] = Elements.Element(
            true,
            FUNDS_RAISED,
            "eth",
            resources[_locale][FUNDS_RAISED],
            _sale.weiRaised().toString(),
            Actions.empty(),
            Tables.empty()
        );
        Widgets.Widget memory widget = Widgets.Widget(
            resources[_locale][FUNDS_RAISED],
            resources[_locale][SHORT_DESC],
            resources[_locale][LONG_DESC],
            2,
            elements
        );
        return widget.toJson();
    }
}
