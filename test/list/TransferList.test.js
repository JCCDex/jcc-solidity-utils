/* eslint-disable indent */
/* eslint-disable semi */
/* eslint-disable no-undef */
const TransferList = artifacts.require('MockTransferList');
const assertRevert = require('../helpers/assertRevert');
const zeroAccount = require('../helpers/zeroAccount');
const BigNumber = require('bignumber.js');

contract('TransferList', (accounts) => {
  function getIssuerHash(chainId, issuer) {
    let s = web3.utils.padLeft(BigNumber(chainId).toString(16), 64);

    let _issuer;
    let _prefix = '';
    if (issuer.startsWith("0x")) {
      _issuer = issuer.substring(2);
      _prefix = '3078';
    } else {
      _issuer = issuer;
    }
    let ret = '0x' + s + _prefix + web3.utils.toHex(_issuer).substring(2);
    let hash = web3.utils.sha3(ret)
    return hash;
  }

  let al;
  beforeEach(async () => {
    al = await TransferList.new();
  });

  it('TransferList test', async () => {
    let tokenHash = getIssuerHash(314, zeroAccount);
    await al.insert(accounts[0], tokenHash, 20, 'jPpwBGfNX4Eu94T8rnAEaanXgeQQwsy723');
    await al.insert(accounts[1], tokenHash, 20, 'jPpwBGfNX4Eu94T8rnAEaanXgeQQwsy723');
    let count = await al.count();
    assert.equal(count, 2);

    await al.insert(accounts[1], tokenHash, 20, 'jPpwBGfNX4Eu94T8rnAEaanXgeQQwsy723');
    count = await al.count();
    assert.equal(count, 3);

    data = await al.getByIdx(1)
    assert.equal('jPpwBGfNX4Eu94T8rnAEaanXgeQQwsy723', data.to);
  });
});
