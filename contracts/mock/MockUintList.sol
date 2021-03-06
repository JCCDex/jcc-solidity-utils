pragma solidity >=0.4.24;

import "../list/UintList.sol";

// 定义一个调用AddressList的合约
contract MockUintList {
  using UintList for UintList.uintMap;

  UintList.uintMap uints;

  function insert(uint256 _uint) public returns (bool) {
    return uints.insert(_uint);
  }

  function remove(uint256 _uint) public returns (bool) {
    return uints.remove(_uint);
  }

  function get(uint256 _idx) public view returns (uint256) {
    return uints.get(_idx);
  }

  function getList(uint256 from, uint256 _count)
    public
    view
    returns (uint256[] memory)
  {
    return uints.getList(from, _count);
  }

  function count() public view returns (uint256) {
    return uints.count();
  }
}
