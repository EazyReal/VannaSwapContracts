# VannaSwap Contract

Forked form [Uniswap V4 Core](https://github.com/Uniswap/v4-core)

## Install 

`git submodule update --init --recursive`

---

## USDC
- Deploy
  - `forge create --rpc-url http://localhost:3030/ --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 contracts/mock-tokens/USDC.sol:USDC`
- Check Totalsupply
  - `cast call 0x5FbDB2315678afecb367f032d93F642f64180aa3 "totalSupply()(uint256)" --rpc-url http://localhost:3030/`


