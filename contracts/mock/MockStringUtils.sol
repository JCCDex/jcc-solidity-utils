pragma solidity >=0.4.24;
pragma experimental ABIEncoderV2;

import "../utils/StringUtils.sol";

// 定义一个调用AddressList的合约
contract MockStringUtils {
  using StringUtils for string;
  using StringUtils for StringUtils.slice;

  function toSlice(string _str) public pure returns (StringUtils.slice memory) {
    return _str.toSlice();
  }

  function len(string _str) public pure returns (uint256) {
    return _str.toSlice().len();
  }

  function copy(string _str) public pure returns (StringUtils.slice memory) {
    return _str.toSlice().copy();
  }
}
