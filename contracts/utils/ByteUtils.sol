pragma solidity ^0.4.24;

library ByteUtils {
    function pointer(bytes memory self) internal pure returns (uint ptr) {
        assembly {
            ptr := add(self, 0x20)
        }
    }

    function copy(bytes memory self, uint toOffset, bytes memory from, uint fromOffset, uint length) internal pure {
        // Copy word-length chunks while possible
        uint toPtr = pointer(self) + toOffset;
        uint fromPtr = pointer(from) + fromOffset;
        for (; length >= 32; length -= 32) {
            assembly {
                mstore(toPtr, mload(fromPtr))
            }
            toPtr += 32;
            fromPtr += 32;
        }

        // Copy remaining bytes
        uint mask = 256 ** (32 - length) - 1;
        assembly {
            let fromPart := and(mload(fromPtr), not(mask))
            let toPart := and(mload(toPtr), mask)
            mstore(toPtr, or(toPart, fromPart))
        }
    }
}