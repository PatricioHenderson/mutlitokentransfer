// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title MultiTokenTransfer
 * @dev Transfer tokens based on merkle proof
 */
contract MultiTokenTransfer is Ownable {
    uint256 public maxTransfers;
    mapping(bytes32 => bool) public submittedProofs;
    mapping(address => mapping(bytes32 => bool)) public submittedTransactions;


    /**
    * @dev Store and set max batch of transactions to be handled
    * @param _maxTransfers value to store
    */
    function setMaxTransfers(uint256 _maxTransfers) public onlyOwner {
        maxTransfers = _maxTransfers;
    }

    modifier maxTransfersAllowed(uint256 _transfers){
        require (_transfers <= maxTransfers, "Number of transfers exceeds maximum allowed");
        _;
    }

    /**
    * @dev Return value of max transfers allowed 
    * @return value of max transfers
    */
    function retrieveMaxTransfers() public view returns (uint256) {
        return maxTransfers;
    }

    /**
    * @dev Submit a proof to transfer tokens based on merkle proof
    * @param _proof merkle proof to verify
    * @param _root merkle root of the merkle tree containing the proofs
    * @param _token address of the token to transfer
    * @param _amounts array containing the amounts to transfer
    * @param _recipients array containing the recipients of the transfers
    */
    function submitProof(bytes32[] calldata _proof, bytes32 _root, address _token, uint256[] calldata _amounts, address[] calldata _recipients) external maxTransfersAllowed(_amounts.length) {
        // Calculate the leaf node of the merkle tree
        bytes32 leaf = keccak256(abi.encode(_token, _recipients, _amounts));

        // Calculate the concatenated hash of the proof
        bytes32 concatenated = keccak256(abi.encode(_token, _recipients, _amounts));

        // Calculate the hash of the proof and the sender's address
        bytes32 proofHash = keccak256(abi.encode(msg.sender, concatenated));

        // Check if the proof has already been submitted
        require(!submittedProofs[proofHash], "Proof already submitted");

        // Verify the merkle proof
        require(MerkleProof.verify(_proof, _root, leaf), "Merkle proof verification failed");

        // Mark the proof as submitted
        submittedProofs[proofHash] = true;
    }


    /**
    * @dev Transfers tokens to multiple recipients, after verifying that a proof has been submitted for the transaction.
    * @param _token ERC20 token contract instance.
    * @param _recipients Array of recipient addresses.
    * @param _amounts Array of amounts to be transferred to each recipient.
    */
    function transferTokens(IERC20 _token, address[] calldata _recipients, uint256[] calldata _amounts) public onlyOwner maxTransfersAllowed(_recipients.length) {
        require(_recipients.length == _amounts.length, "Number of recipients must match number of amounts");
        
        // Concatenate the inputs and hash to check if proof has been submitted
        bytes32 concatenated = keccak256(abi.encodePacked(_token, _recipients, _amounts));
        require(submittedProofs[concatenated], "No proof submitted");
            
        // Transfer tokens to each recipient
        for (uint256 i = 0; i < _recipients.length; i++){
            require(_token.transfer(_recipients[i], _amounts[i]), "Token transfer failed");
        }
    }


    }