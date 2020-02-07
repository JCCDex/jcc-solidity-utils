pragma solidity ^0.4.24;

import "../owner/Administrative.sol";

contract JCCGetPrice is Administrative {
    uint8 constant _maxLen = 255;
    mapping (bytes32 => uint256) _list;

    event EnPrice(
        string token,
        uint256 price);

        constructor() Administrative() public {
    }
    //设置的价格应该是实际价格*(10 ** 10),方便处理
    function _setPrice(bytes32 _key, uint256 _price) internal{
        _list[_key] = _price;
    }

    function setPrice(string _token, uint256 _price)  public onlyPrivileged{
        bytes32 _key = keccak256(abi.encode(_token));
        require(_key.length <= _maxLen, "token length too large");
        require(_price > 0, "price must > 0");
        _setPrice(_key, _price);
        emit EnPrice(_token, _price);
    }

    function getPrice(string _token) public view returns (uint256){
        bytes32 _key = keccak256(abi.encode(_token));
        require(_key.length <= _maxLen,  "token length too large");
        return _list[_key];
    }
}