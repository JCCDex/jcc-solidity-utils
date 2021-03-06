pragma solidity >=0.4.24;

/**
可升级合约接口定义
 */
interface IUpgradeable {
  function upgrade(address newImpl) external;

  event Upgrade(address indexed newAddress, address indexed oldAddress);
}
