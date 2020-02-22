/* eslint-disable indent */
/* eslint-disable semi */
/* eslint-disable no-undef */
const TransferList = artifacts.require('MockTransferList');
const assertRevert = require('../helpers/assertRevert');

contract('TransferList', (accounts) => {
  let al;
  beforeEach(async () => {
    al = await TransferList.new();
  });

  it('TransferList test', async () => {
    await al.insert(accounts[0], 4, 20, 'jPpwBGfNX4Eu94T8rnAEaanXgeQQwsy723');
    await al.insert(accounts[1], 4, 20, 'jPpwBGfNX4Eu94T8rnAEaanXgeQQwsy723');
    let count = await al.count();
    assert.equal(count, 2);

    await al.insert(accounts[1], 4, 20, 'jPpwBGfNX4Eu94T8rnAEaanXgeQQwsy723');
    count = await al.count();
    assert.equal(count, 3);

    data = await al.getByIdx(1)
    assert.equal('jPpwBGfNX4Eu94T8rnAEaanXgeQQwsy723', data.to);
  });
});
