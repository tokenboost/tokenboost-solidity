pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol";

contract Boost is MintableToken, DetailedERC20("Boost", "BST", 18) {
}
