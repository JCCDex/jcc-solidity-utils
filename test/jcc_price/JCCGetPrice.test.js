const JCCGetPrice = artifacts.require('JCCGetPrice');
//const assertRevert = require('../helpers/assertRevert');
//const zeroAccount = require('../helpers/zeroAccount');

contract('JCCGetPrice', (accounts) => {
  let PriceTest;
  let _token = 'xrp';
  let _price = 0.278;

  it('set price by owner', async () => {
    //assert.equal(1,1);
    PriceTest = await JCCGetPrice.new();
    //assert.equal(1,1);
    let { logs } = await PriceTest.setPrice(_token, _price, { from: accounts[0] });
    let Events = logs.find(e => e.event === 'EnPrice');
    assert.notEqual(Events, undefined);
  });

  // it('get price', async () => {
  //   let ret = await PriceTest.getPrice(_token);
  //   assert.equal(_price, ret);
  // });
});
