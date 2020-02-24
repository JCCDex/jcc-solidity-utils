pragma solidity 0.4.24;
pragma experimental ABIEncoderV2;

import "../list/TransferList.sol";

// 定义一个调用TransferList的合约
contract MockTransferList {
  using TransferList for TransferList.transferMap;

  TransferList.transferMap transfers;

  function insert(
    address _from,
    bytes32 _tokenHash,
    uint256 _amount,
    string _to
  ) public returns (bytes32) {
    return transfers.insert(_from, _tokenHash, _amount, _to);
  }

  function getByIdx(uint256 _idx) public view returns (TransferList.element) {
    return transfers.getByIdx(_idx);
  }

  function getByHash(bytes32 _hash) public view returns (TransferList.element) {
    return transfers.getByHash(_hash);
  }

  function getList(uint256 from, uint256 _count)
    public
    view
    returns (TransferList.element[] memory)
  {
    return transfers.getList(from, _count);
  }

  function count() public view returns (uint256) {
    return transfers.count();
  }
}
