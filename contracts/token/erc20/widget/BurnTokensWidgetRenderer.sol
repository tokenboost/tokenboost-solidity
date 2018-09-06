pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol";
import "./ERC20TokenWidgetRenderer.sol";
import "../../../widget/Widgets.sol";

contract BurnTokensWidgetRenderer is ERC20TokenWidgetRenderer {
    using Widgets for Widgets.Widget;
    using UintUtils for uint;
    using SafeMath for uint;
    using strings for *;

    string public constant BURN_TOKENS = "burn_tokens";
    string public constant SHORT_DESC = "short_desc";
    string public constant LONG_DESC = "long_desc";
    string public constant BURNABLE_ETH = "burnable_eth";
    string public constant AMOUNT = "amount";
    string public constant BURN = "burn";
    string public constant BURN_CONFIRM = "burn_confirm";

    function render(string _locale, ERC20Token _token) public view returns (string) {
        if (_token.burnable() && _token.activated()) {
            Elements.Element[] memory elements = new Elements.Element[](3);
            DetailedERC20 erc20 = DetailedERC20(_token);
            uint256 decimals = uint256(erc20.decimals());
            elements[0] = Elements.Element(
                true,
                BURNABLE_ETH,
                "token".toSlice().concat(decimals.toString().toSlice()),
                resources[_locale][BURNABLE_ETH],
                _token.balanceOf(tx.origin).toString(),
                Actions.empty(),
                Tables.empty()
            );
            elements[1] = Elements.Element(
                true,
                AMOUNT,
                "tokenEdit".toSlice().concat(decimals.toString().toSlice()),
                resources[_locale][AMOUNT],
                "0",
                Actions.empty(),
                Tables.empty()
            );
            elements[2] = Elements.Element(
                true,
                BURN,
                "button",
                resources[_locale][BURN],
                "null",
                Actions.Action(
                    true,
                    address(_token),
                    "burn(uint256)",
                    '["amount"]',
                    resources[_locale][BURN_CONFIRM]
                ),
                Tables.empty()
            );
            Widgets.Widget memory widget = Widgets.Widget(
                resources[_locale][BURN_TOKENS],
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
