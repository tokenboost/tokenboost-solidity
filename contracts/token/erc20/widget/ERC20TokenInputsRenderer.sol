pragma solidity ^0.4.24;

import "./ERC20TokenWidgetRenderer.sol";
import "../../../utils/UintUtils.sol";
import "../../../utils/BoolUtils.sol";
import "../../../widget/Elements.sol";

contract ERC20TokenInputsRenderer is ERC20TokenWidgetRenderer {
    using UintUtils for uint;
    using BoolUtils for bool;
    using Elements for Elements.Element;

    string public constant NAME = "name";
    string public constant SYMBOL = "symbol";
    string public constant DECIMALS = "decimals";
    string public constant INITIAL_SUPPLY = "initial_supply";
    string public constant MINTALBE = "mintable";
    string public constant BURNABLE = "burnable";
    string public constant PAUSABLE = "pausable";
    string public constant UPDATE = "update";
    string public constant UPDATE_CONFIRM = "update_confirm";

    function render(string _locale, ERC20Token _token) public view returns (string) {
        Elements.Element[] memory elements = new Elements.Element[](8);
        elements[0] = Elements.Element(
            true,
            NAME,
            "textEdit",
            resources[_locale][NAME],
            quote(_token.name()),
            Actions.empty(),
            Tables.empty()
        );
        elements[1] = Elements.Element(
            true,
            SYMBOL,
            "textEdit",
            resources[_locale][SYMBOL],
            quote(_token.symbol()),
            Actions.empty(),
            Tables.empty()
        );
        elements[2] = Elements.Element(
            true,
            DECIMALS,
            "numberEdit",
            resources[_locale][DECIMALS],
            uint(_token.decimals()).toString(),
            Actions.empty(),
            Tables.empty()
        );
        elements[3] = Elements.Element(
            true,
            INITIAL_SUPPLY,
            "numberEdit",
            resources[_locale][INITIAL_SUPPLY],
            _token.initialSupply().toString(),
            Actions.empty(),
            Tables.empty()
        );
        elements[4] = Elements.Element(
            true,
            MINTALBE,
            "switch",
            resources[_locale][MINTALBE],
            _token.mintable().toString(),
            Actions.empty(),
            Tables.empty()
        );
        elements[5] = Elements.Element(
            true,
            BURNABLE,
            "switch",
            resources[_locale][BURNABLE],
            _token.burnable().toString(),
            Actions.empty(),
            Tables.empty()
        );
        elements[6] = Elements.Element(
            true,
            PAUSABLE,
            "switch",
            resources[_locale][PAUSABLE],
            _token.pausable().toString(),
            Actions.empty(),
            Tables.empty()
        );
        elements[7] = Elements.Element(
            true,
            UPDATE,
            "button",
            resources[_locale][UPDATE],
            "null",
            Actions.Action(
                true,
                address(_token),
                "update(string,string,uint8,uint256,bool,bool,bool)",
                '["name","symbol","decimals","initial_supply","mintable","burnable","pausable"]',
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
