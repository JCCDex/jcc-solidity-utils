/* eslint-disable indent */
/* eslint-disable semi */
/* eslint-disable no-undef */
const MockHashList = artifacts.require('MockHashList');

contract('HashList', (accounts) => {
  let al;
  let hash1 = "0x1294eed407c15a893f3ec3fd269fa4b90f1f1e0376893bbed069c754147b4c5b";
  let hash2 = "0x2294eed407c15a893f3ec3fd269fa4b90f1f1e0376893bbed069c754147b4c5b";
  let hash3 = "0x3294eed407c15a893f3ec3fd269fa4b90f1f1e0376893bbed069c754147b4c5b";
  let hash4 = "0x4294eed407c15a893f3ec3fd269fa4b90f1f1e0376893bbed069c754147b4c5b";
  // let hash5 = "0x5294eed407c15a893f3ec3fd269fa4b90f1f1e0376893bbed069c754147b4c5b";

  beforeEach(async () => {
    al = await MockHashList.new();
  });

  it('HashList test', async () => {
    await al.insert(hash1);
    await al.insert(hash2);
    let count = await al.count();
    assert.equal(count, 2);

    await al.insert(hash2);
    await al.insert(hash3);
    count = await al.count();
    assert.equal(count, 3);

    // 当前数据顺序  account:[1,2,3]
    await al.remove(hash2);
    count = await al.count();
    assert.equal(count, 2);

    // 当前数据顺序  account:[1,3]
    await al.insert(hash4);
    // 当前数据顺序  account:[1,3,4]
    let addr = await al.get(2)
    assert.equal(hash4, addr);

    await al.insert(hash2);
    // 当前数据顺序  account:[1,3,4,2]
    addr = await al.get(2)
    assert.equal(hash4, addr);

    await al.remove(hash3);
    // 当前数据顺序  account:[1,2,4]
    count = await al.count();
    assert.equal(count, 3);

    await al.insert(hash3);
    // 当前数据顺序  account:[1,2,4,3]
    addr = await al.get(3)
    assert.equal(hash3, addr);

    let all = await al.getList(0, 4);
    assert.equal(all.length, 4);
  });
});
