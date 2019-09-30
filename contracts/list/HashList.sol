pragma solidity 0.4.24;

import "../math/SafeMath.sol";

/**
 * @dev 交易列表共通，处理交易列表hash数据，只能顺序增加且不重复
 */
library HashList {
  using SafeMath for uint256;

  struct hashMap
  {
    mapping(bytes32 => uint256) mapList;
    bytes32[] list;
  }

  function exist(hashMap storage self, bytes32 _hash) internal view returns(bool) {
    if(self.list.length == 0) return false;
    return (self.list[self.mapList[_hash]] == _hash);
  }

  /**
  @dev 增加新地址，重复的地址返回失败
   */
  function insert(hashMap storage self, bytes32 _hash) internal returns (bool){
    if (exist(self, _hash)) {
      return false;
    }

    self.mapList[_hash] = self.list.push(_hash).sub(1);

    return true;
  }

  /**
  @dev 删除地址，相应的下标索引数组自动缩减
   */
  function remove(hashMap storage self, bytes32 _hash) internal returns (bool){
    if (!exist(self, _hash)) {
      return false;
    }

    uint256 row2Del = self.mapList[_hash];
    bytes32 keyToMove = self.list[self.list.length.sub(1)];
    self.list[row2Del] = keyToMove;
    self.mapList[keyToMove] = row2Del;
    self.list.length = self.list.length.sub(1);

    return true;
  }

  function count(hashMap storage self) internal view returns (uint256){
    return self.list.length;
  }

  function get(hashMap storage self, uint256 index) internal view returns (bytes32) {
    require(index < self.list.length, "index must small than current count");
    return self.list[index];
  }

  /**
  @dev 从指定位置返回多条（不多于count）地址记录,如果不足则空缺
   */
  function getList(hashMap storage self, uint256 from, uint256 _count) internal view returns (bytes32[] memory){
    uint256 _idx = 0;
    require(_count > 0, "return number must bigger than 0");
    bytes32[] memory res = new bytes32[](_count);

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