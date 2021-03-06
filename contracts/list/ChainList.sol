pragma solidity >=0.4.24;

import "../math/SafeMath.sol";

/**
 * @dev 区块链列表
 */
library ChainList {
  using SafeMath for uint256;

  // 遵循BIP44
  struct element {
    // 索引id
    uint256 idx;
    // chain id
    uint256 id;
    string symbol;
  }
  struct chainMap {
    // chain id => index
    mapping(uint256 => uint256) mapId;
    // symbol hash => index
    mapping(bytes32 => uint256) mapSymbol;
    // data array
    element[] list;
  }

  function exist(chainMap storage self, uint256 _id)
    internal
    view
    returns (bool)
  {
    if (self.list.length == 0) return false;
    return (self.list[self.mapId[_id]].id == _id &&
      getStringLen(self.list[self.mapId[_id]].symbol) > 0);
  }

  function getStringLen(string _str) internal pure returns (uint256) {
    bytes memory b = bytes(_str);
    require(b.length <= 1024, "too large string make overflow risk");
    return b.length;
  }

  function getHash(string _symbol) internal pure returns (bytes32) {
    return keccak256(abi.encodePacked(_symbol));
  }

  /**
  @dev 增加新定时定义，重复的ID返回失败
   */
  function insert(
    chainMap storage self,
    uint256 _id,
    string _symbol
  ) internal returns (bool) {
    if (exist(self, _id)) {
      return false;
    }

    element memory e =
      element({idx: self.list.length, id: _id, symbol: _symbol});

    self.list.push(e);
    self.mapId[_id] = e.idx;
    self.mapSymbol[getHash(_symbol)] = e.idx;

    return true;
  }

  function remove(chainMap storage self, uint256 _id) internal returns (bool) {
    if (!exist(self, _id)) {
      return false;
    }

    uint256 row2Del = self.mapId[_id];
    element storage keyToMove = self.list[self.list.length.sub(1)];
    self.list[row2Del] = keyToMove;
    self.mapId[keyToMove.id] = row2Del;
    self.mapSymbol[getHash(keyToMove.symbol)] = row2Del;
    self.list.length = self.list.length.sub(1);

    return true;
  }

  function count(chainMap storage self) internal view returns (uint256) {
    return self.list.length;
  }

  function get(chainMap storage self, uint256 index)
    internal
    view
    returns (ChainList.element)
  {
    require(index < self.list.length, "index must small than current count");
    return self.list[index];
  }

  function getById(chainMap storage self, uint256 _id)
    internal
    view
    returns (ChainList.element)
  {
    require(exist(self, _id), "chain data must exist");
    return self.list[self.mapId[_id]];
  }

  function getBySymbol(chainMap storage self, string _symbol)
    internal
    view
    returns (ChainList.element)
  {
    ChainList.element storage e = self.list[self.mapSymbol[getHash(_symbol)]];
    // 因为删除增加操作，map对应的存储未动，要校验一次
    require(exist(self, e.id), "chain data must exist");
    return e;
  }

  /**
  @dev 从指定位置返回多条（不多于count）地址记录,如果不足则空缺
   */
  function getList(
    chainMap storage self,
    uint256 from,
    uint256 _count
  ) internal view returns (ChainList.element[] memory) {
    uint256 _idx = 0;
    require(_count > 0, "return number must bigger than 0");
    ChainList.element[] memory res = new ChainList.element[](_count);

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
