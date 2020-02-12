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

测试链地址: 0x3dc943fc03817d4d5197b174655784ff0bae131a
主链地址: 0xc7078139d1cb927dea14fea083cec978fdecb32d

```bash
# 通过id查询
jcc_moac_tool --config ~/.jcc_moac_tool/config.json \
  --abi JCCChainList.json --contractAddr "0xc7078139d1cb927dea14fea083cec978fdecb32d" \
  --method "getById" --parameters '314'

# 通过名称查询
jcc_moac_tool --config ~/.jcc_moac_tool/config.json \
  --abi JCCChainList.json --contractAddr "0xc7078139d1cb927dea14fea083cec978fdecb32d" \
  --method "getBySymbol" --parameters '"MOAC"'

# 查询登记数量
jcc_moac_tool --config ~/.jcc_moac_tool/config.json \
  --abi JCCChainList.json --contractAddr "0xc7078139d1cb927dea14fea083cec978fdecb32d" \
  --method "count"

# 查询登记数量
jcc_moac_tool --config ~/.jcc_moac_tool/config.json \
  --abi JCCChainList.json --contractAddr "0xc7078139d1cb927dea14fea083cec978fdecb32d" \
  --method "getList" --parameters '0,3'
```
