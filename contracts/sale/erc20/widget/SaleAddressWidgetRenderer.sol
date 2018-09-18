pragma solidity ^0.4.24;

import "./ERC20SaleWidgetRenderer.sol";
import "../../../widget/Widgets.sol";
import "../../../utils/AddressUtils.sol";
import "../../../utils/StringUtils.sol";

contract SaleAddressWidgetRenderer is ERC20SaleWidgetRenderer {
    using Widgets for Widgets.Widget;
    using AddressUtils for address;
    using StringUtils for string;

    string public constant SALE_ADDRESS = "sale_address";
    string public constant SHORT_DESC = "short_desc";
    string public constant LONG_DESC = "long_desc";

    function render(string _locale, ERC20Sale _sale) public view returns (string) {
        Elements.Element[] memory elements = new Elements.Element[](1);
        elements[0] = Elements.Element(
            true,
            SALE_ADDRESS,
            "address",
            resources[_locale][SALE_ADDRESS],
            address(_sale).toString().quoted(),
            Actions.empty(),
            Tables.empty()
        );
        Widgets.Widget memory widget = Widgets.Widget(
            resources[_locale][SALE_ADDRESS],
            resources[_locale][SHORT_DESC],
            resources[_locale][LONG_DESC],
            2,
            elements
        );
        return widget.toJson();
    }
}
