const AddressUtils = artifacts.require('MockAddressUtils');
const assertRevert = require('../helpers/assertRevert');
const zeroAccount = require('../helpers/zeroAccount');

contract('AddressUtils', (accounts) => {
  let addressUtils;

  beforeEach(async () => {
    addressUtils = await AddressUtils.new();
  });

  it('address uitils test', async () => {
    let ret = await addressUtils.isContract(accounts[1]);
    // console.log(JSON.stringify(ret), accounts[1]);
    assert.equal(ret, false);

    ret = await addressUtils.fromString("0xf17f52151EbEF6C7334FAD080c5704D77216b732");
    // console.log(ret, accounts[1]);
    assert.equal(ret.toLowerCase(), accounts[1].toLowerCase());

    ret = await addressUtils.toString1(accounts[1]);
    // console.log(ret, accounts[1]);
    assert.equal(ret.toLowerCase(), accounts[1].toLowerCase());
  });
});
