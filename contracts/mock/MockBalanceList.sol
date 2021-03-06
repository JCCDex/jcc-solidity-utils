pragma solidity >=0.4.24;
pragma experimental ABIEncoderV2;

import "../list/BalanceList.sol";

// 定义一个调用BalanceList的合约
contract MockBalanceList {
  using BalanceList for BalanceList.balanceMap;

  BalanceList.balanceMap _balance;

  function add(address _addr, uint256 _amount) public returns (uint256) {
    return _balance.add(_addr, _amount);
  }

  function sub(address _addr, uint256 _amount) public returns (uint256) {
    return _balance.sub(_addr, _amount);
  }

  function balance(address _addr) public view returns (uint256) {
    return _balance.balance(_addr);
  }

  function get(uint256 _idx) public view returns (BalanceList.element memory) {
    return _balance.get(_idx);
  }

  function getList(uint256 from, uint256 count)
    public
    view
    returns (BalanceList.element[] memory)
  {
    return _balance.getList(from, count);
  }

  function count() public view returns (uint256) {
    return _balance.count();
  }
}
