pragma solidity ^0.4.24;

import "./ERC20SaleWidgetRenderer.sol";
import "../../../utils/UintUtils.sol";
import "../../../utils/BoolUtils.sol";
import "../../../utils/AddressUtils.sol";
import "../../../widget/Elements.sol";
import "../ERC20Sale.sol";
import "../../../utils/StringUtils.sol";

contract ERC20SaleInputsRenderer is ERC20SaleWidgetRenderer {
    using strings for *;
    using UintUtils for uint;
    using BoolUtils for bool;
    using AddressUtils for address;
    using StringUtils for string;
    using Elements for Elements.Element;

    string public constant TOKEN_ADDRESS = "token_address";
    string public constant PROJECT_NAME = "project_name";
    string public constant PROJECT_SUMMARY = "project_summary";
    string public constant PROJECT_DESCRIPTION = "project_description";
    string public constant SALE_NAME = "sale_name";
    string public constant LOGO_URL = "logo_url";
    string public constant COVER_IMAGE_URL = "cover_image_url";
    string public constant WEBSITE_URL = "website_url";
    string public constant WHITEPAPER_URL = "whitepaper_url";
    string public constant UPDATE = "update";
    string public constant UPDATE_CONFIRM = "update_confirm";

    function render(string _locale, ERC20Sale _sale) public view returns (string) {
        Elements.Element[] memory elements = new Elements.Element[](10);
        elements[0] = Elements.Element(
            true,
            TOKEN_ADDRESS,
            "addressEdit",
            resources[_locale][TOKEN_ADDRESS],
            address(_sale.token()).toString().quoted(),
            Actions.empty(),
            Tables.empty()
        );
        elements[1] = Elements.Element(
            true,
            PROJECT_NAME,
            "textEdit",
            resources[_locale][PROJECT_NAME],
            _sale.projectName().quoted(),
            Actions.empty(),
            Tables.empty()
        );
        elements[2] = Elements.Element(
            true,
            PROJECT_SUMMARY,
            "textEdit",
            resources[_locale][PROJECT_SUMMARY],
            _sale.projectSummary().quoted(),
            Actions.empty(),
            Tables.empty()
        );
        elements[3] = Elements.Element(
            true,
            PROJECT_DESCRIPTION,
            "markdownEdit",
            resources[_locale][PROJECT_DESCRIPTION],
            _sale.projectSummary().quoted(),
            Actions.empty(),
            Tables.empty()
        );
        elements[4] = Elements.Element(
            true,
            SALE_NAME,
            "textEdit",
            resources[_locale][SALE_NAME],
            _sale.name().quoted(),
            Actions.empty(),
            Tables.empty()
        );
        elements[5] = Elements.Element(
            true,
            LOGO_URL,
            "urlEdit",
            resources[_locale][LOGO_URL],
            _sale.logoUrl().quoted(),
            Actions.empty(),
            Tables.empty()
        );
        elements[6] = Elements.Element(
            true,
            COVER_IMAGE_URL,
            "urlEdit",
            resources[_locale][COVER_IMAGE_URL],
            _sale.coverImageUrl().quoted(),
            Actions.empty(),
            Tables.empty()
        );
        elements[7] = Elements.Element(
            true,
            WEBSITE_URL,
            "urlEdit",
            resources[_locale][WEBSITE_URL],
            _sale.websiteUrl().quoted(),
            Actions.empty(),
            Tables.empty()
        );
        elements[8] = Elements.Element(
            true,
            WHITEPAPER_URL,
            "urlEdit",
            resources[_locale][WHITEPAPER_URL],
            _sale.whitepaperUrl().quoted(),
            Actions.empty(),
            Tables.empty()
        );
        elements[9] = Elements.Element(
            true,
            UPDATE,
            "button",
            resources[_locale][UPDATE],
            "null",
            Actions.Action(
                true,
                address(_sale),
                "update(string,string,string,string,string,string,string,string,address)",
                '["project_name","project_summary","project_description","logo_url","cover_image_url","website_url","whitepaper_url","sale_name","token_address"]',
                resources[_locale][UPDATE_CONFIRM]
            ),
            Tables.empty()
        );
        string memory json = "[";
        for (uint i = 0; i < elements.length; i++) {
            if (i > 0) {
                json = json.toSlice().concat(','.toSlice());
            }
            json = json.toSlice().concat(elements[i].toJson().toSlice());
        }
        return json.toSlice().concat(']'.toSlice());
    }
}
