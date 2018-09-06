pragma solidity ^0.4.24;

import "../SaleStrategy.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../../../sale/erc20/ERC20Sale.sol";

contract ERC20SaleStrategy is SaleStrategy {
    /**
     * @notice this.owner.selector ^ this.renounceOwnership.selector ^ this.transferOwnership.selector
        ^ this.template.selector ^ this.activate.selector ^ this.deactivate.selector
        ^ this.started.selector ^ this.successful.selector ^ this.finished.selector
        ^ this.purchasable.selector ^ this.tokenRate.selector ^ this.supplyTokens.selector
        ^ this.receivesTokens.selector
     */
    bytes4 public constant InterfaceId_ERC20SaleStrategy = 0xa0d0304b;

    ERC20Sale public sale;

    constructor(address _owner, ERC20Sale _sale) public SaleStrategy(_owner, _sale) {
        sale = _sale;

        _registerInterface(InterfaceId_ERC20SaleStrategy);
    }

    function purchasable(address _purchaser, uint256 _weiAmount) public view returns (bool);

    function tokenRate(address _purchaser, uint256 _weiAmount) public view returns (uint256);

    function supplyTokens(address _purchaser, uint256 _tokenAmount) public returns (bool);

    function receivesTokens(address _purchaser, uint256 _tokenAmount) public returns (bool);
}
