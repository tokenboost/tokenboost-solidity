pragma solidity ^0.4.24;

import "./ERC20TokenWidgetRenderer.sol";
import "../../../widget/Widgets.sol";

contract MyBalanceWidgetRenderer is ERC20TokenWidgetRenderer {
    using Widgets for Widgets.Widget;
    using UintUtils for uint;

    string public constant MY_BALANCE = "my_balance";
    string public constant SHORT_DESC = "short_desc";
    string public constant LONG_DESC = "long_desc";

    function render(string _locale, ERC20Token _token) public view returns (string) {
        Elements.Element[] memory elements = new Elements.Element[](1);
        elements[0] = Elements.Element(
            true,
            MY_BALANCE,
            "eth",
            resources[_locale][MY_BALANCE],
            _token.balanceOf(tx.origin).toString(),
            Actions.empty(),
            Tables.empty()
        );
        Widgets.Widget memory widget = Widgets.Widget(
            resources[_locale][MY_BALANCE],
            resources[_locale][SHORT_DESC],
            resources[_locale][LONG_DESC],
            4,
            elements
        );
        return widget.toJson();
    }
}
