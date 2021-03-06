pragma solidity >=0.4.24;

/**
 * @dev Utility library of inline functions on addresses.
 */
library AddressUtils {
  /**
   * @dev Returns whether the target address is a contract.
   * @param _addr Address to check.
   */
  function isContract(address _addr) internal view returns (bool) {
    uint256 size;

    /**
     * XXX Currently there is no better way to check if there is a contract in an address than to
     * check the size of the code at that address.
     * See https://ethereum.stackexchange.com/a/14016/36603 for more details about how this works.
     * TODO: Check this again before the Serenity release, because all addresses will be
     * contracts then.
     */
    assembly {
      size := extcodesize(_addr)
    } // solium-disable-line security/no-inline-assembly
    return size > 0;
  }

  function isZeroAddress(address _addr) internal pure returns (bool) {
    return _addr == address(0);
  }

  // 使用toString，因为js重载导致无法正常执行
  function getString(address _addr) internal pure returns (string memory) {
    bytes32 value = bytes32(uint256(_addr));
    bytes memory alphabet = "0123456789abcdef";

    bytes memory str = new bytes(42);
    str[0] = "0";
    str[1] = "x";
    for (uint256 i = 0; i < 20; i++) {
      str[2 + i * 2] = alphabet[uint256(uint8(value[i + 12] >> 4))];
      str[3 + i * 2] = alphabet[uint256(uint8(value[i + 12] & 0x0f))];
    }

    return string(str);
  }

  function fromString(address _addr, string memory _str)
    internal
    pure
    returns (address)
  {
    bytes memory b = bytes(_str);

    uint256 result = 0;
    for (uint256 i = 0; i < b.length; i++) {
      uint256 c = uint256(uint8(b[i]));
      if (c >= 48 && c <= 57) {
        result = result * 16 + (c - 48);
      }
      if (c >= 65 && c <= 90) {
        result = result * 16 + (c - 55);
      }
      if (c >= 97 && c <= 122) {
        result = result * 16 + (c - 87);
      }
    }

    return address(result);
  }
}
