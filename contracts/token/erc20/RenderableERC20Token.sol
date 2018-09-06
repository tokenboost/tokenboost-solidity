pragma solidity ^0.4.24;

import "./ERC20Token.sol";
import "../../widget/Renderable.sol";
import "./widget/ERC20TokenRenderer.sol";

contract RenderableERC20Token is ERC20Token, Renderable {
    ERC20TokenRenderer constant public renderer = ERC20TokenRenderer(address(bytes20("__ERC20TokenRenderer")));

    constructor(
        address _owner,
        string _name,
        string _symbol
    ) public ERC20Token(_owner, _name, _symbol) {
    }

    function adminWidgets(string _locale) public view returns (string jsonObject) {
        return renderer.adminWidgets(_locale, this);
    }

    function userWidgets(string _locale) public view returns (string jsonObject) {
        return renderer.userWidgets(_locale, this);
    }

    function inputs(string _locale) public view returns (string jsonArray) {
        return renderer.inputs(_locale, this);
    }
}