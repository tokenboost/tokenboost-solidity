pragma solidity ^0.4.24;

import "./Actions.sol";
import "./Tables.sol";
import "../utils/strings.sol";

library Elements {
    using strings for *;
    using Actions for Actions.Action;
    using Tables for Tables.Table;

    struct Element {
        bool exists;
        string id;
        string type_;
        string label;
        string data;
        Actions.Action action;
        Tables.Table table;
    }

    function empty() internal pure returns (Element memory) {
        return Element(false, "", "", "", "", Actions.empty(), Tables.empty());
    }

    function toJson(Element memory _self) internal pure returns (string) {
        if (_self.exists) {
            string memory json = '{"id":"';
            json = json.toSlice().concat(_self.id.toSlice());
            json = json.toSlice().concat('"'.toSlice());
            if (_self.action.exists) {
                json = json.toSlice().concat(', "action":'.toSlice());
                json = json.toSlice().concat(_self.action.toJson().toSlice());
            }
            if (_self.table.exists) {
                json = json.toSlice().concat(', "table":'.toSlice());
                json = json.toSlice().concat(_self.table.toJson().toSlice());
            }
            json = json.toSlice().concat(',"type":"'.toSlice());
            json = json.toSlice().concat(_self.type_.toSlice());
            json = json.toSlice().concat('","label":"'.toSlice());
            json = json.toSlice().concat(_self.label.toSlice());
            json = json.toSlice().concat('","data":'.toSlice());
            json = json.toSlice().concat(_self.data.toSlice());
            return json.toSlice().concat('}'.toSlice());
        } else {
            return "null";
        }
    }
}