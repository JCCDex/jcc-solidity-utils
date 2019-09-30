pragma solidity 0.4.24;

import "../math/SafeMath.sol";

/**
 * @dev 地址列表共通，处理地址列表，不重复，可统计，按照下标获取
 */
library AddressList {
  using SafeMath for uint256;

  struct addressMap
  {
    mapping(address => uint256) mapList;
    address[] list;
  }

  function exist(addressMap storage self, address _addr) internal view returns(bool) {
    if(self.list.length == 0) return false;
    return (self.list[self.mapList[_addr]] == _addr);
  }

  /**
  @dev 增加新地址，重复的地址返回失败
   */
  function insert(addressMap storage self, address _addr) internal returns (bool){
    if (exist(self, _addr)) {
      return false;
    }

    self.mapList[_addr] = self.list.push(_addr).sub(1);

    return true;
  }

  /**
  @dev 删除地址，相应的下标索引数组自动缩减
   */
  function remove(addressMap storage self, address _addr) internal returns (bool){
    if (!exist(self, _addr)) {
      return false;
    }

    uint256 row2Del = self.mapList[_addr];
    address keyToMove = self.list[self.list.length.sub(1)];
    self.list[row2Del] = keyToMove;
    self.mapList[keyToMove] = row2Del;
    self.list.length = self.list.length.sub(1);

    return true;
  }

  function count(addressMap storage self) internal view returns (uint256){
    return self.list.length;
  }

  function get(addressMap storage self, uint256 index) internal view returns (address){
    require(index < self.list.length, "index must small than current count");
    return self.list[index];
  }

  /**
  @dev 从指定位置返回多条（不多于count）地址记录,如果不足则空缺
   */
  function getList(addressMap storage self, uint256 from, uint256 _count) internal view returns (address[] memory){
    uint256 _idx = 0;
    require(_count > 0, "return number must bigger than 0");
    address[] memory res = new address[](_count);

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