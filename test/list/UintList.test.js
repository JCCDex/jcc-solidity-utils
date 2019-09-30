/* eslint-disable indent */
/* eslint-disable semi */
/* eslint-disable no-undef */
const MockUintList = artifacts.require('MockUintList');

contract('UintList', (accounts) => {
  let al;
  let uint1 = 1;
  let uint2 = 2;
  let uint3 = 3;
  let uint4 = 4;

  beforeEach(async () => {
    al = await MockUintList.new();
  });

  it('UintList test', async () => {
    await al.insert(uint1);
    await al.insert(uint2);
    let count = await al.count();
    assert.equal(count, 2);

    await al.insert(uint2);
    await al.insert(uint3);
    count = await al.count();
    assert.equal(count, 3);

    // 当前数据顺序  account:[1,2,3]
    await al.remove(uint2);
    count = await al.count();
    assert.equal(count, 2);

    // 当前数据顺序  account:[1,3]
    await al.insert(uint4);
    // 当前数据顺序  account:[1,3,4]
    let addr = await al.get(2)
    assert.equal(uint4, addr);

    await al.insert(uint2);
    // 当前数据顺序  account:[1,3,4,2]
    addr = await al.get(2)
    assert.equal(uint4, addr);

    await al.remove(uint3);
    // 当前数据顺序  account:[1,2,4]
    count = await al.count();
    assert.equal(count, 3);

    await al.insert(uint3);
    // 当前数据顺序  account:[1,2,4,3]
    addr = await al.get(3)
    assert.equal(uint3, addr);

    let all = await al.getList(0, 4);
    assert.equal(all.length, 4);
  });
});
