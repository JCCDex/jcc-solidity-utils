pragma solidity ^0.4.24;

contract JCCGetPrice {
    address owner;

    uint256 constant toWei = 10 ** 10;
    mapping(string => uint256)  _list;

    constructor() public{
        owner = msg.sender;
    }

    //设置的价格应该是实际价格*(10 ** 10),方便处理
    function setPrice(string _token, uint256 _price) internal returns (uint256){
        assert(msg.sender == owner);
        require(_price > 0);
        _list[_token] = _price;
        return _price;
    }

    function getPrice(string _token) public view returns (uint256){
        return _list[_token];
    }
}