pragma solidity 0.4.24;
pragma experimental ABIEncoderV2;

import "../utils/AddressUtils.sol";

// 定义一个调用AddressList的合约
contract MockAddressUtils {
  using AddressUtils for address;

  function isContract(address _addr) public view returns (bool) {
    return _addr.isContract();
  }

  // 使用toString，因为js重载导致无法正常执行
  function getString(address _addr) public pure returns (string memory) {
    return _addr.getString();
  }
  function fromString(string _str) public pure returns (address) {
    return address(0).fromString(_str);
  }
}
