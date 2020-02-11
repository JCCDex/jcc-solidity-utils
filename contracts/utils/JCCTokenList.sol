pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

import "../owner/Administrative.sol";
import "../list/ChainList.sol";

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
  using ChainList for ChainList.chainMap;

  ChainList.chainMap chains;

  event LogChain(uint256 indexed chainId, string symbol, bool add);

  // 通证定义
  struct token {
    uint256 id;
    uint256 chainId;
    /**
      ETH类的通证通过合约地址区分，所有地址标记为0的为链原生通证
      SWTC类的通证定义由"issuer/名称"来表示地址，issuer为空表示原生通证
     */
    string issuer;
    // 简称
    string symbol;
  }

  // 通证清单
  mapping(uint256 => token) _tokens;

  // 链上的所有通证清单
  uint256[] _tokensInChain;

  // 跨链映射的结构:建立动态数组，内容为tokenid，基于每个token id映射的数组相同
  mapping(uint256 => uint256[]) _tokenMap;

  function strlen(string memory _str) internal pure returns (uint256) {
    return bytes(_str).length;
  }

  function addChain(uint256 _id, string _symbol) public onlyPrivileged {
    require(chains.insert(_id, _symbol), "insert success");

    emit LogChain(_id, _symbol, true);
  }

  function removeChain(uint256 _id) public onlyPrivileged {
    ChainList.element memory c = chains.getById(_id);
    require(chains.remove(_id), "remove success");

    emit LogChain(c.id, c.symbol, false);
  }

  function getChainSymbolById(uint256 _id) public view returns (string symbol) {
    return chains.getById(_id).symbol;
  }

  function getChainIdBySymbol(string _symbol) public view returns (uint256 id) {
    return chains.getBySymbol(_symbol).id;
  }

  function getChainList(uint256 from, uint256 _count)
    public
    view
    returns (ChainList.element[] memory)
  {
    return chains.getList(from, _count);
  }

  function chainCount() public view returns (uint256) {
    return chains.count();
  }

  // function addToken(uint256 _id, uint256 _chainId )
  // // fallback function
  // function() public {
  //   require(false, "never receive fund.");
  // }

  // only owner can kill
  function kill() public {
    if (msg.sender == owner()) selfdestruct(owner());
  }
}
