pragma solidity ^0.4.24;

import "../template/Template.sol";

/**
 * @title Registry
 * @notice Registry maintains Contracts by version.
 */
contract Registry is Ownable {
    bool opened;
    string[] identifiers;
    mapping(string => address) registrantOfIdentifier;
    mapping(string => uint[]) versionsOfIdentifier;
    mapping(string => mapping(uint => Template)) templateOfVersionOfIdentifier;

    constructor(bool _opened) Ownable() public {
        opened = _opened;
    }

    /**
     * @notice Open the Registry so that anyone can register.
     */
    function open() onlyOwner public {
        opened = true;
    }

    /**
     * @notice Registers a new `Template`.
     * @param _identifier If any template was registered for the same identifier, the registrant of the templates must be the same.
     * @param _version If any template was registered for the same identifier, new version must be greater than the old one.
     * @param _template Template to be registered.
     */
    function register(string _identifier, uint _version, Template _template) public {
        require(opened || msg.sender == owner);

        // InterfaceId_ERC165
        require(_template.supportsInterface(0x01ffc9a7));
        // InterfaceId_Template
        require(_template.supportsInterface(0xd48445ff));

        address registrant = registrantOfIdentifier[_identifier];
        require(registrant == address(0) || registrant == msg.sender, "identifier already registered by another registrant");
        if (registrant == address(0)) {
            identifiers.push(_identifier);
            registrantOfIdentifier[_identifier] = msg.sender;
        }

        uint[] storage versions = versionsOfIdentifier[_identifier];
        if (versions.length > 0) {
            require(_version > versions[versions.length - 1], "new version must be greater than old versions");
        }
        versions.push(_version);
        templateOfVersionOfIdentifier[_identifier][_version] = _template;
    }

    function numberOfIdentifiers() public view returns (uint size) {
        return identifiers.length;
    }

    function identifierAt(uint _index) public view returns (string identifier) {
        return identifiers[_index];
    }

    function versionsOf(string _identifier) public view returns (uint[] version) {
        return versionsOfIdentifier[_identifier];
    }

    function templateOf(string _identifier, uint _version) public view returns (Template template) {
        return templateOfVersionOfIdentifier[_identifier][_version];
    }

    function latestTemplateOf(string _identifier) public view returns (Template template) {
        uint[] storage versions = versionsOfIdentifier[_identifier];
        return templateOfVersionOfIdentifier[_identifier][versions[versions.length - 1]];
    }
}
