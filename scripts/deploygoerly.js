const hre = require("hardhat");

async function main() {
  // Set up the network configuration
  await hre.network.provider.request({
    method: "hardhat_reset",
    params: [
      {
        forking: {
          jsonRpcUrl: "https://eth-goerli.g.alchemy.com/v2/Jz1cOldmTo8ch1KgCjzlDUclIfRbhd4b",
          blockNumber: 9023781  // Specify the desired block number for forking
        }
      }
    ],
  });

  // Deploy your contract and perform other tasks
  const root = "0x5bec1df86edceef7361998e4bbea193dddba752d2477e58d7aed03f861fccf79";
  const MyContract = await hre.ethers.getContractFactory("MultiTokenTransfer");
  const myContract = await MyContract.deploy(root);
  await myContract.deployed();

  console.log("MyContract deployed to:", myContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

