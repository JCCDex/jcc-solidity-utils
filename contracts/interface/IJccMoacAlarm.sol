pragma solidity >=0.4.24;

/**
 * @dev 支持调用定时合约的接口，用来设置定时任务
 */
interface IJccMoacAlarm {
  event CreateAlarm(
    address indexed contractAddr,
    uint256 indexed _type,
    uint256 indexed _begin,
    uint256 _peroid
  );
  event RemoveAlarm(address indexed contractAddr);
  event Alarm(address indexed contractAddr, uint256 indexed time);

  function createAlarm(
    address _addr,
    uint256 _type,
    uint256 _begin,
    uint256 _peroid
  ) external returns (bool);

  function removeAlarm(address _addr) external returns (bool);
}
