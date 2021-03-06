pragma solidity >=0.4.24;

/**
 * @dev 支持jcc moac alarm定时回调的接口
 */
interface IJccMoacAlarmCallback {
  function jccMoacAlarmCallback() external;
}
