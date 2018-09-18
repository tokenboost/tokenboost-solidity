pragma solidity ^0.4.24;

import "./ERC20TokenWidgetRenderer.sol";
import "./ERC20TokenInputsRenderer.sol";

contract ERC20TokenRenderer {
    using strings for *;

    ERC20TokenWidgetRenderer[] adminWidgetRenderers;
    ERC20TokenWidgetRenderer[] userWidgetRenderers;
    ERC20TokenInputsRenderer public inputsRenderer;

    function setAdminWidgetRenderers(ERC20TokenWidgetRenderer[] _renderers) public {
        adminWidgetRenderers = _renderers;
    }

    function numberOfAdminWidgetRenderers() public returns (uint) {
        return adminWidgetRenderers.length;
    }

    function getAdminWidgetRendererAt(uint index) public returns (ERC20TokenWidgetRenderer) {
        return adminWidgetRenderers[index];
    }

    function setUserWidgetRenderers(ERC20TokenWidgetRenderer[] _renderers) public {
        userWidgetRenderers = _renderers;
    }

    function numberOfUserWidgetRenderers() public returns (uint) {
        return userWidgetRenderers.length;
    }

    function getUserWidgetRendererAt(uint index) public returns (ERC20TokenWidgetRenderer) {
        return userWidgetRenderers[index];
    }

    function setInputsRenderer(ERC20TokenInputsRenderer _renderer) public {
        inputsRenderer = _renderer;
    }

    function adminWidgets(string _locale, ERC20Token _token) public view returns (string jsonObject) {
        return _widgets(_locale, _token, adminWidgetRenderers);
    }

    function userWidgets(string _locale, ERC20Token _token) public view returns (string jsonObject) {
        return _widgets(_locale, _token, userWidgetRenderers);
    }

    function _widgets(string _locale, ERC20Token _token, ERC20TokenWidgetRenderer[] _widgetRenderes) private view returns (string) {
        string memory json = "[";
        uint length = 0;
        for (uint i = 0; i < _widgetRenderes.length; i++) {
            ERC20TokenWidgetRenderer renderer = _widgetRenderes[i];
            string memory widget = renderer.render(_locale, _token);
            if (bytes(widget).length > 0) {
                if (length > 0) {
                    json = json.toSlice().concat(",".toSlice());
                }
                json = json.toSlice().concat(widget.toSlice());
                length++;
            }
        }
        return json.toSlice().concat("]".toSlice());
    }

    function inputs(string _locale, ERC20Token _token) public view returns (string jsonArray) {
        return inputsRenderer.render(_locale, _token);
    }
}
