pragma solidity 0.4.24;
pragma experimental ABIEncoderV2;

import "../list/CommandList.sol";

// 定义一个调用CommandList的合约
contract MockCommandList {
  using CommandList for CommandList.commandMap;

  CommandList.commandMap commands;

  function insert(
    uint256 _fromChain,
    uint256 _toChain,
    uint256 _verbs,
    bytes32 _payloadHash
  ) public returns (uint256) {
    return
      commands.insert(msg.sender, _fromChain, _toChain, _verbs, _payloadHash);
  }

  function lock(uint256 _idx) public returns (bool) {
    return commands.lock(msg.sender, _idx);
  }
  function cancel(uint256 _idx) public returns (bool) {
    return commands.cancel(msg.sender, _idx);
  }
  function complete(uint256 _idx) public returns (bool) {
    return commands.complete(msg.sender, _idx);
  }
  function count() public view returns (uint256) {
    return commands.count();
  }
  function countWaiting() public view returns (uint256) {
    return commands.countWaiting();
  }
  function countLocking() public view returns (uint256) {
    return commands.countLocking();
  }
  function countCanceled() public view returns (uint256) {
    return commands.countCanceled();
  }
  function countCompleted() public view returns (uint256) {
    return commands.countCompleted();
  }

  function countBySubmitter(address _submitter) public view returns (uint256) {
    return commands.countBySubmitter(_submitter);
  }

  function countByAgent(address _agent) public view returns (uint256) {
    return commands.countByAgent(_agent);
  }

  function getByIdx(uint256 _idx) public view returns (CommandList.element) {
    return commands.getByIdx(_idx);
  }

  function getIdxBySubmitter(address _submitter)
    public
    view
    returns (uint256[])
  {
    return commands.getIdxBySubmitter(_submitter);
  }

  function getIdxByAgent(address _agent) public view returns (uint256[]) {
    return commands.getIdxByAgent(_agent);
  }
  function getWaitingIdx() public view returns (uint256[]) {
    return commands.getWaitingIdx();
  }
  function getLockingIdx() public view returns (uint256[]) {
    return commands.getLockingIdx();
  }

  function getBySubmitter(address _submitter, uint256 _from, uint256 _count)
    public
    view
    returns (CommandList.element[] memory)
  {
    return commands.getBySubmitter(_submitter, _from, _count);
  }

  function getByAgent(address _agent, uint256 _from, uint256 _count)
    public
    view
    returns (CommandList.element[] memory)
  {
    return commands.getByAgent(_agent, _from, _count);
  }

  function getByCanceled(uint256 _from, uint256 _count)
    public
    view
    returns (CommandList.element[] memory)
  {
    return commands.getByCanceled(_from, _count);
  }

  function getByCompleted(uint256 _from, uint256 _count)
    public
    view
    returns (CommandList.element[] memory)
  {
    return commands.getByCompleted(_from, _count);
  }
}
