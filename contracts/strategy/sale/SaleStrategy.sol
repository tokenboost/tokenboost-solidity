pragma solidity ^0.4.24;

import "../Strategy.sol";
import "../../sale/Sale.sol";

contract SaleStrategy is Strategy {
    /**
     * @notice this.owner.selector ^ this.renounceOwnership.selector ^ this.transferOwnership.selector
        ^ this.template.selector ^ this.activate.selector ^ this.deactivate.selector
        ^ this.started.selector ^ this.successful.selector ^ this.finished.selector
     */
    bytes4 public constant InterfaceId_SaleStrategy = 0x04c8123d;

    Sale public sale;

    constructor(address _owner, Sale _sale) public Strategy(_owner) {
        sale = _sale;

        _registerInterface(InterfaceId_SaleStrategy);
    }

    modifier whenSaleActivated {
        require(sale.activated());
        _;
    }

    modifier whenSaleNotActivated {
        require(!sale.activated());
        _;
    }

    function activate() whenSaleNotActivated public returns (bool) {
        return super.activate();
    }

    function deactivate() onlyOwner whenSaleNotActivated public returns (bool) {
        activated = false;
        return true;
    }

    function started() public view returns (bool);

    function successful() public view returns (bool);

    function finished() public view returns (bool);
}
