/* eslint-disable indent */
/* eslint-disable semi */
/* eslint-disable no-undef */
const JCCChainList = artifacts.require('JCCChainList');
const assertRevert = require('../helpers/assertRevert');

contract('ChainList', (accounts) => {
  let al;
  beforeEach(async () => {
    al = await JCCChainList.new();
  });

  it('ChainList test', async () => {
    await al.insert(0, 'BTC');
    await al.insert(1, 'TEST');
    let count = await al.count();
    assert.equal(count, 2);

    await assertRevert(al.insert(0, 'BTC'));
    await al.insert(2, 'LTC');
    count = await al.count();
    assert.equal(count, 3);

    // 当前数据顺序  account:[1,2,3]
    await al.remove(1);
    count = await al.count();
    assert.equal(count, 2);

    // 当前数据顺序  account:[1,3]
    await al.insert(3, 'DOGE');
    // 当前数据顺序  account:[1,3,4]
    let data = await al.get(2)
    assert.equal(3, data.id);

    await al.insert(1, 'TEST');
    // 当前数据顺序  account:[1,3,4,2]
    data = await al.get(3)
    assert.equal(1, data.id);

    data = await al.getById(3)
    assert.equal('DOGE', data.symbol);

    data = await al.getBySymbol('LTC')
    assert.equal(2, data.id);

    let all = await al.getList(0, 4);
    assert.equal(all.length, 4);
  });
});
