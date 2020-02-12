/* eslint-disable indent */
/* eslint-disable semi */
/* eslint-disable no-undef */
const JCCTokenList = artifacts.require('JCCTokenList');
const assertRevert = require('../helpers/assertRevert');

contract('TokenList', (accounts) => {
  let al;

  const ETH_CHAINID = 60;
  const MOAC_CHAINID = 314;
  const JINGTUM_CHAINID = 315;

  beforeEach(async () => {
    al = await JCCTokenList.new();
  });

  it('TokenList test', async () => {
    await al.insert(1, ETH_CHAINID, '/', 'ETH');
    await al.insert(2, MOAC_CHAINID, '/', 'MOAC');
    await al.insert(3, JINGTUM_CHAINID, '/', 'SWTC');

    let count = await al.count();
    assert.equal(count, 3);

    await assertRevert(al.insert(3, JINGTUM_CHAINID, '/', 'SWTC'));
    await assertRevert(al.insert(4, JINGTUM_CHAINID, '/', 'SWTC'));
    await al.insert(4, ETH_CHAINID, '0x9BD4810a407812042F938d2f69f673843301cfa6/', 'JCC');
    await al.insert(5, JINGTUM_CHAINID, 'jGa9J9TkqtBcUoHe2zqhVFFbgUVED6o9or/', 'JJCC');
    await al.insert(6, MOAC_CHAINID, '0x599c1ff28d1ec95ed0b0aff1cf6829496db6b414/0xc905a87e84553b57b6dd822ff15955e7896523a9', 'MSJCC');
    count = await al.count();
    assert.equal(count, 6);

    // 当前数据顺序  [1,2,3,4,5,6]
    await al.remove(1);
    count = await al.count();
    assert.equal(count, 5);

    // 当前数据顺序  [6,2,3,4,5]
    await al.insert(7, MOAC_CHAINID, '0x599c1ff28d1ec95ed0b0aff1cf6829496db6b415/', 'MJCC');
    // 当前数据顺序  [6,2,3,4,5,7]
    let data = await al.get(0)
    assert.equal(6, data.id);

    await al.insert(1, ETH_CHAINID, '/', 'ETH');
    // 当前数据顺序  [6,2,3,4,5,7,1]
    data = await al.get(6)
    assert.equal(1, data.id);

    data = await al.getById(3)
    assert.equal('SWTC', data.symbol);

    data = await al.getBySymbol(MOAC_CHAINID, 'MOAC')
    assert.equal(2, data.id);

    data = await al.getByIssuer(MOAC_CHAINID, '0x599c1ff28d1ec95ed0b0aff1cf6829496db6b414/0xc905a87e84553b57b6dd822ff15955e7896523a9')
    assert.equal('MSJCC', data.symbol);

    await al.remove(5);
    await assertRevert(al.getBySymbol(JINGTUM_CHAINID, 'JJCC'));

    let all = await al.getList(0, 6);
    assert.equal(all.length, 6);
  });
});
