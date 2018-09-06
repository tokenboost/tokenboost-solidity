pragma solidity ^0.4.24;

import "./Elements.sol";
import "../utils/strings.sol";
import "../utils/UintUtils.sol";

library Widgets {
    using strings for *;
    using UintUtils for uint;
    using Elements for Elements.Element;

    struct Widget {
        string title;
        string shortDesc;
        string longDesc;
        uint width;
        Elements.Element[] elements;
    }

    function toJson(Widget memory _self) internal pure returns (string) {
        string memory json = '{"title":"';
        json = json.toSlice().concat(_self.title.toSlice());
        json = json.toSlice().concat('","shortDesc":"'.toSlice());
        json = json.toSlice().concat(_self.shortDesc.toSlice());
        json = json.toSlice().concat('","longDesc":"'.toSlice());
        json = json.toSlice().concat(_self.longDesc.toSlice());
        json = json.toSlice().concat('","width":'.toSlice());
        json = json.toSlice().concat(_self.width.toString().toSlice());
        json = json.toSlice().concat(',"elements":['.toSlice());
        for (uint i = 0; i < _self.elements.length; i++) {
            if (i > 0) {
                json = json.toSlice().concat(','.toSlice());
            }
            json = json.toSlice().concat(_self.elements[i].toJson().toSlice());
        }
        return json.toSlice().concat(']}'.toSlice());
    }
}