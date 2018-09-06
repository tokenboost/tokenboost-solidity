pragma solidity ^0.4.24;

import "../ERC20Sale.sol";
import "./ERC20SaleWidgetRenderer.sol";
import "./ERC20SaleInputsRenderer.sol";

contract ERC20SaleRenderer {
    using strings for *;

    ERC20SaleWidgetRenderer[] public adminWidgetRenderers;
    ERC20SaleWidgetRenderer[] public userWidgetRenderers;
    ERC20SaleInputsRenderer public inputsRenderer;

    function addAdminWidgetRenderers(ERC20SaleWidgetRenderer[] _renderers) public {
        for (uint i = 0; i < _renderers.length; i++) {
            adminWidgetRenderers.push(_renderers[i]);
        }
    }

    function addUserWidgetRenderers(ERC20SaleWidgetRenderer[] _renderers) public {
        for (uint i = 0; i < _renderers.length; i++) {
            userWidgetRenderers.push(_renderers[i]);
        }
    }

    function setInputsRenderer(ERC20SaleInputsRenderer _renderer) public {
        inputsRenderer = _renderer;
    }

    function adminWidgets(string _locale, ERC20Sale _sale) public view returns (string jsonObject) {
        return _widgets(_locale, _sale, adminWidgetRenderers);
    }

    function userWidgets(string _locale, ERC20Sale _sale) public view returns (string jsonObject) {
        return _widgets(_locale, _sale, userWidgetRenderers);
    }

    function _widgets(string _locale, ERC20Sale _sale, ERC20SaleWidgetRenderer[] _widgetRenderes) private view returns (string) {
        string memory json = "[";
        uint length = 0;
        for (uint i = 0; i < _widgetRenderes.length; i++) {
            ERC20SaleWidgetRenderer renderer = _widgetRenderes[i];
            string memory widget = renderer.render(_locale, _sale);
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

    function inputs(string _locale, ERC20Sale _sale) public view returns (string jsonArray) {
        return inputsRenderer.render(_locale, _sale);
    }
}
