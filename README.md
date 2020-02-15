# jcc-solidity-utils

smart contract utilities for MOAC and Ethereum blockchain

## ERC20Factory 部署

以 MOAC 工具部署为例，以太坊工具部署类似

```bash
# 创建一个不可动态发行的ERC20通证
jcc_moac_tool --config ~/.jcc_moac_tool/config.test.json \
  --keystore ~/.jcc_moac_tool/0x1234567 \
  --deploy ERC20Factory.json --gas_limit 2000000 \
  --parameters '"SWT COIN","SWTC",18,600000000000,false'

# 部署成功后，测试下
jcc_moac_tool --config ~/.jcc_moac_tool/config.test.json \
  --abi ERC20Factory.json --contractAddr "0x7fb0564d2e838b487979698ee9c6d0fd4aabccda" \
  --method "name"

# 部署一个可以动态增发的
jcc_moac_tool --config ~/.jcc_moac_tool/config.test.json \
  --keystore ~/.jcc_moac_tool/0x1234567 \
  --deploy ERC20Factory.json --gas_limit 2000000 \
  --parameters '"EOS","EOS",18,1000000,true'

# 查询发行量-动态增发的初始值是0，创建指定的参数为最大值
jcc_moac_tool --config ~/.jcc_moac_tool/config.test.json \
  --abi ERC20Factory.json --contractAddr "0x8bbff1ee41772dd6c585056edfebafeebacaa704" \
  --method "totalSupply"

# 动态增发
jcc_moac_tool --config ~/.jcc_moac_tool/config.test.json \
  --keystore ~/.jcc_moac_tool/0x1234567 \
  --abi ERC20Factory.json --contractAddr "0x8bbff1ee41772dd6c585056edfebafeebacaa704" \
  --method "mint" --parameters '"0x1234567", chain3.toSha("10000")' --gas_limit 100000
# 增发后，重新查询供应量
```

## JCCChainList

遵循 BIP44 标准的链定义合约，供 DAPP 查询使用

测试链地址: 0x4d9f2cf99f5f94573f22288af698089a3bd4e2f1
主链地址: 0x761e87f055428d053bb1e666e84ebed94584bdfc

```bash
# 通过id查询
jcc_moac_tool --config ~/.jcc_moac_tool/config.json \
  --abi JCCChainList.json --contractAddr "0x761e87f055428d053bb1e666e84ebed94584bdfc" \
  --method "getById" --parameters '314'

# 通过名称查询
jcc_moac_tool --config ~/.jcc_moac_tool/config.json \
  --abi JCCChainList.json --contractAddr "0x761e87f055428d053bb1e666e84ebed94584bdfc" \
  --method "getBySymbol" --parameters '"MOAC"'

# 查询登记数量
jcc_moac_tool --config ~/.jcc_moac_tool/config.json \
  --abi JCCChainList.json --contractAddr "0x761e87f055428d053bb1e666e84ebed94584bdfc" \
  --method "count"

# 查询登记列表
jcc_moac_tool --config ~/.jcc_moac_tool/config.json \
  --abi JCCChainList.json --contractAddr "0x761e87f055428d053bb1e666e84ebed94584bdfc" \
  --method "getList" --parameters '0,3'
```

## JCCTokenList

通证定义合约，跨链映射合约，供合约和 DAPP 查询使用

测试链地址: 0x4a0d4349e1f32f603fdaaf2c8a083b155baf59c2
主链地址: 0x7df74d3a1e379e0bb83cd0363cfc670df750acfe

```bash
# 通过id查询
jcc_moac_tool --config ~/.jcc_moac_tool/config.json \
  --abi JCCTokenList.json --contractAddr "0x7df74d3a1e379e0bb83cd0363cfc670df750acfe" \
  --method "getById" --parameters '1'

# 通过名称查询
jcc_moac_tool --config ~/.jcc_moac_tool/config.json \
  --abi JCCTokenList.json --contractAddr "0x7df74d3a1e379e0bb83cd0363cfc670df750acfe" \
  --method "getBySymbol" --parameters '314,"MOAC"'

# 查询登记数量
jcc_moac_tool --config ~/.jcc_moac_tool/config.json \
  --abi JCCTokenList.json --contractAddr "0x7df74d3a1e379e0bb83cd0363cfc670df750acfe" \
  --method "count"

# 查询登记数量
jcc_moac_tool --config ~/.jcc_moac_tool/config.json \
  --abi JCCTokenList.json --contractAddr "0x7df74d3a1e379e0bb83cd0363cfc670df750acfe" \
  --method "getList" --parameters '0,3'

# 查询跨链等价通证
jcc_moac_tool --config ~/.jcc_moac_tool/config.json \
  --abi JCCTokenList.json --contractAddr "0x7df74d3a1e379e0bb83cd0363cfc670df750acfe" \
  --method "getCrossList" --parameters '"0xc145773dfe9aef11e528b35df510775c3f6dcfc2678940204a56efbc0398e49a"'
# 跨链查询输出如下:
[
  [
    [
      {
        "_hex": "0x03"
      },
      {
        "_hex": "0x04"
      },
      {
        "_hex": "0x3c"
      },
      # 原生通证的origin字段为0
      "0x0000000000000000000000000000000000000000000000000000000000000000",
      "0x9BD4810a407812042F938d2f69f673843301cfa6/",
      "JCC"
    ],
    [
      {
        "_hex": "0x04"
      },
      {
        "_hex": "0x05"
      },
      {
        "_hex": "0x013b"
      },
      # 映射通证的origin字段为原生通证的chainid+issuer的sha3哈希
      "0xc145773dfe9aef11e528b35df510775c3f6dcfc2678940204a56efbc0398e49a",
      "jGa9J9TkqtBcUoHe2zqhVFFbgUVED6o9or/",
      "JJCC"
    ]
  ]
]
```
