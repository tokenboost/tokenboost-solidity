pragma solidity ^0.4.24;

import "./ERC20TokenWidgetRenderer.sol";
import "../../../widget/Widgets.sol";

contract PauseWidgetRenderer is ERC20TokenWidgetRenderer {
    using Widgets for Widgets.Widget;

    string public constant PAUSE = "pause";
    string public constant SHORT_DESC = "short_desc";
    string public constant LONG_DESC = "long_desc";
    string public constant PAUSE_CONFIRM = "pause_confirm";

    function render(string _locale, ERC20Token _token) public view returns (string) {
        if (_token.pausable() && !_token.paused()) {
            Elements.Element[] memory elements = new Elements.Element[](1);
            elements[0] = Elements.Element(
                true,
                PAUSE,
                "button",
                resources[_locale][PAUSE],
                "null",
                Actions.Action(
                    true,
                    address(_token),
                    "pause()",
                    '[]',
                    resources[_locale][PAUSE_CONFIRM]
                ),
                Tables.empty()
            );
            Widgets.Widget memory widget = Widgets.Widget(
                resources[_locale][PAUSE],
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
