pragma solidity 0.4.24;

import "../list/AddressList.sol";

// 定义一个调用AddressList的合约
contract MockAddressList {
  using AddressList for AddressList.addressMap;

  AddressList.addressMap planUsers;

  function insert(address _addr) public returns (bool) {
    return planUsers.insert(_addr);
  }

  function remove(address _addr) public returns (bool) {
    return planUsers.remove(_addr);
  }

  function get(uint256 _idx) public view returns (address) {
    return planUsers.get(_idx);
  }

  function getList(uint256 from, uint256 _count) public view returns (address[] memory) {
    return planUsers.getList(from, _count);
  }

  function count() public view returns (uint256) {
    return planUsers.count();
  }
}
