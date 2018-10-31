pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "../Contract.sol";
import "../Activatable.sol";
import "../template/strategy/sale/SaleStrategyTemplate.sol";
import "../strategy/sale/SaleStrategy.sol";

contract Sale is Contract, Activatable {
    using SafeMath for uint;

    /**
     * @notice this.owner.selector ^ this.renounceOwnership.selector ^ this.transferOwnership.selector
        ^ this.template.selector ^ this.activate.selector
        ^ this.projectName.selector ^ this.projectSummary.selector ^ this.projectDescription.selector
        ^ this.logoUrl.selector ^ this.coverImageUrl.selector ^ this.websiteUrl.selector ^ this.whitepaperUrl.selector
        ^ this.videoUrl.selector ^ this.name.selector ^ this.weiRaised.selector ^ this.withdrawn.selector
        ^ this.started.selector ^ this.successful.selector ^ this.finished.selector
        ^ this.paymentOf.selector ^ this.update.selector ^ this.addStrategy.selector ^ this.numberOfStrategies.selector
        ^ this.strategyAt.selector ^ this.numberOfActivatedStrategies.selector ^ this.activatedStrategyAt.selector
        ^ this.withdraw.selector ^ this.claimRefund.selector ^ this.paymentOf.selector
        ^ this.numberOfPurchasers.selector ^ this.purchaserAt.selector
     */
    bytes4 public constant InterfaceId_Sale = 0x5efbb022;

    string public projectName;
    string public projectSummary;
    string public projectDescription;
    string public logoUrl;
    string public coverImageUrl;
    string public websiteUrl;
    string public whitepaperUrl;
    string public videoUrl;
    string public name;

    uint256 public weiRaised;
    bool public withdrawn;

    SaleStrategy[] strategies;
    SaleStrategy[] activatedStrategies;
    mapping(address => uint256) paymentOfPurchaser;
    address[] purchasers;

    constructor(
        address _owner,
        string _projectName,
        string _name
    ) public Contract(_owner) {
        projectName = _projectName;
        name = _name;

        _registerInterface(InterfaceId_Sale);
    }

    function update(
        string _projectName,
        string _projectSummary,
        string _projectDescription,
        string _logoUrl,
        string _coverImageUrl,
        string _websiteUrl,
        string _whitepaperUrl,
        string _videoUrl,
        string _name
    ) public onlyOwner whenNotActivated {
        projectName = _projectName;
        projectSummary = _projectSummary;
        projectDescription = _projectDescription;
        logoUrl = _logoUrl;
        coverImageUrl = _coverImageUrl;
        websiteUrl = _websiteUrl;
        whitepaperUrl = _whitepaperUrl;
        videoUrl = _videoUrl;
        name = _name;
    }

    function addStrategy(SaleStrategyTemplate _template, bytes _bytecode) onlyOwner whenNotActivated public payable {
        // InterfaceId_ERC165
        require(_template.supportsInterface(0x01ffc9a7));
        // InterfaceId_Template
        require(_template.supportsInterface(0xd48445ff));

        require(_isUniqueStrategy(_template));

        bytes memory args = abi.encode(msg.sender, address(this));
        SaleStrategy strategy = SaleStrategy(_template.instantiate.value(msg.value)(_bytecode, args));
        strategies.push(strategy);
    }

    function _isUniqueStrategy(SaleStrategyTemplate _template) private view returns (bool) {
        for (uint i = 0; i < strategies.length; i++) {
            SaleStrategy strategy = strategies[i];
            if (address(strategy.template()) == address(_template)) {
                return false;
            }
        }
        return true;
    }

    function numberOfStrategies() public view returns (uint256) {
        return strategies.length;
    }

    function strategyAt(uint256 index) public view returns (address) {
        return strategies[index];
    }

    function numberOfActivatedStrategies() public view returns (uint256) {
        return activatedStrategies.length;
    }

    function activatedStrategyAt(uint256 index) public view returns (address) {
        return activatedStrategies[index];
    }

    function activate() onlyOwner public returns (bool) {
        for (uint i = 0; i < strategies.length; i++) {
            SaleStrategy strategy = strategies[i];
            if (strategy.activated()) {
                activatedStrategies.push(strategy);
            }
        }
        return super.activate();
    }

    function started() public view returns (bool) {
        if (!activated) return false;

        bool s = false;
        for (uint i = 0; i < activatedStrategies.length; i++) {
            s = s || activatedStrategies[i].started();
        }
        return s;
    }

    function successful() public view returns (bool){
        if (!started()) return false;

        bool s = false;
        for (uint i = 0; i < activatedStrategies.length; i++) {
            s = s || activatedStrategies[i].successful();
        }
        return s;
    }

    function finished() public view returns (bool){
        if (!started()) return false;

        bool f = false;
        for (uint i = 0; i < activatedStrategies.length; i++) {
            f = f || activatedStrategies[i].finished();
        }
        return f;
    }

    function() external payable;

    function increasePaymentOf(address _purchaser, uint256 _weiAmount) internal {
        require(!finished());
        require(started());

        paymentOfPurchaser[_purchaser] = paymentOfPurchaser[_purchaser].add(_weiAmount);
        weiRaised = weiRaised.add(_weiAmount);
        for (uint i = 0; i < purchasers.length; i++) {
            if (purchasers[i] == _purchaser) {
                return;
            }
        }
        purchasers.push(_purchaser);
    }

    function paymentOf(address _purchaser) public view returns (uint256 weiAmount) {
        return paymentOfPurchaser[_purchaser];
    }

    function numberOfPurchasers() public view returns (uint256) {
        return purchasers.length;
    }

    function purchaserAt(uint256 _index) public view returns (address) {
        return purchasers[_index];
    }

    function withdraw() onlyOwner whenActivated public returns (bool) {
        require(!withdrawn);
        require(finished());
        require(successful());

        withdrawn = true;
        msg.sender.transfer(weiRaised);

        return true;
    }

    function claimRefund() whenActivated public returns (bool) {
        require(finished());
        require(!successful());

        uint256 amount = paymentOfPurchaser[msg.sender];
        require(amount > 0);

        paymentOfPurchaser[msg.sender] = 0;
        msg.sender.transfer(amount);

        return true;
    }
}