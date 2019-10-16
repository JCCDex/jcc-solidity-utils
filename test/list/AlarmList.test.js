/* eslint-disable indent */
/* eslint-disable semi */
/* eslint-disable no-undef */
const MockAlarmList = artifacts.require('MockAlarmList');

contract('AlarmList', (accounts) => {
  let al;
  beforeEach(async () => {
    al = await MockAlarmList.new();
  });

  it('AlarmList test', async () => {
    await al.insert(accounts[1], 0, Math.round(Date.now() / 1000), 0);
    await al.insert(accounts[2], 1, Math.round(Date.now() / 1000), 600);
    let count = await al.count();
    assert.equal(count, 2);

    await al.insert(accounts[2], 0, Math.round(Date.now() / 1000), 0);
    await al.insert(accounts[3], 1, Math.round(Date.now() / 1000), 500);
    count = await al.count();
    assert.equal(count, 3);

    // 当前数据顺序  account:[1,2,3]
    await al.remove(accounts[2]);
    count = await al.count();
    assert.equal(count, 2);

    // 当前数据顺序  account:[1,3]
    await al.insert(accounts[4], 1, Math.round(Date.now() / 1000), 300);
    // 当前数据顺序  account:[1,3,4]
    let task = await al.get(2)
    assert.equal(accounts[4], task.contractAddr);

    await al.insert(accounts[2], 0, Math.round(Date.now() / 1000), 0);
    // 当前数据顺序  account:[1,3,4,2]
    task = await al.get(2)
    assert.equal(accounts[4], task.contractAddr);

    await al.remove(accounts[3]);
    // 当前数据顺序  account:[1,2,4]
    count = await al.count();
    assert.equal(count, 3);

    await al.insert(accounts[3], 1, Math.round(Date.now() / 1000), 100);
    // 当前数据顺序  account:[1,2,4,3]
    task = await al.get(3)
    assert.equal(accounts[3], task.contractAddr);

    let all = await al.getList(0, 4);
    assert.equal(all.length, 4);
  });
});
