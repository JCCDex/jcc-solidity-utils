/* eslint-disable indent */
/* eslint-disable semi */
/* eslint-disable no-undef */
const MockAddressList = artifacts.require('MockAddressList');

contract('AddressList', (accounts) => {
  let al;
  beforeEach(async () => {
    al = await MockAddressList.new();
  });

  it('AddressList test', async () => {
    await al.insert(accounts[1]);
    await al.insert(accounts[2]);
    let count = await al.count();
    assert.equal(count, 2);

    await al.insert(accounts[2]);
    await al.insert(accounts[3]);
    count = await al.count();
    assert.equal(count, 3);

    // 当前数据顺序  account:[1,2,3]
    await al.remove(accounts[2]);
    count = await al.count();
    assert.equal(count, 2);

    // 当前数据顺序  account:[1,3]
    await al.insert(accounts[4]);
    // 当前数据顺序  account:[1,3,4]
    let addr = await al.get(2)
    assert.equal(accounts[4], addr);

    await al.insert(accounts[2]);
    // 当前数据顺序  account:[1,3,4,2]
    addr = await al.get(2)
    assert.equal(accounts[4], addr);

    await al.remove(accounts[3]);
    // 当前数据顺序  account:[1,2,4]
    count = await al.count();
    assert.equal(count, 3);

    await al.insert(accounts[3]);
    // 当前数据顺序  account:[1,2,4,3]
    addr = await al.get(3)
    assert.equal(accounts[3], addr);

    let all = await al.getList(0, 4);
    assert.equal(all.length, 4);
  });
});
