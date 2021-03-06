pragma solidity >=0.4.24;

import "../math/SafeMath.sol";

/**
 * @dev 通证列表处理
 */
library TransferList {
  using SafeMath for uint256;

  // 通证定义
  struct element {
    // 发起地址
    address from;
    // chainid+issuer计算的hash, chainid遵循BIP44,issuer遵守TokenList中规定
    bytes32 tokenHash;
    // 数量，ERC20需要注意decimals
    uint256 amount;
    // 在数组中的索引
    uint256 idx;
    // 目的地址
    string to;
  }

  struct transferMap {
    // element hash => index
    mapping(bytes32 => uint256) map;
    // data array 单向增加
    element[] list;
  }

  function getHash(element e) internal pure returns (bytes32) {
    return
      keccak256(abi.encodePacked(e.from, e.tokenHash, e.amount, e.idx, e.to));
  }

  function existByIdx(transferMap storage self, uint256 _idx)
    internal
    view
    returns (bool)
  {
    if (_idx >= self.list.length) return false;
    return true;
  }

  function existByHash(transferMap storage self, bytes32 _hash)
    internal
    view
    returns (bool)
  {
    /**
    如果没有这个长度判断，在第一次操作时会导致invalid opcode
     */
    if (self.list.length == 0) return false;
    element storage e = self.list[self.map[_hash]];
    return _hash == getHash(e);
  }

  // 增加跨链转账指令内容
  function insert(
    transferMap storage self,
    address _from,
    bytes32 _tokenHash,
    uint256 _amount,
    string _to
  ) internal returns (bytes32) {
    element memory e =
      element({
        from: _from,
        tokenHash: _tokenHash,
        amount: _amount,
        idx: self.list.length,
        to: _to
      });

    bytes32 _hash = getHash(e);
    require(!existByHash(self, _hash), "same transfer data exist");

    self.list.push(e);
    self.map[_hash] = e.idx;

    return _hash;
  }

  function count(transferMap storage self) internal view returns (uint256) {
    return self.list.length;
  }

  function getByIdx(transferMap storage self, uint256 _idx)
    internal
    view
    returns (TransferList.element)
  {
    require(existByIdx(self, _idx), "index must small than current count");
    return self.list[_idx];
  }

  function getByHash(transferMap storage self, bytes32 _hash)
    internal
    view
    returns (TransferList.element)
  {
    require(existByHash(self, _hash), "hash does not exist");
    return self.list[self.map[_hash]];
  }

  /**
  @dev 从指定位置返回多条（不多于count）地址记录,如果不足则空缺
   */
  function getList(
    transferMap storage self,
    uint256 from,
    uint256 _count
  ) internal view returns (TransferList.element[] memory) {
    uint256 _idx = 0;
    require(from >= self.list.length, "from must small than count");
    require(_count > 0, "return number must bigger than 0");

    TransferList.element[] memory res = new TransferList.element[](_count);

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
