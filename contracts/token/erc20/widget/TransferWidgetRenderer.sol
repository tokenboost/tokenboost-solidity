pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol";
import "./ERC20TokenWidgetRenderer.sol";
import "../../../widget/Widgets.sol";

contract TransferWidgetRenderer is ERC20TokenWidgetRenderer {
    using Widgets for Widgets.Widget;
    using UintUtils for uint;

    string public constant TRANSFER = "transfer";
    string public constant SHORT_DESC = "short_desc";
    string public constant LONG_DESC = "long_desc";
    string public constant RECEIVER = "receiver";
    string public constant AMOUNT = "amount";
    string public constant TRANSFER_CONFIRM = "transfer_confirm";

    function render(string _locale, ERC20Token _token) public view returns (string) {
        if (_token.activated()) {
            Elements.Element[] memory elements = new Elements.Element[](3);
            DetailedERC20 erc20 = DetailedERC20(_token);
            uint256 decimals = uint256(erc20.decimals());
            elements[0] = Elements.Element(
                true,
                RECEIVER,
                "address",
                resources[_locale][RECEIVER],
                '""',
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
                TRANSFER,
                "button",
                resources[_locale][TRANSFER],
                "null",
                Actions.Action(
                    true,
                    address(_token),
                    "transfer(address,uint256)",
                    '["receiver","amount"]',
                    resources[_locale][TRANSFER_CONFIRM]
                ),
                Tables.empty()
            );
            Widgets.Widget memory widget = Widgets.Widget(
                resources[_locale][TRANSFER],
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
