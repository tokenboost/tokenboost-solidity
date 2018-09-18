pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../Sale.sol";
import "../../utils/strings.sol";
import "../../strategy/sale/erc20/ERC20SaleStrategy.sol";

contract ERC20Sale is Sale {
    using SafeMath for uint256;
    using strings for *;

    /**
     * @notice this.owner.selector ^ this.renounceOwnership.selector ^ this.transferOwnership.selector
        ^ this.template.selector ^ this.activate.selector
        ^ this.projectName.selector ^ this.projectSummary.selector ^ this.projectDescription.selector
        ^ this.logoUrl.selector ^ this.coverImageUrl.selector ^ this.websiteUrl.selector ^ this.whitepaperUrl.selector
        ^ this.name.selector ^ this.weiRaised.selector ^ this.withdrawn.selector ^ this.ready.selector
        ^ this.started.selector ^ this.successful.selector ^ this.finished.selector ^ this.paymentOf.selector
        ^ bytes4(keccak256("update(string,string,string,string,string,string,string,string)"))
        ^ bytes4(keccak256("update(string,string,string,string,string,string,string,string,address)"))
        ^ this.addStrategy.selector ^ this.numberOfStrategies.selector ^ this.strategyAt.selector
        ^ this.numberOfActivatedStrategies.selector ^ this.activatedStrategyAt.selector
        ^ this.withdraw.selector ^ this.claimRefund.selector
     */
    bytes4 public constant InterfaceId_ERC20Sale = 0x95b5cfcb;

    event TokenPurchase(
        address indexed purchaser,
        uint256 weiAmount,
        uint256 tokenAmount
    );

    ERC20 public token;

    constructor(
        address _owner,
        string _projectName,
        string _name,
        ERC20 _token
    ) public Sale(_owner, _projectName, _name) {
        token = _token;

        _registerInterface(InterfaceId_ERC20Sale);
    }

    function update(
        string _projectName,
        string _projectSummary,
        string _projectDescription,
        string _logoUrl,
        string _coverImageUrl,
        string _websiteUrl,
        string _whitepaperUrl,
        string _name,
        ERC20 _token
    ) public {
        super.update(
            _projectName,
            _projectSummary,
            _projectDescription,
            _logoUrl,
            _coverImageUrl,
            _websiteUrl,
            _whitepaperUrl,
            _name
        );
        token = _token;
    }

    function() whenActivated external payable {
        require(!finished());
        require(started());
        require(_purchasable(msg.value));

        increasePaymentOf(msg.sender, msg.value);

        uint256 tokenAmount = _getTokenAmount(msg.value);
        address tokenReceiver = _tokenReceiver(msg.sender, tokenAmount);
        require(_supplyTokens(tokenReceiver, tokenAmount));

        emit TokenPurchase(msg.sender, msg.value, tokenAmount);
    }

    function _purchasable(uint256 _weiAmount) private view returns (bool) {
        bool p = true;
        for (uint i = 0; i < activatedStrategies.length; i++) {
            ERC20SaleStrategy strategy = ERC20SaleStrategy(activatedStrategies[i]);
            p = p && strategy.purchasable(msg.sender, _weiAmount);
        }
        return p;
    }

    function _getTokenAmount(uint256 _weiAmount) private view returns (uint256) {
        uint256 tokenAmount = _weiAmount;
        for (uint i = 0; i < activatedStrategies.length; i++) {
            ERC20SaleStrategy strategy = ERC20SaleStrategy(activatedStrategies[i]);
            uint256 rate = strategy.tokenRate(msg.sender, _weiAmount);
            require(rate > 0);

            tokenAmount = tokenAmount.mul(rate);
        }
        return tokenAmount;
    }

    function _tokenReceiver(address _purchaser, uint256 _tokenAmount) private returns (address) {
        for (uint i = 0; i < activatedStrategies.length; i++) {
            ERC20SaleStrategy strategy = ERC20SaleStrategy(activatedStrategies[i]);
            if (strategy.receivesTokens(_purchaser, _tokenAmount)) {
                return address(strategy);
            }
        }
        return _purchaser;
    }

    function _supplyTokens(address _to, uint256 _tokenAmount) private returns (bool) {
        for (uint i = 0; i < activatedStrategies.length; i++) {
            ERC20SaleStrategy strategy = ERC20SaleStrategy(activatedStrategies[i]);
            if (strategy.supplyTokens(_to, _tokenAmount)) {
                return true;
            }
        }
        return false;
    }
}
