pragma solidity >=0.4.24;
pragma experimental ABIEncoderV2;

/**
对ERC20的一个包装，实现ERC20的合约很多，但是存在一些不合规的合约，
在转账完成后没有正确的返回一个布尔值表示成功或者失败。
SafeERC20通过对返回值的检测，补足返回值，尤其是在合约里操作ERC20时建议使用
 */
library SafeERC20 {
  function isContract(address addr) internal view {
    assembly {
      if iszero(extcodesize(addr)) {
        revert(0, 0)
      }
    }
  }

  function handleReturnData(address _erc20Addr, bytes memory _msg)
    internal
    returns (bool result)
  {
    uint256 msgSize = _msg.length;
    assembly {
      if iszero(
        call(gas(), _erc20Addr, 0, add(_msg, 0x20), msgSize, 0x00, 0x20)
      ) {
        revert(0, 0)
      }
      switch returndatasize()
        case 0 {
          // not a std erc20
          result := 1
        }
        case 32 {
          // std erc20
          returndatacopy(0, 0, 32)
          result := mload(0)
        }
        default {
          // anything else, should revert for safety
          revert(0, 0)
        }
    }
  }

  function safeTransfer(
    address _erc20Addr,
    address _to,
    uint256 _value
  ) internal returns (bool result) {
    // Must be a contract addr first!
    isContract(_erc20Addr);

    bytes memory _msg =
      abi.encodeWithSignature("transfer(address,uint256)", _to, _value);

    // handle returndata
    return handleReturnData(_erc20Addr, _msg);
  }

  function safeTransferFrom(
    address _erc20Addr,
    address _from,
    address _to,
    uint256 _value
  ) internal returns (bool result) {
    // Must be a contract addr first!
    isContract(_erc20Addr);

    // call return false when something wrong
    bytes memory _msg =
      abi.encodeWithSignature(
        "transferFrom(address,address,uint256)",
        _from,
        _to,
        _value
      );

    // handle returndata
    return handleReturnData(_erc20Addr, _msg);
  }
}
