pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol";
import "./ERC20TokenWidgetRenderer.sol";
import "../../../widget/Widgets.sol";

contract MintTokensWidgetRenderer is ERC20TokenWidgetRenderer {
    using strings for *;
    using Widgets for Widgets.Widget;
    using UintUtils for uint;
    using SafeMath for uint;

    string public constant MINT_TOKENS = "mint_tokens";
    string public constant SHORT_DESC = "short_desc";
    string public constant LONG_DESC = "long_desc";
    string public constant MINTABLE_ETH = "mintable_eth";
    string public constant ADDRESS = "address";
    string public constant AMOUNT = "amount";
    string public constant MINT = "mint";
    string public constant MINT_CONFIRM = "mint_confirm";

    function render(string _locale, ERC20Token _token) public view returns (string) {
        if (_token.mintable() && _token.activated()) {
            uint maxMintable = _token.maxMintable();
            uint totalSupply = _token.totalSupply();
            uint mintableEth = maxMintable > totalSupply ? maxMintable.sub(totalSupply) : 0;
            DetailedERC20 erc20 = DetailedERC20(_token);
            uint256 decimals = uint256(erc20.decimals());
            Elements.Element[] memory elements = new Elements.Element[](4);
            elements[0] = Elements.Element(
                true,
                MINTABLE_ETH,
                "token".toSlice().concat(decimals.toString().toSlice()),
                resources[_locale][MINTABLE_ETH],
                mintableEth.toString(),
                Actions.empty(),
                Tables.empty()
            );
            elements[1] = Elements.Element(
                true,
                ADDRESS,
                "addressEdit",
                resources[_locale][ADDRESS],
                '""',
                Actions.empty(),
                Tables.empty()
            );
            elements[2] = Elements.Element(
                true,
                AMOUNT,
                "tokenEdit".toSlice().concat(decimals.toString().toSlice()),
                resources[_locale][AMOUNT],
                "0",
                Actions.empty(),
                Tables.empty()
            );
            elements[3] = Elements.Element(
                true,
                MINT,
                "button",
                resources[_locale][MINT],
                "null",
                Actions.Action(
                    true,
                    address(_token),
                    "mint()",
                    '{"address":"address","amount":"uint"}',
                    resources[_locale][MINT_CONFIRM]
                ),
                Tables.empty()
            );
            Widgets.Widget memory widget = Widgets.Widget(
                resources[_locale][MINT_TOKENS],
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
