pragma solidity >=0.4.24;

/**
@dev 检测payload共通
 */
contract Payload {
  modifier onlyPayloadSize(uint256 size) {
    require(msg.data.length >= size + 4, "payload size invaild");
    _;
  }
}
