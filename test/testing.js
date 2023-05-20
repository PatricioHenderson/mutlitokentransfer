const { ethers } = require("hardhat");
const { expect } = require("chai");
const path = require("path");

const { keccak256, defaultAbiCoder } = require("ethers/lib/utils");
const { StandardMerkleTree } = require("@openzeppelin/merkle-tree");
const fs = require("fs");


describe("MultiTokenTransfer", function () {
    let contract;
    let token;
    const proof = [
      "0xebf09d18ef212432cfa2e714503e8710a4032aa6d15b222f8880dd796ec2e957",
      "0x60648906e1a3f55dd188e992dc24db68c6b6d455fe925705f5e110ed7889ad90"
    ];
    const amounts = ["1", "1"];
    const recipients = [
      "0x1111111111111111111111111111111111111111",
      "0x2222222222222222222222222222222222222222"
    ];
  
    beforeEach(async function () {
      // Deploy the MultiTokenTransfer contract
      const Contract = await ethers.getContractFactory("MultiTokenTransfer");
      const root = "0x5bec1df86edceef7361998e4bbea193dddba752d2477e58d7aed03f861fccf79";
      contract = await Contract.deploy(root);
      await contract.deployed();
    });
  
    describe("setMaxTransfers", function () {
      it("should limit the number of transfers", async function () {
        const maxTransfers = 2;
        await contract.setMaxTransfers(maxTransfers);
  
        const retrievedMaxTransfers = await contract.retrieveMaxTransfers();
  
        expect(retrievedMaxTransfers).to.equal(maxTransfers);
      });
    });
  
    describe("submitProofs", function () {
      it("should submit merkle proof", async function () {
        const maxTransfers = 2;
        await contract.setMaxTransfers(maxTransfers);
  
        await contract.submitProofs(proof, recipients, amounts);
      });
      it("Merkle proof verification failed", async function () {
        const maxTransfers = 2;
        await contract.setMaxTransfers(maxTransfers);
        const amounts = ["10", "5"]
        
        // Expect an error to be thrown when submitting the proofs with incorrect amounts   
        await expect(contract.submitProofs(proof, recipients, amounts)).to.be.revertedWith("Merkle proof verification failed");
      });
    });
  
    describe("transferTokens", function () {
      beforeEach(async function () {
        // Deploy a test ERC20 token
        token = await ethers.getContractFactory("TestToken");
        token = await token.deploy("Test Token", "TST");
        await token.deployed();
      });
  
      it("should transfer tokens based on merkle proof", async function () {
        const tokenAddress = token.address;
  
        const amount = 2;
        await token.transfer(contract.address, amount);
  
        const contractBalanceBefore = await token.balanceOf(contract.address);
        console.log("Tokens in the contract (before transfer):", contractBalanceBefore.toString());
  
        const maxTransfers = 2;
        await contract.setMaxTransfers(maxTransfers);
  
        await contract.submitProofs(proof, recipients, amounts);
  
        await contract.transferTokens(tokenAddress, recipients, amounts);
  
        const recipient1Balance = await token.balanceOf(recipients[0]);
        const recipient2Balance = await token.balanceOf(recipients[1]);
  
        console.log("Recipient 1 balance:", recipient1Balance.toString());
        console.log("Recipient 2 balance:", recipient2Balance.toString());
      });
    });
  });
  
  