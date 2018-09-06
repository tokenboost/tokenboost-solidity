pragma solidity ^0.4.24;

import "./ERC20SaleWidgetRenderer.sol";
import "../../../widget/Widgets.sol";

contract WithdrawFundsWidgetRenderer is ERC20SaleWidgetRenderer {
    using Widgets for Widgets.Widget;

    string public constant WITHDRAW_FUNDS = "withdraw_funds";
    string public constant SHORT_DESC = "short_desc";
    string public constant LONG_DESC = "long_desc";
    string public constant WITHDRAW = "withdraw";
    string public constant WITHDRAW_CONFIRM = "withdraw_confirm";

    function render(string _locale, ERC20Sale _sale) public view returns (string) {
        if (_sale.finished() && _sale.successful()) {
            Elements.Element[] memory elements = new Elements.Element[](1);
            elements[1] = Elements.Element(
                true,
                WITHDRAW,
                "button",
                resources[_locale][WITHDRAW],
                "null",
                Actions.Action(
                    true,
                    address(_sale),
                    "withdraw()",
                    '[]',
                    resources[_locale][WITHDRAW_CONFIRM]
                ),
                Tables.empty()
            );
            Widgets.Widget memory widget = Widgets.Widget(
                resources[_locale][WITHDRAW_FUNDS],
                resources[_locale][SHORT_DESC],
                resources[_locale][LONG_DESC],
                4,
                elements
            );
            return widget.toJson();
        } else {
            return "";
        }
    }
}
