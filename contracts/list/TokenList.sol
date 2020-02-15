pragma solidity 0.4.24;

import "../math/SafeMath.sol";

/**
 * @dev 通证列表处理
 */
library TokenList {
  using SafeMath for uint256;

  // 通证定义
  struct element {
    // 索引
    uint256 idx;
    // 不重复的编号
    uint256 id;
    // 定义来自JCCChainList
    uint256 chainId;
    // origin token chainid + issuer hash
    // 如果是原生通证为0,如果是映射通证，则填写原生通证的 chainid+issuer hash
    bytes32 origin;
    /**
      所有链的原生通证默认标记不填写，除非另有规定(例如:EOS本身是一个合约)
      issuer格式: 合约地址/合约地址
      ETH类的通证通过合约地址区分，原生通证表示为 "/"
      SWTC类的通证定义由"issuer/"来表示地址，issuer为空表示原生通证
      MOAC应用链通过 "主链via地址/应用链合约"来表示issuer
      在同一条链上，不许重复
     */
    string issuer;
    // 简称,同一条链不重复
    string symbol;
  }

  struct tokenMap {
    // token id => index
    mapping(uint256 => uint256) mapId;
    // chainId+symbol hash => index
    mapping(bytes32 => uint256) mapSymbol;
    // chainId+issuer hash => index
    mapping(bytes32 => uint256) mapIssuer;
    // origin token mapping chainId+issuer hash => token id array
    mapping(bytes32 => uint256[]) mapToken;
    // data array
    element[] list;
  }

  function existId(tokenMap storage self, uint256 _id)
    internal
    view
    returns (bool)
  {
    if (self.list.length == 0) return false;
    return (self.list[self.mapId[_id]].id == _id &&
      getStringLen(self.list[self.mapId[_id]].symbol) > 0);
  }

  function existSymbol(tokenMap storage self, bytes32 _symbolHash)
    internal
    view
    returns (bool)
  {
    if (self.list.length == 0) return false;
    element storage e = self.list[self.mapSymbol[_symbolHash]];
    return (getSymbolHash(e.chainId, e.symbol) == _symbolHash);
  }

  function existIssuer(tokenMap storage self, bytes32 _issuerHash)
    internal
    view
    returns (bool)
  {
    if (self.list.length == 0) return false;
    element storage e = self.list[self.mapIssuer[_issuerHash]];
    return (getIssuerHash(e.chainId, e.issuer) == _issuerHash);
  }

  // 检查映射数组有无重复
  function existToken(tokenMap storage self, bytes32 _origin, uint256 _id)
    internal
    view
    returns (bool, uint256)
  {
    if (self.list.length == 0) return (false, 0);

    uint256[] storage _arr = self.mapToken[_origin];

    for (uint256 i = 0; i < _arr.length; i++) {
      if (_arr[i] == _id) {
        return (true, i);
      }
    }

    return (false, 0);
  }

  // 增加映射通证数组成员
  function insertToken(tokenMap storage self, bytes32 _issuerHash, uint256 _idx)
    internal
    returns (bool)
  {
    bool _exist;
    uint256 _originIdx;
    element storage e = self.list[_idx];
    bytes32 _origin = e.origin == 0x0 ? _issuerHash : e.origin;

    (_exist, _originIdx) = existToken(self, _origin, e.id);
    if (_exist) {
      return false;
    }

    self.mapToken[_origin].push(e.id);

    return true;
  }

  // 删除映射通证数组成员
  function removeToken(tokenMap storage self, uint256 _idx)
    internal
    returns (bool)
  {
    element storage e = self.list[_idx];
    bool isOrigin = e.origin == 0x0;
    bytes32 _issuerHash = isOrigin
      ? getIssuerHash(e.chainId, e.issuer)
      : e.origin;

    bool _exist;
    uint256 row2Del;

    (_exist, row2Del) = existToken(self, _issuerHash, e.id);
    if (!_exist) {
      return false;
    }

    uint256[] storage _arr = self.mapToken[_issuerHash];
    // 如果是原生通证必须映射通证先删除
    if (isOrigin && _arr.length > 1) {
      return false;
    }

    uint256 keyToMove = _arr[_arr.length.sub(1)];

    _arr[row2Del] = keyToMove;
    _arr.length = _arr.length.sub(1);

    return true;
  }

  function getStringLen(string _str) internal pure returns (uint256) {
    bytes memory b = bytes(_str);
    require(b.length <= 1024, "too large string make overflow risk");
    return b.length;
  }

  function getSymbolHash(uint256 _chainId, string _symbol)
    internal
    pure
    returns (bytes32)
  {
    return keccak256(abi.encodePacked(_chainId, _symbol));
  }

  function getIssuerHash(uint256 _chainId, string _issuer)
    internal
    pure
    returns (bytes32)
  {
    return keccak256(abi.encodePacked(_chainId, _issuer));
  }

  /**
  @dev 增加新定时定义，重复的ID返回失败
   */
  function insert(
    tokenMap storage self,
    uint256 _id,
    uint256 _chainId,
    bytes32 _origin,
    string _issuer,
    string _symbol
  ) internal returns (bool) {
    if (existId(self, _id)) {
      return false;
    }

    bytes32 _symbolHash = getSymbolHash(_chainId, _symbol);
    bytes32 _issuerHash = getIssuerHash(_chainId, _issuer);

    if (existSymbol(self, _symbolHash) || existIssuer(self, _issuerHash)) {
      return false;
    }

    //映射的原始通证没有登记
    if (_origin != 0x0 && !existIssuer(self, _origin)) {
      return false;
    }

    element memory e = element({
      idx: self.list.length,
      id: _id,
      chainId: _chainId,
      origin: _origin,
      issuer: _issuer,
      symbol: _symbol
    });

    self.list.push(e);
    self.mapId[_id] = e.idx;
    self.mapSymbol[_symbolHash] = e.idx;
    self.mapIssuer[_issuerHash] = e.idx;

    // 处理映射通证列表 原生通证排第一个
    if (!insertToken(self, _issuerHash, e.idx)) {
      return false;
    }

    return true;
  }

  function remove(tokenMap storage self, uint256 _id) internal returns (bool) {
    if (!existId(self, _id)) {
      return false;
    }

    uint256 row2Del = self.mapId[_id];

    element storage keyToMove = self.list[self.list.length.sub(1)];

    if (!removeToken(self, row2Del)) {
      return false;
    }

    self.list[row2Del] = keyToMove;
    self.mapId[keyToMove.id] = row2Del;
    bytes32 _symbolHash = getSymbolHash(keyToMove.chainId, keyToMove.symbol);
    bytes32 _issuerHash = getIssuerHash(keyToMove.chainId, keyToMove.issuer);
    self.mapSymbol[_symbolHash] = row2Del;
    self.mapIssuer[_issuerHash] = row2Del;
    self.list.length = self.list.length.sub(1);

    return true;
  }

  function count(tokenMap storage self) internal view returns (uint256) {
    return self.list.length;
  }

  function get(tokenMap storage self, uint256 index)
    internal
    view
    returns (TokenList.element)
  {
    require(index < self.list.length, "index must small than current count");
    return self.list[index];
  }

  function getById(tokenMap storage self, uint256 _id)
    internal
    view
    returns (TokenList.element)
  {
    require(existId(self, _id), "token data must be exist");
    return self.list[self.mapId[_id]];
  }

  function getBySymbol(tokenMap storage self, uint256 _chainId, string _symbol)
    internal
    view
    returns (TokenList.element)
  {
    bytes32 _symbolHash = getSymbolHash(_chainId, _symbol);
    require(existSymbol(self, _symbolHash), "symbol data must be exist");
    return self.list[self.mapSymbol[_symbolHash]];
  }

  function getByIssuer(tokenMap storage self, uint256 _chainId, string _issuer)
    internal
    view
    returns (TokenList.element)
  {
    bytes32 _issuerHash = getSymbolHash(_chainId, _issuer);
    require(existIssuer(self, _issuerHash), "issuer data must be exist");
    return self.list[self.mapIssuer[_issuerHash]];
  }

  /**
   获取通证跨链映射表
   */
  function getCrossList(tokenMap storage self, bytes32 _origin)
    internal
    view
    returns (TokenList.element[])
  {
    require(existIssuer(self, _origin), "origin data must be exist");

    uint256[] storage _arr = self.mapToken[_origin];
    require(_arr.length > 0, "origin list have data");

    TokenList.element[] memory res = new TokenList.element[](_arr.length);

    for (uint256 i = 0; i < _arr.length; i++) {
      res[i] = self.list[self.mapId[_arr[i]]];
    }

    return res;
  }

  /**
  @dev 从指定位置返回多条（不多于count）地址记录,如果不足则空缺
   */
  function getList(tokenMap storage self, uint256 from, uint256 _count)
    internal
    view
    returns (TokenList.element[] memory)
  {
    uint256 _idx = 0;
    require(_count > 0, "return number must bigger than 0");
    TokenList.element[] memory res = new TokenList.element[](_count);

    for (uint256 i = from; i < self.list.length; i++) {
      if (_idx == _count) {
        break;
      }

      res[_idx] = self.list[i];
      _idx = _idx.add(1);
    }

    return res;
  }
}
