module.exports = async function (web3) {
    return await new Promise((resolve, reject) => {
        web3.eth.getAccounts((err, res) => {
            if (err) {
                reject(err);
            } else {
                resolve(res);
            }
        });
    });
};