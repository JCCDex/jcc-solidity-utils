const StringUtils = artifacts.require('MockStringUtils');
const assertRevert = require('../helpers/assertRevert');
const zeroAccount = require('../helpers/zeroAccount');

contract('StringUtils', (accounts) => {
  let stringUtils;

  beforeEach(async () => {
    stringUtils = await StringUtils.new();
  });

  it('test string slice', async () => {
    let ret = await stringUtils.toSlice("");
    assert.equal(ret._len, '0');

    ret = await stringUtils.toSlice("Hello, world!");
    assert.equal(ret._len, '13');
  });

  it('test string len', async () => {
    let ret = await stringUtils.len("");
    assert.equal(ret.toString(), '0');

    ret = await stringUtils.len("こんにちは");
    assert.equal(ret.toString(), '5');
  });

  it('test string copy', async () => {
    let str1 = "こんにちは";
    let ret1 = await stringUtils.toSlice(str1);
    let ret2 = await stringUtils.copy(str1);
    assert.equal(ret1._len, ret2._len);
  });
});
