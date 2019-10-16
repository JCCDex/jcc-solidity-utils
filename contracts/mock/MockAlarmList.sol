pragma solidity 0.4.24;
pragma experimental ABIEncoderV2;

import "../list/AlarmList.sol";

// 定义一个调用AddressList的合约
contract MockAlarmList {
  using AlarmList for AlarmList.alarmMap;

  AlarmList.alarmMap tasks;

  function insert(address _addr, address _creator, uint256 _type, uint256 _begin, uint256 _peroid) public returns (bool) {
    return tasks.insert(_addr, _creator, _type, _begin, _peroid);
  }

  function remove(address _addr) public returns (bool) {
    return tasks.remove(_addr);
  }

  function get(uint256 _idx) public view returns (AlarmList.element) {
    return tasks.get(_idx);
  }

  function getByAddr(address _addr) public view returns (AlarmList.element) {
    return tasks.getByAddr(_addr);
  }

  function getList(uint256 from, uint256 _count) public view returns (AlarmList.element[] memory) {
    return tasks.getList(from, _count);
  }

  function count() public view returns (uint256) {
    return tasks.count();
  }
}
