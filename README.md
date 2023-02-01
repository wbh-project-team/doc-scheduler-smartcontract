# Doc Scheduler

This project is an ethereum based smart contract.

## How to setup

#### Install Packages

Install necessary packages over npm:

`npm i`

Install truffle to compile solidity:

`npm i -g truffle`

#### Solidity

Before you can start you need to add hidden files to setup your build pipeline with truffle. You need the following:

- .secret
- .infura
- .etherscan
- .polygonscan

they should include the api keys of the webtools (infura, etherscan, ...) and your wallet secret (seed phrase)

for more input take a look at truffle-config.js

Compile smart contracts:

`truffle compile`

Migrate to testnet:

`truffle migrate --network sepolia --reset`

or

`truffle migrate --network matic --reset`

verify

`truffle run verify DocScheduler --network=sepolia`
