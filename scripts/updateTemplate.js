String.prototype.toHex = function () {
    let arr = [];
    let i = 0, l = this.length;
    for (; i < l; i++) {
        let hex = Number(this.charCodeAt(i)).toString(16);
        arr.push(hex);
    }
    return arr.join('');
};

module.exports = async function (web3, identifier, Contract, WidgetRenderer, Template, Registry,
                                 price = 0, beneficiary = '0x00000000000000000000000000000000000000',
                                 name = '', description = '') {
    let bytecode = Contract.bytecode;
    if (WidgetRenderer != null) {
        let renderer = await WidgetRenderer.deployed();
        bytecode = Contract.bytecode.replace(
            new RegExp(("__" + WidgetRenderer.contractName + "__________________").substr(0, 20).toHex(), "gi"),
            renderer.address.substr(2)
        );
    }
    console.log("bytecode: " + bytecode);

    let bytecodeHash = web3.sha3(bytecode, {encoding: 'hex'});
    console.log("bytecodeHash: " + bytecodeHash);

    let template = await Template.new(bytecodeHash, price, beneficiary);
    await template.setNameAndDescription('', name, description);
    console.log(Template.contractName + ": " + template.address);

    let registry = await Registry.deployed();
    let versions = await registry.versionsOf(identifier);
    let version = versions.length === 0 ? 0 : parseInt(versions[versions.length - 1]) + 1;
    await registry.register(identifier, version, template.address);
};
