pragma solidity ^0.4.24;

contract JCCGetPrice {
    address _owner;
    uint8 constant _maxLen = 255;
    uint256 constant toWei = 10 ** 10;
    mapping(string => uint256)  _list;

    constructor() public{
        _owner = msg.sender;
    }

    //设置的价格应该是实际价格*(10 ** 10),方便处理
    function _setPrice(address _setter, string _token, uint256 _price) internal returns (uint256){
        assert(_setter == _owner);

        bytes memory _t = bytes(_token);
        require(_t.length <= _maxLen);

        require(_price > 0);

        _list[_token] = _price;
        return _price;
    }

    function setPrice(string _token, uint256 _price) public returns (uint256){
        return _setPrice(msg.sender, _token, _price);
    }

    function getPrice(string _token) public view returns (uint256){
        bytes memory _t = bytes(_token);

        require(_t.length <= _maxLen);
        return _list[_token];
    }
}