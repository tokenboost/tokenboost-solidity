pragma solidity ^0.4.24;

import "./ERC20TokenWidgetRenderer.sol";
import "../../../widget/Widgets.sol";

contract UnpauseWidgetRenderer is ERC20TokenWidgetRenderer {
    using Widgets for Widgets.Widget;

    string public constant UNPAUSE = "unpause";
    string public constant SHORT_DESC = "short_desc";
    string public constant LONG_DESC = "long_desc";
    string public constant UNPAUSE_CONFIRM = "unpause_confirm";

    function render(string _locale, ERC20Token _token) public view returns (string) {
        if (_token.paused()) {
            Elements.Element[] memory elements = new Elements.Element[](1);
            elements[0] = Elements.Element(
                true,
                UNPAUSE,
                "button",
                resources[_locale][UNPAUSE],
                "null",
                Actions.Action(
                    true,
                    address(_token),
                    "unpause()",
                    '[]',
                    resources[_locale][UNPAUSE_CONFIRM]
                ),
                Tables.empty()
            );
            Widgets.Widget memory widget = Widgets.Widget(
                resources[_locale][UNPAUSE],
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
