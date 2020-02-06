pragma solidity ^0.4.24;

contract JCCGetPrice {
    address owner;

    uint256 constant toWei = 10 ** 10;
    mapping(string => uint256) public prices;

    constructor() public{
        owner = msg.sender;
    }

    //设置的价格应该是实际价格*(10 ** 10),方便处理
    function set(string token, uint256 price) public returns (uint256 price){
        assert(msg.sender == owner);
        require(price > 0);
        prices[token] = price;
        return price;
    }

    function get(string token) public view returns (uint256 price){
        return prices[token];
    }
}