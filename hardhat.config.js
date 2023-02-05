require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config({ path: ".env" });
require ("hardhat-gas-reporter");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks:{
    mumbai:{
      url: process.env.ALCHEMY_KEY,
      accounts: [`0x${process.env.PRIVATE_KEY}`]
    }
  },
  etherscan: {
    apiKey: {
      polygonMumbai: process.env.POLYGONSCAN_KEY,
    },
  },
  gasReporter:{
    enabled:true,
    outputFile:"gasReport.txt",
    noColors:true ,
    coinmarketcap:`${process.env.COINMARKETCAP_API_KEY}`
  }
};
