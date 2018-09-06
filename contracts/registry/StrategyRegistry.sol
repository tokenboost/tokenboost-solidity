pragma solidity ^0.4.24;

import "./Registry.sol";

/**
 * @title Strategy Registry
 * @notice `Template` to be registered must be a `StrategyTemplate`.
 */
contract StrategyRegistry is Registry(false) {
}
