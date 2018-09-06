pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol";
import "./ERC20TokenWidgetRenderer.sol";
import "../../../widget/Widgets.sol";

contract MaxMintableWidgetRenderer is ERC20TokenWidgetRenderer {
    using Widgets for Widgets.Widget;
    using UintUtils for uint;

    string public constant MAX_MINTABLE = "max_mintable";
    string public constant SHORT_DESC = "short_desc";
    string public constant LONG_DESC = "long_desc";
    string public constant AMOUNT = "amount";
    string public constant UPDATE = "update";
    string public constant UPDATE_CONFIRM = "update_confirm";

    function render(string _locale, ERC20Token _token) public view returns (string) {
        if (_token.mintable() && !_token.activated()) {
            Elements.Element[] memory elements = new Elements.Element[](2);
            DetailedERC20 erc20 = DetailedERC20(_token);
            uint256 decimals = uint256(erc20.decimals());
            elements[0] = Elements.Element(
                true,
                AMOUNT,
                "tokenEdit".toSlice().concat(decimals.toString().toSlice()),
                resources[_locale][AMOUNT],
                "0",
                Actions.empty(),
                Tables.empty()
            );
            elements[1] = Elements.Element(
                true,
                UPDATE,
                "button",
                resources[_locale][UPDATE],
                "null",
                Actions.Action(
                    true,
                    address(_token),
                    "setMaxMintable(uint256)",
                    '["amount"]',
                    resources[_locale][UPDATE_CONFIRM]
                ),
                Tables.empty()
            );
            Widgets.Widget memory widget = Widgets.Widget(
                resources[_locale][MAX_MINTABLE],
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
