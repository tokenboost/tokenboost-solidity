pragma solidity ^0.4.24;

import "./ERC20Sale.sol";
import "../../widget/Renderable.sol";
import "./widget/ERC20SaleRenderer.sol";

contract RenderableERC20Sale is ERC20Sale, Renderable {
    ERC20SaleRenderer constant public renderer = ERC20SaleRenderer(address(bytes20("__ERC20SaleRenderer_")));

    constructor(
        address _owner,
        string _projectName,
        string _name,
        ERC20 _token
    ) public ERC20Sale(_owner, _projectName, _name, _token) {
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
