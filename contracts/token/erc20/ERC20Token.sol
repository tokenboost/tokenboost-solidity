pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/token/ERC20/RBACMintableToken.sol";
import "zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";
import "zeppelin-solidity/contracts/token/ERC20/PausableToken.sol";
import "../Token.sol";

contract ERC20Token is Token, RBACMintableToken, BurnableToken, PausableToken {
    /**
     * @notice this.owner.selector ^ this.renounceOwnership.selector ^ this.transferOwnership.selector
        ^ this.template.selector ^ this.activate.selector ^ this.name.selector ^ this.symbol.selector
        ^ this.totalSupply.selector ^ this.balanceOf.selector ^ bytes4(keccak256("transfer(address,uint256)"))
        ^ this.allowance.selector ^ this.transferFrom.selector ^ this.approve.selector
        ^ this.increaseApproval.selector ^ this.decreaseApproval.selector
        ^ this.mintingFinished.selector ^ this.finishMinting.selector ^ this.checkRole.selector ^ this.hasRole.selector
        ^ this.ROLE_MINTER.selector ^ this.addMinter.selector ^ this.removeMinter.selector
        ^ this.burn.selector ^ this.paused.selector ^ this.pause.selector ^ this.unpause.selector
        ^ this.decimals.selector ^ this.initialSupply.selector ^ this.mintable.selector ^ this.maxMintable.selector
        ^ this.burnable.selector ^ this.pausable.selector ^ this.update.selector ^ this.setMaxMintable.selector
     */
    bytes4 public constant InterfaceId_ERC20Token = 0x98b0f321;

    uint8 public decimals = 18;
    uint256 public initialSupply;
    bool public mintable;
    uint256 public maxMintable;
    bool public burnable;
    bool public pausable;

    modifier whenBurnable() {
        require(burnable);
        _;
    }

    modifier whenMintable() {
        require(mintable);
        _;
    }

    modifier whenPausable() {
        require(pausable);
        _;
    }

    constructor(
        address _owner,
        string _name,
        string _symbol
    ) public Token(_owner, _name, _symbol) {

        _registerInterface(InterfaceId_ERC20Token);
    }

    function update(
        string _name,
        string _symbol,
        uint8 _decimals,
        uint256 _initialSupply,
        bool _mintable,
        bool _burnable,
        bool _pausable
    ) public onlyOwner whenNotActivated {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        initialSupply = _initialSupply;
        mintable = _mintable;
        burnable = _burnable;
        pausable = _pausable;
    }

    function setMaxMintable(uint _maxMintable) onlyOwner whenNotActivated public {
        maxMintable = _maxMintable;
    }

    function activate() public returns (bool) {
        totalSupply_ = initialSupply;
        balances[owner] = totalSupply_;
        return super.activate();
    }

    function transfer(address _to, uint256 _value) whenActivated public returns (bool) {
        return super.transfer(_to, _value);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) whenActivated public returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }

    function approve(address spender, uint256 value) whenActivated public returns (bool) {
        return super.approve(spender, value);
    }

    function mint(address _to, uint256 _amount) whenActivated public returns (bool) {
        if (maxMintable > 0) {
            require(totalSupply_.add(_amount) <= maxMintable);
        }
        return super.mint(_to, _amount);
    }

    function burn(uint256 _value) whenActivated public {
        super.burn(_value);
    }

    function pause() whenPausable public {
        super.pause();
    }
}