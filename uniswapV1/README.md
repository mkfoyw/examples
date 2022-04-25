# uniswap V1
参考文件:
* [Programming DeFi: Uniswap](https://github.com/Dapp-Learning-DAO/Dapp-Learning/tree/main/basic/13-decentralized-exchange/uniswap-v1-like)
* [Programming DeFi: Uniswap. Part 1](https://jeiwan.net/posts/programming-defi-uniswap-1/)

1. 创建目录， 并添加 hardhat
```
mkdir uniswapV1  && cd uniswapV1 
yarn add -D hardhat 
```
2. 添加 ERC 20 合约
```
yarn add -D @openzeppelin/contracts
```
3. 初始化 hardhat 项目， 并从 `contract`, `script`, `test` 移除所有东西。 
```
yarn hardhat
```
4. 我们将会使用最新的 solidity， 请把 `hardhat.config.js` 中solidity 的版本升级到 `0.8.4`.