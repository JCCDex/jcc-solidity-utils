pragma solidity >=0.4.24;

import "../math/SafeMath.sol";
// import "./TransferList.sol";

/**
 * @dev 通证列表处理
 */
library CommandList {
  using SafeMath for uint256;

  enum Verbs {TRANSFER, EXCHANGE, EXECUTE}

  // 通证定义
  struct element {
    // 提交人
    address submitter;
    // 处理人
    address agent;
    // 从哪条链,遵循BIP44
    uint256 fromChain;
    // 跨到哪条链,遵循BIP44
    uint256 toChain;
    // 操作 0 transfer 1 exchange 2 execute
    uint256 verbs;
    // 状态 1表示提交等待锁定处理，2表示被锁定 3表示部分已经处理剩余解除锁定等待处理 4撤销处理 5处理完毕订单关闭
    uint256 status;
    // 细节数据索引位置, payload类型有三种: Transfer, Exchange, Execute
    bytes32 payloadHash;
  }

  struct commandMap {
    // data array 单向增加
    element[] list;
    // new fresh command
    uint256[] waiting;
    // locking command for process
    uint256[] locking;
    // canceled command:用户主动取消或者公证人取消
    uint256[] canceled;
    // completed command
    uint256[] completed;
    // 提交人命令清单,数组单向增加
    mapping(address => uint256[]) submitterCmds;
    // 处理人命令清单,数组单向增加
    mapping(address => uint256[]) agentCmds;
  }

  modifier validVerbs(uint256 _verbs) {
    require(
      _verbs == uint256(Verbs.TRANSFER) ||
        _verbs == uint256(Verbs.EXCHANGE) ||
        _verbs == uint256(Verbs.EXECUTE),
      "invalid verbs"
    );
    _;
  }

  function exist(commandMap storage self, uint256 _idx)
    internal
    view
    returns (bool)
  {
    if (_idx >= self.list.length) return false;
    return true;
  }

  // 增加跨链转账指令,单向增长
  function insert(
    commandMap storage self,
    address _submitter,
    uint256 _fromChain,
    uint256 _toChain,
    uint256 _verbs,
    bytes32 _payloadHash
  ) internal validVerbs(_verbs) returns (uint256) {
    element memory e = element({
      submitter: _submitter,
      agent: address(0),
      fromChain: _fromChain,
      toChain: _toChain,
      verbs: _verbs,
      status: 1,
      payloadHash: _payloadHash
    });

    uint256 _idx = self.list.length;
    self.list.push(e);
    self.waiting.push(_idx);
    self.submitterCmds[_submitter].push(_idx);

    return _idx;
  }

  function getIdx(uint256[] _arr, uint256 _idx)
    internal
    pure
    returns (bool, uint256)
  {
    if (_arr.length == 0) {
      return (false, 0);
    }
    for (uint256 i = _arr.length - 1; i > 0; i--) {
      if (_arr[i] == _idx) {
        return (true, i);
      }
    }

    return _arr[0] == _idx ? (true, 0) : (false, 0);
  }

  function lock(commandMap storage self, address _agent, uint256 _idx)
    internal
    returns (bool)
  {
    require(exist(self, _idx), "lock command does not exist");

    // get idx from waiting
    uint256 _waitingIdx;
    bool _exist;
    (_exist, _waitingIdx) = getIdx(self.waiting, _idx);
    require(_exist, "idx does not exist in waiting list");

    // remove idx from waiting
    self.waiting[_waitingIdx] = self.waiting[self.waiting.length.sub(1)];
    self.waiting.length = self.waiting.length.sub(1);

    // add idx to lock
    self.locking.push(_idx);
    // update to agent mapping
    self.list[_idx].agent = _agent;
    self.list[_idx].status = 2;
    self.agentCmds[_agent].push(_idx);

    return true;
  }

  function cancelFromWaiting(commandMap storage self, uint256 _idx)
    internal
    returns (bool)
  {
    // get idx from waiting
    uint256 _waitingIdx;
    bool _exist;
    (_exist, _waitingIdx) = getIdx(self.waiting, _idx);
    require(_exist, "idx does not exist in waiting list");

    // remove idx from waiting 0
    self.waiting[_waitingIdx] = self.waiting[self.waiting.length.sub(1)];
    self.waiting.length = self.waiting.length.sub(1);

    // add idx to canceled
    self.canceled.push(_idx);
    self.list[_idx].status = 4;

    return true;
  }

  function cancel(commandMap storage self, address _agent, uint256 _idx)
    internal
    returns (bool)
  {
    require(exist(self, _idx), "lock command does not exist");
    require(
      self.list[_idx].status != 4 && self.list[_idx].status != 5,
      "lock command status can not be canceled or done"
    );

    // in waiting list
    if (self.list[_idx].status == 1) {
      // 调用者要检查msg.sender
      require(
        _agent == self.list[_idx].submitter,
        "user only cancel him own command"
      );
      return cancelFromWaiting(self, _idx);
    }

    // 代理取消
    // get idx from locking
    uint256 _lockingIdx;
    bool _exist;
    (_exist, _lockingIdx) = getIdx(self.locking, _idx);
    require(_exist, "idx does not exist in locking list");
    require(_agent == self.list[_idx].agent, "agent cancel command himself");

    // remove idx from locking
    self.locking[_lockingIdx] = self.locking[self.locking.length.sub(1)];
    self.locking.length = self.locking.length.sub(1);

    // add idx to canceled
    self.canceled.push(_idx);
    self.list[_idx].status = 4;

    return true;
  }

  function complete(commandMap storage self, address _agent, uint256 _idx)
    internal
    returns (bool)
  {
    require(exist(self, _idx), "lock command does not exist");
    // 只有被锁定的才能结束
    require(
      self.list[_idx].status == 2,
      "lock command status can be completed"
    );
    require(_agent == self.list[_idx].agent, "agent cancel command himself");

    // get idx from locking
    uint256 _lockingIdx;
    bool _exist;
    (_exist, _lockingIdx) = getIdx(self.locking, _idx);
    require(_exist, "idx does not exist in locking list");

    // remove idx from locking
    self.locking[_lockingIdx] = self.locking[self.locking.length.sub(1)];
    self.locking.length = self.locking.length.sub(1);

    // add idx to completed
    self.completed.push(_idx);
    self.list[_idx].status = 5;

    return true;
  }

  function count(commandMap storage self) internal view returns (uint256) {
    return self.list.length;
  }

  function countWaiting(commandMap storage self)
    internal
    view
    returns (uint256)
  {
    return self.waiting.length;
  }

  function countLocking(commandMap storage self)
    internal
    view
    returns (uint256)
  {
    return self.locking.length;
  }

  function countCanceled(commandMap storage self)
    internal
    view
    returns (uint256)
  {
    return self.canceled.length;
  }

  function countCompleted(commandMap storage self)
    internal
    view
    returns (uint256)
  {
    return self.completed.length;
  }

  function countBySubmitter(commandMap storage self, address _submitter)
    internal
    view
    returns (uint256)
  {
    return self.submitterCmds[_submitter].length;
  }

  function countByAgent(commandMap storage self, address _agent)
    internal
    view
    returns (uint256)
  {
    return self.agentCmds[_agent].length;
  }

  function getByIdx(commandMap storage self, uint256 _idx)
    internal
    view
    returns (CommandList.element)
  {
    require(_idx < self.list.length, "index must small than current count");
    return self.list[_idx];
  }

  function getIdxBySubmitter(commandMap storage self, address _submitter)
    internal
    view
    returns (uint256[])
  {
    return self.submitterCmds[_submitter];
  }

  function getIdxByAgent(commandMap storage self, address _agent)
    internal
    view
    returns (uint256[])
  {
    return self.agentCmds[_agent];
  }

  function getWaitingIdx(commandMap storage self)
    internal
    view
    returns (uint256[])
  {
    return self.waiting;
  }

  function getLockingIdx(commandMap storage self)
    internal
    view
    returns (uint256[])
  {
    return self.locking;
  }

  function getElement(
    commandMap storage self,
    uint256[] _arr,
    uint256 _from,
    uint256 _count
  ) internal view returns (CommandList.element[] memory) {
    uint256 _idx = 0;
    require(_count > 0, "return number must bigger than 0");
    CommandList.element[] memory res = new CommandList.element[](_count);

    for (uint256 i = _from; i < _arr.length; i++) {
      if (_idx == _count) {
        break;
      }

      res[_idx] = self.list[_arr[i]];
      _idx = _idx.add(1);
    }

    return res;
  }

  function getBySubmitter(
    commandMap storage self,
    address _submitter,
    uint256 _from,
    uint256 _count
  ) internal view returns (CommandList.element[] memory) {
    return getElement(self, self.submitterCmds[_submitter], _from, _count);
  }

  function getByAgent(
    commandMap storage self,
    address _agent,
    uint256 _from,
    uint256 _count
  ) internal view returns (CommandList.element[] memory) {
    return getElement(self, self.agentCmds[_agent], _from, _count);
  }

  function getByCanceled(commandMap storage self, uint256 _from, uint256 _count)
    internal
    view
    returns (CommandList.element[] memory)
  {
    return getElement(self, self.canceled, _from, _count);
  }

  function getByCompleted(
    commandMap storage self,
    uint256 _from,
    uint256 _count
  ) internal view returns (CommandList.element[] memory) {
    return getElement(self, self.completed, _from, _count);
  }
}
