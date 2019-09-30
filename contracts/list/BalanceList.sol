pragma solidity 0.4.24;

import "../math/SafeMath.sol";

/**
 * @dev 资产列表共通，除资产负债之外提供一个账目清单数组，便于统计和查找.
 */
library BalanceList {
  using SafeMath for uint256;

  struct element
  {
    address addr;
    uint256 idx;
    uint256 balance;
  }
  struct balanceMap
  {
    mapping(address => uint256) mapList;
    element[] list;
  }

  function exist(balanceMap storage self, address _addr) internal view returns(bool) {
    if(self.list.length == 0) return false;
    return (self.list[self.mapList[_addr]].addr == _addr);
  }

  function insert(balanceMap storage self, address _addr, uint256 _amount) internal returns (bool) {
    element memory e = element({addr: _addr, idx: self.list.length, balance: _amount});
    self.list.push(e);
    self.mapList[_addr] = e.idx;
    return true;
  }

  function remove(balanceMap storage self, address _addr) internal returns (bool) {
    if (!exist(self, _addr)) {
      return false;
    }
    if (self.list[self.mapList[_addr]].balance > 0) {
      return false;
    }

    uint256 row2Del = self.mapList[_addr];
    element storage keyToMove = self.list[self.list.length.sub(1)];
    self.list[row2Del] = keyToMove;
    self.mapList[keyToMove.addr] = row2Del;
    self.list.length = self.list.length.sub(1);

    return true;
  }

  function add(balanceMap storage self, address _addr, uint256 _amount) internal returns (uint256){
    // 对于已经存在的数据更新状态即可
    if (exist(self, _addr)) {
      self.list[self.mapList[_addr]].balance = self.list[self.mapList[_addr]].balance.add(_amount);
    }else{
      // 新建数据
      require(insert(self, _addr, _amount), "insert data fail");
    }

    return self.list[self.mapList[_addr]].balance;
  }

  function sub(balanceMap storage self, address _addr, uint256 _amount) internal returns (uint256) {
    require(exist(self, _addr), "can not sub no exist element");

    self.list[self.mapList[_addr]].balance = self.list[self.mapList[_addr]].balance.sub(_amount);

    if (self.list[self.mapList[_addr]].balance == 0) {
      require(remove(self, _addr), "remove data fail");
      return 0;
    }

    return self.list[self.mapList[_addr]].balance;
  }

  function count(balanceMap storage self) internal view returns (uint256){
    return self.list.length;
  }

  function balance(balanceMap storage self, address _addr) internal view returns (uint256){
    return exist(self, _addr) ? self.list[self.mapList[_addr]].balance : 0;
  }

  function get(balanceMap storage self, uint256 index) internal view returns (element memory){
    require(index < self.list.length, "index must small than current count");

    return self.list[index];
  }

  // 获取指定下标范围的数据，本函数可以用于分页查询
  function getList(balanceMap storage self, uint256 from, uint256 _count) internal view returns (element[] memory){
    require(_count > 0, "count number must bigger than 0");

    uint256 _idx = 0;
    element[] memory res = new element[](_count);

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