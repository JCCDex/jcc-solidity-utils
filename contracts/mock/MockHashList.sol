pragma solidity 0.4.24;

import "../list/HashList.sol";

// 定义一个调用AddressList的合约
contract MockHashList {
  using HashList for HashList.hashMap;

  HashList.hashMap hashs;

  function insert(bytes32 _hash) public returns (bool) {
    return hashs.insert(_hash);
  }

  function remove(bytes32 _hash) public returns (bool) {
    return hashs.remove(_hash);
  }

  function get(uint256 _idx) public view returns (bytes32) {
    return hashs.get(_idx);
  }

  function getList(uint256 from, uint256 _count) public view returns (bytes32[] memory) {
    return hashs.getList(from, _count);
  }

  function count() public view returns (uint256) {
    return hashs.count();
  }
}
