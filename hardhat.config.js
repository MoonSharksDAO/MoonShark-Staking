require('dotenv').config()
require('hardhat-abi-exporter');

// NatSpec Docs
require('@primitivefi/hardhat-dodoc');
require('hardhat-docgen');

require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");


// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  abiExporter: {
    path: './src/abi',
    runOnCompile: true,
    clear: true,
    spacing: 2,
    pretty: true,
  },
  dodoc: {
    runOnCompile: false,
    freshOutput: true,
    outputDir: 'dodoc',
  },
  docgen: {
    path: './docgen',
    clear: true,
    runOnCompile: false,
  },
  networks: {
    ganache:{
      url: "http://127.0.0.1:7545",
    },
    ethereum: {
      url: process.env.ETHEREUM_URL,
      chainId: 1,
      accounts: {
        mnemonic : process.env.MNEMONIC,
      }
    },
    bsc: {
      url: process.env.BSC_URL,
      chainId: 56,
      accounts: {
        mnemonic : process.env.MNEMONIC,
      }
    },
    polygon: {
      url: process.env.POLYGON_URL,
      chainId: 137,
      accounts: {
        mnemonic : process.env.MNEMONIC,
      }
    },
    avalanche: {
      url: process.env.AVALANCHE_URL,
      chainId: 43114,
      accounts: {
        mnemonic : process.env.MNEMONIC,
      }
    },
    fantom: {
      url: process.env.FANTOM_URL,
      chainId: 250,
      accounts: {
        mnemonic : process.env.MNEMONIC,
      }
    },


    rinkeby: {
      url: process.env.RINKEBY_TESTNET_URL,
      chainId: 4,
      accounts: {
        mnemonic : process.env.MNEMONIC,
      }
    },
    bscTestnet: {
      url: process.env.BSC_TESTNET_URL,
      chainId: 97,
      accounts: {
        mnemonic : process.env.MNEMONIC,
      }
    },
    mumbai: {
      url: process.env.MUMBAI_TESTNET_URL,
      chainId: 80001,
      accounts: {
        mnemonic : process.env.MNEMONIC,
      }
    },
    fuji: {
      url: process.env.FUJI_TESTNET_URL,
      chainId: 43113,
      accounts: {
        mnemonic : process.env.MNEMONIC,
      }
    },
    fantomTestnet: {
      url: process.env.FANTOM_TESTNET_URL,
      chainId: 4002,
      accounts: {
        mnemonic : process.env.MNEMONIC,
      }
    },
  },
  etherscan: {
    apiKey: {
      mainnet: process.env.ETHEREUM_ETHERSCAN_API_KEY,
      polygon: process.env.POLYGON_ETHERSCAN_API_KEY,
      bsc: process.env.BSC_ETHERSCAN_API_KEY,
      opera: process.env.FANTOM_ETHERSCAN_API_KEY,
      avalanche: process.env.AVALANCHE_ETHERSCAN_API_KEY,

      rinkeby: process.env.RINKEBY_TESTNET_ETHERSCAN_API_KEY,
      polygonMumbai: process.env.MUMBAI_TESTNET_ETHERSCAN_API_KEY,
      bscTestnet: process.env.BSC_TESTNET_ETHERSCAN_API_KEY,
      ftmTestnet: process.env.FANTOM_TESTNET_ETHERSCAN_API_KEY,
      avalancheFujiTestnet: process.env.FUJI_TESTNET_ETHERSCAN_API_KEY,

    }
  }
};
