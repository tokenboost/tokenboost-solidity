pragma solidity ^0.4.24;

import "./ERC20SaleWidgetRenderer.sol";
import "../../../widget/Widgets.sol";

contract ClaimRefundWidgetRenderer is ERC20SaleWidgetRenderer {
    using Widgets for Widgets.Widget;

    string public constant CLAIM_REFUND = "claim_refund";
    string public constant SHORT_DESC = "short_desc";
    string public constant LONG_DESC = "long_desc";
    string public constant CLAIM_REFUND_CONFIRM = "claim_refund_confirm";

    function render(string _locale, ERC20Sale _sale) public view returns (string) {
        if (_sale.finished() && !_sale.successful()) {
            Elements.Element[] memory elements = new Elements.Element[](1);
            elements[1] = Elements.Element(
                true,
                CLAIM_REFUND,
                "button",
                resources[_locale][CLAIM_REFUND],
                "null",
                Actions.Action(
                    true,
                    address(_sale),
                    "claimRefund()",
                    '[]',
                    resources[_locale][CLAIM_REFUND_CONFIRM]
                ),
                Tables.empty()
            );
            Widgets.Widget memory widget = Widgets.Widget(
                resources[_locale][CLAIM_REFUND],
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
