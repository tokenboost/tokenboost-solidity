pragma solidity ^0.4.24;

import "./Actions.sol";

library Tables {
    using Actions for Actions.Action;
    using strings for *;

    struct Column {
        bool exists;
        string id;
        string type_;
        string label;
        Actions.Action action;
    }

    struct Table {
        bool exists;
        Column[] columns;
        string[] rows;
    }

    function empty() internal pure returns (Table memory) {
        return Table(false, new Column[](0), new string[](0));
    }

    function toJson(Table memory _self) internal pure returns (string) {
        if (_self.exists) {
            string memory json = '{"columns":[';
            uint length = 0;
            for (uint i = 0; i < _self.columns.length; i++) {
                if (length > 0) {
                    json = json.toSlice().concat(','.toSlice());
                }
                json = json.toSlice().concat(_columnToJson(_self.columns[i]).toSlice());
                length += 1;
            }
            json = json.toSlice().concat('],"rows":['.toSlice());
            length = 0;
            for (i = 0; i < _self.rows.length; i++) {
                if (length > 0) {
                    json = json.toSlice().concat(','.toSlice());
                }
                json = json.toSlice().concat(_self.rows[i].toSlice());
                length += 1;
            }
            return json.toSlice().concat(']}'.toSlice());
        } else {
            return "null";
        }
    }

    function _columnToJson(Column memory _self) internal pure returns (string) {
        if (_self.exists) {
            string memory json = '{"id":"';
            json = json.toSlice().concat(_self.id.toSlice());
            json = json.toSlice().concat('"'.toSlice());
            if (_self.action.exists) {
                json = json.toSlice().concat(','.toSlice());
                json = json.toSlice().concat('"action":'.toSlice());
                json = json.toSlice().concat(_self.action.toJson().toSlice());
            }
            json = json.toSlice().concat(',"type":"'.toSlice());
            json = json.toSlice().concat(_self.type_.toSlice());
            json = json.toSlice().concat('","label":"'.toSlice());
            json = json.toSlice().concat(_self.label.toSlice());
            return json.toSlice().concat('"}'.toSlice());
        } else {
            return "null";
        }
    }
}
