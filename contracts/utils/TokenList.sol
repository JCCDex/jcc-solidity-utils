pragma solidity ^0.4.24;

import "../owner/Administrative.sol";

/**
 * Token清单
 * 链的定义遵循 BIP44 规范， 参见
 * https://github.com/satoshilabs/slips/blob/master/slip-0044.md
 * 通证基于不同链的定义方式，以字符串形式保存
 */
contract TokenList is Administrative {
  // 遵循BIP44
  struct chain {
    uint256 id;
    string symbol;
  }

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

  // 区块链列表
  mapping(uint256 => chain) _chains;
  // 通证清单
  mapping(uint256 => token) _tokens;

  // 链上的所有通证清单
  uint256[] _tokensInChain;

  // 跨链映射的结构:建立动态数组，内容为tokenid，基于每个token id映射的数组相同
  mapping(uint256 => uint256[]) _tokenMap;

  function addChain(uint256 _id, string _symbol) public onlyPrivileged {
    chain storage _chain = chain({id: _id, symbol: _symbol});
    _chains[_id] = _chain;
  }

  function getChain(uint256 _id) public view returns (string _symbol) {
    return _chains[_id].symbol;
  }

  function addToken(uint256 _id, uint256 _chainId, )
  // fallback function
  function() public {
    require(false, "never receive fund.");
  }

  // only owner can kill
  function kill() public {
    if (msg.sender == owner()) selfdestruct(owner());
  }
}
