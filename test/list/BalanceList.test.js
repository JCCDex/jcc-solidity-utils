/* eslint-disable indent */
/* eslint-disable semi */
/* eslint-disable no-undef */
const MockBalanceList = artifacts.require('MockBalanceList');

contract('BalanceList', (accounts) => {
  let al;
  beforeEach(async () => {
    al = await MockBalanceList.new();
  });

  it('BalanceList test', async () => {
    await al.add(accounts[1], 1);
    await al.add(accounts[2], 2);
    let count = await al.count();
    assert.equal(count, 2);
    let b1 = await al.balance(accounts[1]);
    let b2 = await al.balance(accounts[2]);
    assert.equal(b1 == 1 && b2 == 2, true);

    // 现在 [1,2]
    await al.add(accounts[2], 2);
    await al.add(accounts[3], 3);
    count = await al.count();
    assert.equal(count, 3);
    let b3 = await al.balance(accounts[3]);
    b2 = await al.balance(accounts[2]);
    assert.equal(b3 == 3 && b2 == 4, true);

    // 现在 [1,2,3]
    await al.sub(accounts[2], 2);
    count = await al.count();
    assert.equal(count, 3);
    await al.sub(accounts[2], 2);
    b2 = await al.balance(accounts[2]);
    assert.equal(b2 == 0, true);
    count = await al.count();
    assert.equal(count, 2);

    // 现在 [1,3]
    await al.add(accounts[4], 4);
    let amount = await al.balance(accounts[2])
    assert.equal(amount, 0);
    count = await al.count();
    assert.equal(count, 3);

    // 现在 [1,3,4]
    await al.add(accounts[2], 2);
    amount = await al.balance(accounts[2])
    assert.equal(amount, 2);
    // 现在 [1,3,4,2]
    amount = await al.get(3)
    assert.equal(amount.balance, 2);
    assert.equal(amount.addr, accounts[2]);
    count = await al.count();
    assert.equal(count, 4);

    let all = await al.getList(0, 4);
    assert.equal(all.length, 4);
  });
});
