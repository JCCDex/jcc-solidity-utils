pragma solidity ^0.4.24;

import "../owner/Administrative.sol";

contract JCCGetPrice is Administrative {

  struct Price {
    bytes32 name; //token名称
    uint256 price;//token价格(toWei转换后的值)
    uint time;//最后一次更新时间
  }
    mapping (bytes32 => Price) _list;

    event EnPrice(
        bytes32 token,
        uint256 price);

        constructor() Administrative() public {
    }
    //设置的价格应该是实际价格*(10 ** 10),方便处理
    function _setPrice(bytes32 _key, bytes32 _token,uint256 _price) internal{
      Price  memory _p = Price({
        name: _token,
        price: _price,
        time: now
      });
        _list[_key] = _p;
    }

    function setPrice(bytes32 _token, uint256 _price)  public onlyPrivileged{
        bytes32 _key = keccak256(abi.encode(_token));
        require(_price > 0, "price must > 0");
        _setPrice(_key, _token, _price);
        emit EnPrice(_token, _price);
    }

    function getPrice(bytes32 _token) public view returns (bytes32, uint256, uint){
        bytes32 _key = keccak256(abi.encode(_token));
        return (_list[_key].name, _list[_key].price, _list[_key].time);
    }
}