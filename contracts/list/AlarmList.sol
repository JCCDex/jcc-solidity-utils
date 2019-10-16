pragma solidity 0.4.24;

import "../math/SafeMath.sol";

/**
 * @dev 定时任务列表
 */
library AlarmList {
  using SafeMath for uint256;

  // 定时任务定义
  struct element
  {
    // 合约地址
    address contractAddr;
    // 索引id
    uint256 idx;
    // 类型：0:一次性, 1:周期性
    uint256 alarmType;
    // 起始时间
    uint256 begin;
    // 周期
    uint256 peroid;
  }
  struct alarmMap
  {
    mapping(address => uint256) mapList;
    element[] list;
  }

  function exist(alarmMap storage self, address _addr) internal view returns(bool) {
    if(self.list.length == 0) return false;
    return (self.list[self.mapList[_addr]].contractAddr == _addr);
  }

  /**
  @dev 增加新定时定义，重复的地址返回失败
   */
  function insert(alarmMap storage self, address _addr, uint256 _type, uint256 _begin, uint256 _peroid) internal returns (bool){
    if (exist(self, _addr)) {
      return false;
    }

    element memory e = element({contractAddr: _addr, idx: self.list.length, alarmType: _type, begin: _begin, peroid: _peroid});
    self.list.push(e);
    self.mapList[_addr] = e.idx;
    return true;
  }

  /**
  @dev 删除地址，相应的下标索引数组自动缩减
   */
  function remove(alarmMap storage self, address _addr) internal returns (bool){
    if (!exist(self, _addr)) {
      return false;
    }

    uint256 row2Del = self.mapList[_addr];
    element storage keyToMove = self.list[self.list.length.sub(1)];
    self.list[row2Del] = keyToMove;
    self.mapList[keyToMove.contractAddr] = row2Del;
    self.list.length = self.list.length.sub(1);

    return true;
  }

  function count(alarmMap storage self) internal view returns (uint256){
    return self.list.length;
  }

  function get(alarmMap storage self, uint256 index) internal view returns (AlarmList.element){
    require(index < self.list.length, "index must small than current count");
    return self.list[index];
  }

  /**
  @dev 从指定位置返回多条（不多于count）地址记录,如果不足则空缺
   */
  function getList(alarmMap storage self, uint256 from, uint256 _count) internal view returns (AlarmList.element[] memory){
    uint256 _idx = 0;
    require(_count > 0, "return number must bigger than 0");
    AlarmList.element[] memory res = new AlarmList.element[](_count);

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