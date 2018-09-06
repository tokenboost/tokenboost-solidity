pragma solidity ^0.4.24;

library AddressUtils {
    function isContract(address _self) internal view returns (bool _r) {
        assembly {
            _r := gt(extcodesize(_self), 0)
        }
    }

    function toString(address _self) internal pure returns (string memory) {
        bytes memory data = new bytes(42);
        data[0] = byte(48);
        data[1] = byte(120);
        uint160 num = uint160(_self);
        uint i;
        for (i = 0; i < 40; i++) {
            uint160 c = (num % 16) + 48;
            if (c > 57) c += 39;
            data[40 - i + 1] = byte(c);
            num /= 16;
        }
        return string(data);
    }
}