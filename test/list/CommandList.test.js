/* eslint-disable indent */
/* eslint-disable semi */
/* eslint-disable no-undef */
const CommandList = artifacts.require('MockCommandList');
const assertRevert = require('../helpers/assertRevert');

contract('CommandList', (accounts) => {
  let al;
  // let admin = accounts[0];
  let user = accounts[1];
  let agent = accounts[2];
  let ETH_CHAIN = 60;
  let MOAC_CHAIN = 314;

  beforeEach(async () => {
    al = await CommandList.new();
  });

  it('CommandList test', async () => {
    await al.insert(ETH_CHAIN, MOAC_CHAIN, 0, '0x00', { from: user });
    let count = await al.count();
    assert.equal(count, 1);
    count = await al.countBySubmitter(user);
    assert.equal(count, 1);
    // list [c1] waiting[0]
    let queue = await al.getWaitingIdx();
    assert.equal(queue.length, 1);
    // console.log('waiting:', queue);

    let cmd = await al.getByIdx(0, { from: agent });
    assert.equal(cmd.submitter, user);
    assert.equal(cmd.status, 1);
    // console.log(cmd);

    await al.lock(0, { from: agent });
    // list[c1] waiting[] locking[0]
    count = await al.countByAgent(agent);
    assert.equal(count, 1);
    cmd = await al.getByIdx(0, { from: agent });
    assert.equal(cmd.submitter, user);
    assert.equal(cmd.status, 2);
    count = await al.countWaiting();
    assert.equal(count, 0);
    count = await al.countLocking();
    assert.equal(count, 1);
    // queue = await al.getWaitingIdx();
    // console.log('waiting:', queue);
    // queue = await al.getLockingIdx();
    // console.log('locking:', queue);

    await al.insert(ETH_CHAIN, MOAC_CHAIN, 0, '0x00', { from: user });
    // list[c1,c2] waiting[1] locking[0]
    count = await al.count();
    assert.equal(count, 2);
    count = await al.countBySubmitter(user);
    assert.equal(count, 2);
    count = await al.countByAgent(agent);
    assert.equal(count, 1);
    count = await al.countWaiting();
    assert.equal(count, 1);
    count = await al.countLocking();
    assert.equal(count, 1);
    // queue = await al.getWaitingIdx();
    // console.log('waiting:', queue);
    // queue = await al.getLockingIdx();
    // console.log('locking:', queue);

    await al.cancel(1, { from: user });
    count = await al.countWaiting();
    assert.equal(count, 0);
    count = await al.countLocking();
    assert.equal(count, 1);
    count = await al.countCanceled();
    assert.equal(count, 1);

    // queue = await al.getWaitingIdx();
    // console.log('waiting:', queue);
    // queue = await al.getLockingIdx();
    // console.log('locking:', queue);
    // queue = await al.getLockingIdx();
    // console.log('locking:', queue);

    await al.cancel(0, { from: agent });
    count = await al.countWaiting();
    assert.equal(count, 0);
    count = await al.countLocking();
    assert.equal(count, 0);
    count = await al.countCanceled();
    assert.equal(count, 2);

    await al.insert(ETH_CHAIN, MOAC_CHAIN, 0, '0x00', { from: user });
    await al.lock(2, { from: agent });
    await al.complete(2, { from: agent });
    count = await al.countWaiting();
    assert.equal(count, 0);
    count = await al.countLocking();
    assert.equal(count, 0);
    count = await al.countCanceled();
    assert.equal(count, 2);
    count = await al.countCompleted();
    assert.equal(count, 1);
  });
});
