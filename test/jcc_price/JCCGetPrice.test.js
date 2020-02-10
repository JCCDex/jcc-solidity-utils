const JCCGetPrice = artifacts.require('JCCGetPrice');
const assertRevert = require('../helpers/assertRevert');

contract('JCCGetPrice', (accounts) => {
  let PriceTest;
  let _token = 'xrp';
  let _price = 0.278;

  it('set price by owner', async () => {
    PriceTest = await JCCGetPrice.new();
    var _h = web3.utils.toHex(_token);
    var _t = web3.utils.hexToBytes(_h);
    let { logs } = await PriceTest.setPrice(_t, web3.utils.toWei(_price + ''), { from: accounts[0] });
    let Events = logs.find(e => e.event === 'EnPrice');
    assert.notEqual(Events, undefined);
  });

  it('set price by not owner', async () => {
    var _h = web3.utils.toHex(_token);
    var _t = web3.utils.hexToBytes(_h);
    await assertRevert(PriceTest.setPrice(_t, web3.utils.toWei(0.3 + ''), { from: accounts[1] })); 
  });

  it('get price', async () => {
    var _h = web3.utils.toHex(_token);
    var _t = web3.utils.hexToBytes(_h);
    console.log(_h);
    let ret = await PriceTest.getPrice(_t);
    let s1 = web3.utils.fromWei(ret[1]).toString();
    let s2 = '' + _price;
    assert.equal(s1,s2);
  });
});
