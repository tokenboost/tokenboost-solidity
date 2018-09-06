pragma solidity ^0.4.24;

import "./ERC20SaleWidgetRenderer.sol";
import "../../../widget/Widgets.sol";
import "../../../utils/AddressUtils.sol";

contract TokenInfoWidgetRenderer is ERC20SaleWidgetRenderer {
    using Widgets for Widgets.Widget;
    using AddressUtils for address;

    string public constant TOKEN_INFO = "token_info";
    string public constant TOKEN_STANDARD = "token_standard";
    string public constant TOKEN_ADDRESS = "token_address";
    string public constant SHORT_DESC = "short_desc";
    string public constant LONG_DESC = "long_desc";

    function render(string _locale, ERC20Sale _sale) public view returns (string) {
        Elements.Element[] memory elements = new Elements.Element[](2);
        elements[0] = Elements.Element(
            true,
            TOKEN_STANDARD,
            "text",
            resources[_locale][TOKEN_STANDARD],
            '"ERC20"',
            Actions.empty(),
            Tables.empty()
        );
        elements[1] = Elements.Element(
            true,
            TOKEN_ADDRESS,
            "address",
            resources[_locale][TOKEN_ADDRESS],
            quote(address(_sale.token()).toString()),
            Actions.empty(),
            Tables.empty()
        );
        Widgets.Widget memory widget = Widgets.Widget(
            resources[_locale][TOKEN_INFO],
            resources[_locale][SHORT_DESC],
            resources[_locale][LONG_DESC],
            4,
            elements
        );
        return widget.toJson();
    }
}
