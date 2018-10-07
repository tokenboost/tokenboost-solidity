pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Boost.sol";
import "./sale/Sale.sol";
import "./template/sale/SaleTemplate.sol";

contract Raiser is ERC721Token("Raiser", "RAI"), Ownable {
    using SafeMath for uint256;

    event Mint(address indexed to, uint256 tokenId);

    uint256 public constant HALVING_WEI = 21000000 * (10 ** 18);
    uint256 public constant MAX_HALVING_ERA = 20;

    Boost public boost;
    uint256 public rewardEra = 0;

    uint256 weiUntilNextHalving = HALVING_WEI;
    mapping(uint256 => Sale) saleOfTokenId;
    mapping(uint256 => string) slugOfTokenId;
    mapping(uint256 => mapping(address => uint256)) rewardedBoostsOfSomeoneOfTokenId;

    constructor(Boost _boost) public {
        boost = _boost;
    }

    function mint(string _slug, SaleTemplate _template, bytes _bytecode, bytes _args) public payable {
        // InterfaceId_ERC165
        require(_template.supportsInterface(0x01ffc9a7));
        // InterfaceId_Template
        require(_template.supportsInterface(0xd48445ff));

        uint256 tokenId = toTokenId(_slug);
        require(address(saleOfTokenId[tokenId]) == address(0));

        Sale sale = Sale(_template.instantiate.value(msg.value)(_bytecode, _args));
        saleOfTokenId[tokenId] = sale;
        slugOfTokenId[tokenId] = _slug;

        _mint(msg.sender, tokenId);
        emit Mint(msg.sender, tokenId);
    }

    function toTokenId(string _slug) public pure returns (uint256 tokenId) {
        bytes memory chars = bytes(_slug);
        require(chars.length > 0, "String is empty.");
        for (uint i = 0; i < _min(chars.length, 32); i++) {
            uint c = uint(chars[i]);
            require(0x61 <= c && c <= 0x7a || c == 0x2d, "String must contain only lowercase alphabets or hyphens.");
        }
        assembly {
            tokenId := mload(add(chars, 32))
        }
    }

    function slugOf(uint256 _tokenId) public view returns (string slug) {
        return slugOfTokenId[_tokenId];
    }

    function saleOf(uint256 _tokenId) public view returns (Sale sale) {
        return saleOfTokenId[_tokenId];
    }

    function claimableBoostsOf(uint256 _tokenId) public view returns (uint256 boosts, uint256 newRewardEra, uint256 newWeiUntilNextHalving) {
        if (rewardedBoostsOfSomeoneOfTokenId[_tokenId][msg.sender] > 0) {
            return (0, rewardEra, weiUntilNextHalving);
        }

        Sale sale = saleOfTokenId[_tokenId];
        require(address(sale) != address(0));
        require(sale.finished());

        uint256 weiAmount = sale.paymentOf(msg.sender);
        if (sale.owner() == msg.sender) {
            weiAmount = weiAmount.add(sale.weiRaised());
        }
        return _weiToBoosts(weiAmount);
    }

    function claimBoostsOf(uint256 _tokenId) public returns (bool) {
        (uint256 boosts, uint256 newRewardEra, uint256 newWeiUntilNextHalving) = claimableBoostsOf(_tokenId);
        rewardEra = newRewardEra;
        weiUntilNextHalving = newWeiUntilNextHalving;
        if (boosts > 0) {
            boost.mint(msg.sender, boosts);
        }
        rewardedBoostsOfSomeoneOfTokenId[_tokenId][msg.sender] = boosts;
        return true;
    }

    function rewardedBoostsOf(uint256 _tokenId) public view returns (uint256 boosts) {
        return rewardedBoostsOfSomeoneOfTokenId[_tokenId][msg.sender];
    }

    function claimableBoosts() public view returns (uint256 boosts, uint256 newRewardEra, uint256 newWeiUntilNextHalving) {
        for (uint i = 0; i < totalSupply(); i++) {
            uint256 tokenId = tokenByIndex(i);
            (uint256 b, uint256 r, uint256 w) = claimableBoostsOf(tokenId);
            boosts = boosts.add(b);
            newRewardEra = r;
            newWeiUntilNextHalving = w;
        }
    }

    function claimBoosts() public returns (bool) {
        for (uint i = 0; i < totalSupply(); i++) {
            uint256 tokenId = tokenByIndex(i);
            claimBoostsOf(tokenId);
        }
        return true;
    }

    function rewardedBoosts() public view returns (uint256 boosts) {
        for (uint i = 0; i < totalSupply(); i++) {
            uint256 tokenId = tokenByIndex(i);
            boosts = boosts.add(rewardedBoostsOf(tokenId));
        }
    }

    function boostsUntilNextHalving() public view returns (uint256) {
        (uint256 boosts,,) = _weiToBoosts(weiUntilNextHalving);
        return boosts;
    }

    function _weiToBoosts(uint256 _weiAmount) private view returns (uint256 boosts, uint256 newRewardEra, uint256 newWeiUntilNextHalving) {
        if (rewardEra > MAX_HALVING_ERA) {
            return (0, rewardEra, weiUntilNextHalving);
        }
        uint256 amount = _weiAmount;
        boosts = 0;
        newRewardEra = rewardEra;
        newWeiUntilNextHalving = weiUntilNextHalving;
        while (amount > 0) {
            uint256 a = _min(amount, weiUntilNextHalving);
            boosts = boosts.add(a.mul(2 ** (MAX_HALVING_ERA.sub(newRewardEra)).div(1000)));
            amount = amount.sub(a);
            newWeiUntilNextHalving = newWeiUntilNextHalving.sub(a);
            if (newWeiUntilNextHalving == 0) {
                newWeiUntilNextHalving = HALVING_WEI;
                newRewardEra += 1;
            }
        }
    }

    function _min(uint256 _a, uint256 _b) private pure returns (uint256) {
        return _a < _b ? _a : _b;
    }
}
