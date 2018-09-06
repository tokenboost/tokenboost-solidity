pragma solidity ^0.4.24;

import "./Registry.sol";

/**
 * @title Token Registry
 * @notice `Template` to be registered must be a `TokenTemplate`.
 */
contract TokenRegistry is Registry(false) {
}
