require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    goerli: {
      url: "https://eth-goerli.g.alchemy.com/v2/Jz1cOldmTo8ch1KgCjzlDUclIfRbhd4b",
    },
    ganache: {
      url: "http://localhost:8545", 
      chainId: 1337, 
    }
  },
  solidity: "0.8.2",
};


