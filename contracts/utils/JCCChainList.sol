pragma solidity 0.4.24;
pragma experimental ABIEncoderV2;

import "../list/ChainList.sol";
import "../owner/Administrative.sol";

// 定义一个调用AddressList的合约
contract JCCChainList is Administrative {
  using ChainList for ChainList.chainMap;

  event Add(uint256 indexed chainId);
  event Remove(uint256 indexed chainId);

  ChainList.chainMap chains;

  constructor() public Administrative() {}

  function insert(uint256 _id, string _symbol) public returns (bool) {
    require(chains.insert(_id, _symbol), "add chain success");
    emit Add(_id);
    return true;
  }

  function remove(uint256 _id) public returns (bool) {
    require(chains.remove(_id), "remove chain success");
    emit Remove(_id);
    return true;
  }

  function get(uint256 _idx) public view returns (ChainList.element) {
    return chains.get(_idx);
  }

  function getById(uint256 _id) public view returns (ChainList.element) {
    return chains.getById(_id);
  }

  function getBySymbol(string _symbol) public view returns (ChainList.element) {
    return chains.getBySymbol(_symbol);
  }

  function getList(uint256 from, uint256 _count)
    public
    view
    returns (ChainList.element[] memory)
  {
    return chains.getList(from, _count);
  }

  function count() public view returns (uint256) {
    return chains.count();
  }
}
