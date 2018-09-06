pragma solidity ^0.4.24;

import "../utils/strings.sol";
import "../utils/AddressUtils.sol";

library Actions {
    using strings for *;
    using AddressUtils for address;

    struct Action {
        bool exists;
        address to;
        string functionSelector;
        string arguments;
        string confirm;
    }

    function empty() internal pure returns (Action memory) {
        return Action(false, address(0), "", "", "");
    }

    function toJson(Action memory _self) internal pure returns (string) {
        if (_self.exists) {
            string memory json = '{"address":"';
            json = json.toSlice().concat(_self.to.toString().toSlice());
            json = json.toSlice().concat('","functionSelector":"'.toSlice());
            json = json.toSlice().concat(_self.functionSelector.toSlice());
            json = json.toSlice().concat('","arguments":'.toSlice());
            json = json.toSlice().concat(_self.arguments.toSlice());
            json = json.toSlice().concat(',"confirm":"'.toSlice());
            json = json.toSlice().concat(_self.confirm.toSlice());
            return json.toSlice().concat('"}'.toSlice());
        } else {
            return "null";
        }
    }
}
