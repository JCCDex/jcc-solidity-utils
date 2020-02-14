/* eslint-disable indent */
/* eslint-disable semi */
/* eslint-disable no-undef */
const JCCTokenList = artifacts.require('JCCTokenList');
const assertRevert = require('../helpers/assertRevert');
const BigNumber = require('bignumber.js');

contract('TokenList', (accounts) => {
  /**
   * 模拟 abi.encodePacked()函数打包数据，有两种状况
   * 1. 调用智能合约的calldata,前8个字符（4字节）是函数签名
   * 2. 正常转账的备注，其实是一个bytes数组，数组需要有一个前导长度定义
   */
  function getIssuerHash(chainId, issuer) {
    let s = web3.utils.padLeft(BigNumber(chainId).toString(16), 64);

    let _issuer;
    let _prefix = '';
    if (issuer.startsWith("0x")) {
      _issuer = issuer.substring(2);
      _prefix = '3078';
    } else {
      _issuer = issuer;
    }
    let ret = '0x' + s + _prefix + web3.utils.toHex(_issuer).substring(2);
    let hash = web3.utils.sha3(ret)
    return hash;
  }


  let al;

  const ETH_CHAINID = 60;
  const MOAC_CHAINID = 314;
  const JINGTUM_CHAINID = 315;

  let tokens = {
    ETH: { id: 1, chainId: ETH_CHAINID, origin: '0x0', issuer: '/', symbol: 'ETH' },
    MOAC: { id: 2, chainId: MOAC_CHAINID, origin: '0x0', issuer: '/', symbol: 'MOAC' },
    SWTC: { id: 3, chainId: JINGTUM_CHAINID, origin: '0x0', issuer: '/', symbol: 'SWTC' },
    JCC: { id: 4, chainId: ETH_CHAINID, origin: '0x0', issuer: '0x9BD4810a407812042F938d2f69f673843301cfa6/', symbol: 'JCC' },
    JJCC: { id: 5, chainId: JINGTUM_CHAINID, origin: '0x0', issuer: 'jGa9J9TkqtBcUoHe2zqhVFFbgUVED6o9or/', symbol: 'JJCC' },
    MSJCC: { id: 6, chainId: MOAC_CHAINID, origin: '0x0', issuer: '0x599c1ff28d1ec95ed0b0aff1cf6829496db6b414/0xc905a87e84553b57b6dd822ff15955e7896523a9', symbol: 'MSJCC' },
    MJCC: { id: 7, chainId: MOAC_CHAINID, origin: '0x0', issuer: '0x599c1ff28d1ec95ed0b0aff1cf6829496db6b415/', symbol: 'MJCC' }
  };
  beforeEach(async () => {
    al = await JCCTokenList.new();
  });

  it('TokenList test', async () => {
    await al.insert(tokens.ETH.id, tokens.ETH.chainId, tokens.ETH.origin, tokens.ETH.issuer, tokens.ETH.symbol);
    await al.insert(tokens.MOAC.id, tokens.MOAC.chainId, tokens.MOAC.origin, tokens.MOAC.issuer, tokens.MOAC.symbol);
    await al.insert(tokens.SWTC.id, tokens.SWTC.chainId, tokens.SWTC.origin, tokens.SWTC.issuer, tokens.SWTC.symbol);

    let count = await al.count();
    assert.equal(count, 3);

    await assertRevert(al.insert(tokens.SWTC.id, tokens.SWTC.chainId, tokens.SWTC.origin, tokens.SWTC.issuer, tokens.SWTC.symbol));
    //编号不同，通证相同
    await assertRevert(al.insert(4, tokens.SWTC.chainId, tokens.SWTC.origin, tokens.SWTC.issuer, tokens.SWTC.symbol));
    await al.insert(tokens.JCC.id, tokens.JCC.chainId, tokens.JCC.origin, tokens.JCC.issuer, tokens.JCC.symbol);
    await al.insert(tokens.JJCC.id, tokens.JJCC.chainId, tokens.JJCC.origin, tokens.JJCC.issuer, tokens.JJCC.symbol);
    await al.insert(tokens.MSJCC.id, tokens.MSJCC.chainId, tokens.MSJCC.origin, tokens.MSJCC.issuer, tokens.MSJCC.symbol);
    count = await al.count();
    assert.equal(count, 6);

    // 当前数据顺序  [1,2,3,4,5,6] tokens map[0x0] = [1,2,3,4,5,6]
    await al.remove(1);
    count = await al.count();
    assert.equal(count, 5);

    // 当前数据顺序  [6,2,3,4,5] tokens map[0x0] = [6,2,3,4,5]
    await al.insert(tokens.MJCC.id, tokens.MJCC.chainId, tokens.MJCC.origin, tokens.MJCC.issuer, tokens.MJCC.symbol);
    // 当前数据顺序  [6,2,3,4,5,7]
    let data = await al.get(0)
    assert.equal(6, data.id);

    await al.insert(tokens.ETH.id, tokens.ETH.chainId, tokens.ETH.origin, tokens.ETH.issuer, tokens.ETH.symbol);
    // 当前数据顺序  [6,2,3,4,5,7,1]
    // tokenList = await al.getTokenList('0x0');
    // console.log(tokenList);

    data = await al.get(6)
    assert.equal(1, data.id);

    data = await al.getById(3)
    assert.equal('SWTC', data.symbol);

    data = await al.getBySymbol(MOAC_CHAINID, 'MOAC')
    assert.equal(2, data.id);

    data = await al.getByIssuer(MOAC_CHAINID, tokens.MSJCC.issuer)
    assert.equal('MSJCC', data.symbol);

    await al.remove(5);
    await assertRevert(al.getBySymbol(JINGTUM_CHAINID, 'JJCC'));

    let all = await al.getList(0, 6);
    assert.equal(all.length, 6);
  });

  it('TokenList test with different origin for token cross chain', async () => {
    let tokenList;

    // let ret = await al.getIssuer(tokens.JCC.chainId, tokens.JCC.issuer);
    // console.log(ret);

    // 计算origin
    tokens.JJCC.origin = getIssuerHash(tokens.JCC.chainId, tokens.JCC.issuer);
    tokens.MSJCC.origin = getIssuerHash(tokens.JCC.chainId, tokens.JCC.issuer);
    tokens.MJCC.origin = getIssuerHash(tokens.JCC.chainId, tokens.JCC.issuer);

    await al.insert(tokens.ETH.id, tokens.ETH.chainId, tokens.ETH.origin, tokens.ETH.issuer, tokens.ETH.symbol);
    await al.insert(tokens.MOAC.id, tokens.MOAC.chainId, tokens.MOAC.origin, tokens.MOAC.issuer, tokens.MOAC.symbol);
    await al.insert(tokens.SWTC.id, tokens.SWTC.chainId, tokens.SWTC.origin, tokens.SWTC.issuer, tokens.SWTC.symbol);

    let count = await al.count();
    assert.equal(count, 3);

    await assertRevert(al.insert(tokens.SWTC.id, tokens.SWTC.chainId, tokens.SWTC.origin, tokens.SWTC.issuer, tokens.SWTC.symbol));
    //编号不同，通证相同
    await assertRevert(al.insert(4, tokens.SWTC.chainId, tokens.SWTC.origin, tokens.SWTC.issuer, tokens.SWTC.symbol));

    await al.insert(tokens.JCC.id, tokens.JCC.chainId, tokens.JCC.origin, tokens.JCC.issuer, tokens.JCC.symbol);

    await al.insert(tokens.JJCC.id, tokens.JJCC.chainId, tokens.JJCC.origin, tokens.JJCC.issuer, tokens.JJCC.symbol);

    await al.insert(tokens.MSJCC.id, tokens.MSJCC.chainId, tokens.MSJCC.origin, tokens.MSJCC.issuer, tokens.MSJCC.symbol);

    count = await al.count();
    assert.equal(count, 6);

    // 当前数据顺序  [1,2,3,4,5,6] tokens map[0x0] = [1,2,3,4,5,6]
    await al.remove(1);
    count = await al.count();
    assert.equal(count, 5);

    // 当前数据顺序  [6,2,3,4,5] tokens
    await al.insert(tokens.MJCC.id, tokens.MJCC.chainId, tokens.MJCC.origin, tokens.MJCC.issuer, tokens.MJCC.symbol);
    // 当前数据顺序  [6,2,3,4,5,7]
    let data = await al.get(0)
    assert.equal(6, data.id);

    await al.insert(tokens.ETH.id, tokens.ETH.chainId, tokens.ETH.origin, tokens.ETH.issuer, tokens.ETH.symbol);
    // 当前数据顺序  [6,2,3,4,5,7,1]

    data = await al.get(6)
    assert.equal(1, data.id);

    data = await al.getById(3)
    assert.equal('SWTC', data.symbol);

    data = await al.getBySymbol(MOAC_CHAINID, 'MOAC')
    assert.equal(2, data.id);

    data = await al.getByIssuer(MOAC_CHAINID, tokens.MSJCC.issuer)
    assert.equal('MSJCC', data.symbol);

    tokenList = await al.getTokenList(tokens.JJCC.origin);
    assert.equal(tokenList.length, 4);

    await al.remove(5);
    await assertRevert(al.getBySymbol(JINGTUM_CHAINID, 'JJCC'));

    let all = await al.getList(0, 6);
    assert.equal(all.length, 6);

    tokenList = await al.getTokenList(tokens.JJCC.origin);
    assert.equal(tokenList.length, 3);
  });
});
