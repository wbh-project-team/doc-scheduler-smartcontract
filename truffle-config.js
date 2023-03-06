/**
 * Use this file to configure your truffle project. It's seeded with some
 * common settings for different networks and features like migrations,
 * compilation and testing. Uncomment the ones you need or modify
 * them to suit your project as necessary.
 *
 * More information about configuration can be found at:
 *
 * trufflesuite.com/docs/advanced/configuration
 *
 * To deploy via Infura you'll need a wallet provider (like @truffle/hdwallet-provider)
 * to sign your transactions before they're sent to a remote public node. Infura accounts
 * are available for free at: infura.io/register.
 *
 * You'll also need a mnemonic - the twelve word phrase the wallet uses to generate
 * public/private key pairs. If you're publishing your code to GitHub make sure you load this
 * phrase from a file you've .gitignored so it doesn't accidentally become public.
 *
 */

const HDWalletProvider = require('@truffle/hdwallet-provider');

const fs = require('fs');
const mnemonic = fs.readFileSync('.secret').toString().trim();
const infuraKey = fs.readFileSync('.infura').toString().trim();
const etherscan = fs.readFileSync('.etherscan').toString().trim();
const auroratest = fs.readFileSync('.auroratest').toString().trim();
const polygonscan = fs.readFileSync('.polygonscan').toString().trim();

module.exports = {
  /**
   * Networks define how you connect to your ethereum client and let you set the
   * defaults web3 uses to send transactions. If you don't specify one truffle
   * will spin up a development blockchain for you on port 9545 when you
   * run `develop` or `test`. You can ask a truffle command to use a specific
   * network from the command line, e.g
   *
   * $ truffle test --network <network-name>
   */

  networks: {
    development: {
      host: 'localhost',
      port: 8545,
      network_id: '*'
    },
    rinkeby: {
      // provider: () => new HDWalletProvider( mnemonic, `wss://rinkeby.infura.io/ws/v3/${infuraKey}`),
      provider: () =>
        new HDWalletProvider(
          mnemonic,
          `wss://rinkeby.infura.io/ws/v3/${infuraKey}`
        ),

      // provider: () => new HDWalletProvider(mnemonic, `https://rinkeby.infura.io/v3/${infuraKey}`),
      gas: 10000000,
      gasPrice: 4000000000,
      network_id: 4,
      skipDryRun: true // Skip dry run before migrations? (default: false for public nets )
    },
    goerli: {
      // provider: () => new HDWalletProvider( mnemonic, `wss://rinkeby.infura.io/ws/v3/${infuraKey}`),
      provider: () =>
        new HDWalletProvider(
          mnemonic,
          `wss://goerli.infura.io/ws/v3/${infuraKey}`
        ),

      network_id: '5'
    },
    sepolia: {
      provider: () =>
        new HDWalletProvider(
          mnemonic,
          `wss://sepolia.infura.io/ws/v3/${infuraKey}`
        ),

      gas: 10000000,
      network_id: '11155111'
    },
    auroraTestnet: {
      provider: () =>
        new HDWalletProvider(mnemonic, 'https://testnet.aurora.dev'),
      network_id: 0x4e454153,
      gas: 10000000,
      from: '0xEF571ac215b9eC5Ef22a12954fF0d87d90e1F10B' // CHANGE THIS ADDRESS
    },
    aurora: {
      provider: () =>
        new HDWalletProvider(mnemonic, 'wss://mainnet.aurora.dev'),
      network_id: 0x4e454152,
      gas: 10000000,
      from: '0xEF571ac215b9eC5Ef22a12954fF0d87d90e1F10B' // CHANGE THIS ADDRESS
    },
    xDai: {
      provider: () =>
        new HDWalletProvider(mnemonic, 'wss://rpc.xdaichain.com/wss'),
      network_id: 100,
      confirmations: 2,
      gas: 50000000,
      gasPrice: 10000000000,
      skipDryRun: true
    },
    matic: {
      provider: () =>
        new HDWalletProvider(mnemonic, `https://rpc-mumbai.maticvigil.com`),
      network_id: 80001,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    }
  },
  plugins: ['truffle-plugin-verify'],
  api_keys: {
    etherscan: etherscan,
    aurorascan: auroratest,
    polygonscan: polygonscan
  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: '^0.8.0', // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      settings: {
        // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: true,
          runs: 100
        },
        viaIR: true,
        evmVersion: 'byzantium'
      }
    }
  },

  // Truffle DB is currently disabled by default; to enable it, change enabled: false to enabled: true
  //
  // Note: if you migrated your contracts prior to enabling this field in your Truffle project and want
  // those previously migrated contracts available in the .db directory, you will need to run the following:
  // $ truffle migrate --reset --compile-all

  db: {
    enabled: false
  }
};
