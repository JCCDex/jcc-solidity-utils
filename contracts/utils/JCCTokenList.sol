pragma solidity >=0.4.24;
pragma experimental ABIEncoderV2;

import "../owner/Administrative.sol";
import "../list/TokenList.sol";

/**
 * Token清单
 * 提供链和通证的定义字典，提供不同链通证映射关系，为跨链转移资产提供基础数据支持
 * 1. 支持多签名钱包操作
 * 2. 支持编码和符号查询
 * 3. 支持不同链通证映射查询
 * 链的定义遵循 BIP44 规范， 参见
 * https://github.com/satoshilabs/slips/blob/master/slip-0044.md
 * 通证基于不同链的定义方式，以字符串形式保存
 */
contract JCCTokenList is Administrative {
  using TokenList for TokenList.tokenMap;

  event Add(
    uint256 indexed tokenId,
    uint256 indexed chainId,
    bytes32 indexed _origin,
    string issuer,
    string symbol
  );
  event Remove(uint256 indexed tokenId);

  TokenList.tokenMap tokens;

  constructor() public Administrative() {}

  function insert(
    uint256 _id,
    uint256 _chainId,
    bytes32 _origin,
    string _issuer,
    string _symbol
  ) public onlyPrivileged returns (bool) {
    require(
      tokens.insert(_id, _chainId, _origin, _issuer, _symbol),
      "add token failed"
    );
    emit Add(_id, _chainId, _origin, _issuer, _symbol);
    return true;
  }

  function remove(uint256 _id) public onlyPrivileged returns (bool) {
    require(tokens.remove(_id), "remove token failed");
    emit Remove(_id);
    return true;
  }

  function get(uint256 _idx) public view returns (TokenList.element) {
    return tokens.get(_idx);
  }

  function getById(uint256 _id) public view returns (TokenList.element) {
    return tokens.getById(_id);
  }

  function getBySymbol(uint256 _chainId, string _symbol)
    public
    view
    returns (TokenList.element)
  {
    return tokens.getBySymbol(_chainId, _symbol);
  }

  function getByIssuer(uint256 _chainId, string _issuer)
    public
    view
    returns (TokenList.element)
  {
    return tokens.getByIssuer(_chainId, _issuer);
  }

  function getCrossList(bytes32 _origin)
    public
    view
    returns (TokenList.element[])
  {
    return tokens.getCrossList(_origin);
  }

  function getList(uint256 from, uint256 _count)
    public
    view
    returns (TokenList.element[] memory)
  {
    return tokens.getList(from, _count);
  }

  function count() public view returns (uint256) {
    return tokens.count();
  }
}
