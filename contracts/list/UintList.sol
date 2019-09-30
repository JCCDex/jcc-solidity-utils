pragma solidity 0.4.24;

import "../math/SafeMath.sol";

/**
 * @dev 无符号整型数列表共通，只能顺序增加且不重复
 */
library UintList {
  using SafeMath for uint256;

  struct uintMap
  {
    mapping(uint256 => uint256) mapList;
    uint256[] list;
  }

  function exist(uintMap storage self, uint256 _num) internal view returns(bool) {
    if(self.list.length == 0) return false;
    return (self.list[self.mapList[_num]] == _num);
  }

  /**
  @dev 增加新的数据，重复的数据返回失败
   */
  function insert(uintMap storage self, uint256 _num) internal returns (bool){
    if (exist(self, _num)) {
      return false;
    }

    self.mapList[_num] = self.list.push(_num).sub(1);

    return true;
  }

  /**
  @dev 删除无符号整型数，相应的下标索引数组自动缩减
   */
  function remove(uintMap storage self, uint256 _num) internal returns (bool){
    if (!exist(self, _num)) {
      return false;
    }

    uint256 row2Del = self.mapList[_num];
    uint256 keyToMove = self.list[self.list.length.sub(1)];
    self.list[row2Del] = keyToMove;
    self.mapList[keyToMove] = row2Del;
    self.list.length = self.list.length.sub(1);

    return true;
  }

  function count(uintMap storage self) internal view returns (uint256){
    return self.list.length;
  }

  function get(uintMap storage self, uint256 index) internal view returns (uint256) {
    require(index < self.list.length, "index must small than current count");
    return self.list[index];
  }

  /**
  @dev 从指定位置返回多条（不多于count）记录,如果不足则空缺，为避免该情况，应该先获取数据量后再决定参数
   */
  function getList(uintMap storage self, uint256 from, uint256 _count) internal view returns (uint256[] memory){
    uint256 _idx = 0;
    require(_count > 0, "return number must bigger than 0");
    uint256[] memory res = new uint256[](_count);

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