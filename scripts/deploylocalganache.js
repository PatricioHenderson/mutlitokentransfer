const { ethers } = require("hardhat");
const { MerkleTree } = require("merkletreejs");
const { keccak256, defaultAbiCoder } = require("ethers/lib/utils");

async function main() {
  // Obtain a instance of the contract
  const contractAddress = "0x45DE486d2A5AE9e890e38F79B70F8AF692b86648"; // This are just test directions
  const Contract = await ethers.getContractFactory("MultiTokenTransfer");
  const contract = await Contract.attach(contractAddress);
  console.log(contract)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
