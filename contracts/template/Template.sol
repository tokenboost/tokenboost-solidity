pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol";
import "../Contract.sol";

/**
 * @title Template
 * @notice Template instantiates `Contract`s of the same form.
 */
contract Template is Ownable, SupportsInterfaceWithLookup {
    /**
     * @notice this.owner.selector ^ this.renounceOwnership.selector ^ this.transferOwnership.selector
        ^ this.bytecodeHash.selector ^ this.price.selector ^ this.beneficiary.selector
        ^ this.name.selector ^ this.description.selector ^ this.setNameAndDescription.selector
        ^ this.instantiate.selector
     */
    bytes4 public constant InterfaceId_Template = 0xd48445ff;

    mapping(string => string) nameOfLocale;
    mapping(string => string) descriptionOfLocale;
    /**
     * @notice Hash of EVM bytecode to be instantiated.
     */
    bytes32 public bytecodeHash;
    /**
     * @notice Price to pay when instantiating
     */
    uint public price;
    /**
     * @notice Address to receive payment
     */
    address public beneficiary;

    /**
     * @notice Logged when a new `Contract` instantiated.
     */
    event Instantiated(address indexed creator, address indexed contractAddress);

    /**
     * @param _bytecodeHash Hash of EVM bytecode
     * @param _price Price of instantiating in wei
     * @param _beneficiary Address to transfer _price when instantiating
     */
    constructor(
        bytes32 _bytecodeHash,
        uint _price,
        address _beneficiary
    ) public {
        bytecodeHash = _bytecodeHash;
        price = _price;
        beneficiary = _beneficiary;
        if (price > 0) {
            require(beneficiary != address(0));
        }

        _registerInterface(InterfaceId_Template);
    }

    /**
     * @param _locale IETF language tag(https://en.wikipedia.org/wiki/IETF_language_tag)
     * @return Name in `_locale`.
     */
    function name(string _locale) public view returns (string) {
        return nameOfLocale[_locale];
    }

    /**
     * @param _locale IETF language tag(https://en.wikipedia.org/wiki/IETF_language_tag)
     * @return Description in `_locale`.
     */
    function description(string _locale) public view returns (string) {
        return descriptionOfLocale[_locale];
    }

    /**
     * @param _locale IETF language tag(https://en.wikipedia.org/wiki/IETF_language_tag)
     * @param _name Name to set
     * @param _description Description to set
     */
    function setNameAndDescription(string _locale, string _name, string _description) public onlyOwner {
        nameOfLocale[_locale] = _name;
        descriptionOfLocale[_locale] = _description;
    }

    /**
     * @notice `msg.sender` is passed as first argument for the newly created `Contract`.
     * @param _bytecode Bytecode corresponding to `bytecodeHash`
     * @param _args If arguments where passed to this function, those will be appended to the arguments for `Contract`.
     * @return Newly created contract account's address
     */
    function instantiate(bytes _bytecode, bytes _args) public payable returns (address contractAddress) {
        require(bytecodeHash == keccak256(_bytecode));
        bytes memory calldata = abi.encodePacked(_bytecode, _args);
        assembly {
            contractAddress := create(0, add(calldata, 0x20), mload(calldata))
        }
        if (contractAddress == address(0)) {
            revert("Cannot instantiate contract");
        } else {
            Contract c = Contract(contractAddress);
            // InterfaceId_ERC165
            require(c.supportsInterface(0x01ffc9a7));
            // InterfaceId_Contract
            require(c.supportsInterface(0x6125ede5));

            if (price > 0) {
                require(msg.value == price);
                beneficiary.transfer(msg.value);
            }
            emit Instantiated(msg.sender, contractAddress);
        }
    }
}
