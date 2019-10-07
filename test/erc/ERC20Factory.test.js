/* eslint-disable indent */
/* eslint-disable semi */
/* eslint-disable no-undef */
const ERC20Factory = artifacts.require('ERC20Factory');
const assertRevert = require('../helpers/assertRevert');
const zeroAccount = require('../helpers/zeroAccount');

contract('ERC20Factory', (accounts) => {
  let erc20;

  it('erc20 minable is false', async () => {
    erc20 = await ERC20Factory.new("JC Token", "JCC", 18, 2000000000, false);
    let total = await erc20.totalSupply();
    assert.equal(total.toString(), "2000000000000000000000000000");

    // 属主和管理员是同一个账户，转移授权一个管理员
    let owner = await erc20.owner();
    let admin = await erc20.admin();
    assert.equal(owner, admin);

    await erc20.transferAdministrator(accounts[1], { from: accounts[0] });
    admin = await erc20.admin();
    assert.equal(accounts[0], owner);
    assert.equal(accounts[1], admin);


    let { logs } = await erc20.transfer(accounts[2], web3.utils.toWei('1000000000'), { from: accounts[0] });
    Events = logs.find(e => e.event === 'Transfer');
    assert.notEqual(Events, undefined);
    let b0 = await erc20.balanceOf(accounts[0]);
    let b2 = await erc20.balanceOf(accounts[2]);
    assert.equal(b0.toString(), b2.toString());

    // 制造目的地址为0的转账
    await assertRevert(erc20.transfer(zeroAccount, web3.utils.toWei('1000000000'), { from: accounts[2] }));

    // 制造一次余额不足的转账
    await assertRevert(erc20.transfer(accounts[0], web3.utils.toWei('1000000001'), { from: accounts[2] }));

    // 测试授权转账
    await erc20.approve(accounts[1], web3.utils.toWei('1000000000'), { from: accounts[2] });
    let allow = await erc20.allowance(accounts[2], accounts[1]);
    assert.equal(web3.utils.fromWei(allow).toString(), '1000000000');

    await erc20.transferFrom(accounts[2], accounts[3], web3.utils.toWei('500000000'), { from: accounts[1] })
    let b3 = await erc20.balanceOf(accounts[3]);
    assert.equal(web3.utils.fromWei(b3).toString(), '500000000');
    allow = await erc20.allowance(accounts[2], accounts[1]);
    assert.equal(web3.utils.fromWei(allow).toString(), '500000000');

    // 调整授权
    await erc20.increaseAllowance(accounts[1], web3.utils.toWei('250000000'), { from: accounts[2] });
    allow = await erc20.allowance(accounts[2], accounts[1]);
    assert.equal(web3.utils.fromWei(allow).toString(), '750000000');

    await erc20.decreaseAllowance(accounts[1], web3.utils.toWei('50000000'), { from: accounts[2] });
    allow = await erc20.allowance(accounts[2], accounts[1]);
    assert.equal(web3.utils.fromWei(allow).toString(), '700000000');

    // 尝试销毁accounts[0]里面资产，非minable禁止销毁和增发
    await assertRevert(erc20.burn(accounts[2], web3.utils.toWei('25000000'), { from: accounts[1] }));
    total = await erc20.totalSupply();
    assert.equal(web3.utils.fromWei(total).toString(), '2000000000');
    b2 = await erc20.balanceOf(accounts[2]);
    assert.equal(web3.utils.fromWei(b2).toString(), '500000000');
  });

  it('erc20 minable is true', async () => {
    erc20 = await ERC20Factory.new("JC Token", "JCC", 18, 2000000000, true);
    let total = await erc20.totalSupply();
    assert.equal(total.toString(), "0");

    // 属主和管理员是同一个账户，转移授权一个管理员
    let owner = await erc20.owner();
    let admin = await erc20.admin();
    assert.equal(owner, admin);

    await erc20.transferAdministrator(accounts[1], { from: accounts[0] });
    admin = await erc20.admin();
    assert.equal(accounts[0], owner);
    assert.equal(accounts[1], admin);

    // 铸币
    let { logs } = await erc20.mint(accounts[2], web3.utils.toWei('1000000000'), { from: accounts[0] });
    let Events = logs.find(e => e.event === 'Mint');
    assert.notEqual(Events, undefined);
    Events = logs.find(e => e.event === 'Transfer');
    assert.notEqual(Events, undefined);

    let ret = await erc20.transfer(accounts[3], web3.utils.toWei('500000000'), { from: accounts[2] });
    Events = ret.logs.find(e => e.event === 'Transfer');
    assert.notEqual(Events, undefined);
    let b2 = await erc20.balanceOf(accounts[2]);
    let b3 = await erc20.balanceOf(accounts[3]);
    assert.equal(b2.toString(), b3.toString());

    // 制造目的地址为0的转账
    await assertRevert(erc20.transfer(zeroAccount, web3.utils.toWei('500000000'), { from: accounts[2] }));

    // 制造一次余额不足的转账
    await assertRevert(erc20.transfer(accounts[0], web3.utils.toWei('500000001'), { from: accounts[2] }));

    // 测试授权转账
    await erc20.approve(accounts[1], web3.utils.toWei('500000000'), { from: accounts[2] });
    let allow = await erc20.allowance(accounts[2], accounts[1]);
    assert.equal(web3.utils.fromWei(allow).toString(), '500000000');

    await erc20.transferFrom(accounts[2], accounts[4], web3.utils.toWei('250000000'), { from: accounts[1] })
    let b4 = await erc20.balanceOf(accounts[4]);
    assert.equal(web3.utils.fromWei(b4).toString(), '250000000');
    allow = await erc20.allowance(accounts[2], accounts[1]);
    assert.equal(web3.utils.fromWei(allow).toString(), '250000000');

    // 调整授权
    await erc20.increaseAllowance(accounts[1], web3.utils.toWei('250000000'), { from: accounts[2] });
    allow = await erc20.allowance(accounts[2], accounts[1]);
    assert.equal(web3.utils.fromWei(allow).toString(), '500000000');

    await erc20.decreaseAllowance(accounts[1], web3.utils.toWei('250000000'), { from: accounts[2] });
    allow = await erc20.allowance(accounts[2], accounts[1]);
    assert.equal(web3.utils.fromWei(allow).toString(), '250000000');

    // 尝试销毁accounts[0]里面资产，非minable禁止销毁和增发
    ret = await erc20.burn(accounts[2], web3.utils.toWei('250000000'), { from: accounts[1] });
    Events = ret.logs.find(e => e.event === 'Burn');
    assert.notEqual(Events, undefined);
    total = await erc20.totalSupply();
    assert.equal(web3.utils.fromWei(total).toString(), '750000000');
    b3 = await erc20.balanceOf(accounts[3]);
    assert.equal(web3.utils.fromWei(b3).toString(), '500000000');
  });
});
