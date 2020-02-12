pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

import "../owner/Administrative.sol";

contract JCCGetPrice is Administrative {

  uint8 constant _maxLen = 20;
  struct Price {
    string symbol; //名称
    uint256 price;//价格(toWei转换后的值)
    uint time;//最后一次更新时间
  }
    mapping (bytes32 => Price) _list;

    event EnPrice(
        string symbol,
        uint256 price);

        constructor() Administrative() public {
    }
    //设置的价格应该是实际价格*(10 ** 10),方便处理
    function _setPrice(bytes32 _key, string _symbol,uint256 _price) internal{
      Price  memory _p = Price({
        symbol: _symbol,
        price: _price,
        time: now
      });
        _list[_key] = _p;
    }

    function setPrice(string _symbol, uint256 _price)  public onlyPrivileged{
        bytes memory _t = bytes(_symbol);
        require(_t.length > 0, 'symbol length must not null');
        require(_t.length <= _maxLen, 'symbol length too large');
        require(_price > 0, "price must > 0");
        bytes32 _key = keccak256(abi.encodePacked(_symbol));

        _setPrice(_key, _symbol, _price);
        emit EnPrice(_symbol, _price);
    }

    function getPrice(string _symbol) public view returns (string, uint256, uint){
        bytes memory _t = bytes(_symbol);
        require(_t.length > 0, 'symbol length must not null');
        require(_t.length <= _maxLen, 'symbol length too large');
         bytes32 _key = keccak256(abi.encodePacked(_symbol));
        return (_list[_key].symbol, _list[_key].price, _list[_key].time);
    }
}