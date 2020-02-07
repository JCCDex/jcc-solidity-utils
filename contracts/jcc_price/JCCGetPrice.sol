pragma solidity ^0.4.24;

import "../owner/Administrative.sol";

contract JCCGetPrice is Administrative {
    uint8 constant _maxLen = 255;
    uint256 constant toWei = 10 ** 10;
    mapping(string => uint256)  _list;

    event EnPrice(
        string token,        
        uint256 price);

    //设置的价格应该是实际价格*(10 ** 10),方便处理
    function _setPrice(string _token, uint256 _price) internal returns (uint256){
        _list[_token] = _price;
    }

    function setPrice(string _token, uint256 _price)  public onlyPrivileged{ 
        bytes memory _t = bytes(_token);
        require(_t.length <= _maxLen);

        require(_price > 0);
        _setPrice(_token, _price);
        emit EnPrice(_token, _price);
    }

    function getPrice(string _token) public view returns (uint256){
        bytes memory _t = bytes(_token);

        require(_t.length <= _maxLen);
        return _list[_token];
    }
}