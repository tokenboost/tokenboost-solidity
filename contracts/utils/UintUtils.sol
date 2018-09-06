pragma solidity ^0.4.24;

library UintUtils {
    function toString(uint _self) internal pure returns (string memory) {
        if (_self == 0) {
            return "0";
        }
        bytes memory _tmp = new bytes(32);
        uint i;
        for (i = 0; _self > 0; i++) {
            _tmp[i] = byte((_self % 10) + 48);
            _self /= 10;
        }
        bytes memory _real = new bytes(i--);
        for (uint j = 0; j < _real.length; j++) {
            _real[j] = _tmp[i--];
        }
        return string(_real);
    }
}
