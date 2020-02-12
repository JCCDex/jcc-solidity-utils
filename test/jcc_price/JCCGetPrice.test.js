const JCCGetPrice = artifacts.require('JCCGetPrice');
const assertRevert = require('../helpers/assertRevert');

contract('JCCGetPrice', (accounts) => {
  let PriceTest;
  let _token = 'xrpusdt';
  let _price = 0.278;

  it('set price by owner', async () => {
    PriceTest = await JCCGetPrice.new();
    let { logs } = await PriceTest.setPrice(_token, web3.utils.toWei(_price + ''), { from: accounts[0] });
    let Events = logs.find(e => e.event === 'EnPrice');
    assert.notEqual(Events, undefined);
  });

  it('set price by not owner', async () => {
    await assertRevert(PriceTest.setPrice(_token, web3.utils.toWei(0.3 + ''), { from: accounts[1] })); 
  });

  it('get price', async () => {
    let ret = await PriceTest.getPrice(_token);
    let s1 = web3.utils.fromWei(ret[1]).toString();
    let s2 = '' + _price;
    assert.equal(s1,s2);
  });

  it('get price, token not exit', async () => {
    let ret = await PriceTest.getPrice('ethusdt');
    let s1 = web3.utils.fromWei(ret[1]).toString();
    let s2 = '' + 0;
    assert.equal(s1,s2);
  });
});
