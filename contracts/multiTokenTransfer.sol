// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./receiveEther.sol";

/**
 * @title MultiTokenTransfer
 * @dev Transfer tokens based on merkle proof
 * @author Patricio Henderson
 */

contract MultiTokenTransfer is Ownable, ReceiveEther {
    bytes32 private root;
    uint256 public maxTransfers;
    mapping(address => bool) public submittedProofs;
    mapping(address => mapping(bytes32 => bool)) public submittedTransactions;
    

    /**
     * @dev Constructor function
     * @param _root  The merkle root hash
     */
    constructor(bytes32 _root) {
        root = _root;
    }

    /**
    * @dev Store and set max batch of transactions to be handled
    * @param _maxTransfers value to store
    */
    function setMaxTransfers(uint256 _maxTransfers) public onlyOwner {
        maxTransfers = _maxTransfers;
    }

    /**
     * @dev Set max number of transactions can be done in one operation
     * @param _transfers numeber of transactions to be configured
     */
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
    * @dev Submits multiple Merkle proofs of token amounts assigned to different addresses.
    * @param _proof Array of Merkle proofs.
    * @param _addr Array of recipient addresses.
    * @param _amount Array of amounts to be transferred to each recipient.
    */
    function submitProofs (bytes32[] memory _proof, address[] memory _addr, uint256[] memory _amount) public onlyOwner {
        for (uint256 i = 0; i < _addr.length; i++) {
            bytes32[] memory proofArray = new bytes32[](1);
            proofArray[0] = _proof[i];
            verify(proofArray, _addr[i], _amount[i]);
        }
    }

    /**
    * @dev Verifies a Merkle proof for a given address and amount.
    * @param _proof Array containing the Merkle proof.
    * @param _addr Recipient address.
    * @param _amount Amount to be transferred to the recipient.
    */
    function verify( bytes32[] memory _proof, address _addr, uint256 _amount) private  {
        bytes32 leaf = keccak256(abi.encodePacked(keccak256(abi.encode(_addr, _amount))));
        require(MerkleProof.verify(_proof , root , leaf), "Merkle proof verification failed");
        submittedProofs[_addr] = true;
    }


    /**
    * @dev Transfers tokens to multiple recipients, after verifying that a proof has been submitted for each transaction.
    * @param _token ERC20 token contract instance.
    * @param _recipients Array of recipient addresses.
    * @param _amounts Array of amounts to be transferred to each recipient.
    */
    function transferTokens(IERC20 _token,
    address[] memory _recipients,
    uint256[] memory _amounts
    )
     public onlyOwner payable 
    maxTransfersAllowed(_amounts.length) {
        require(_recipients.length == _amounts.length, "Invalid input length");

        for (uint256 i = 0; i < _recipients.length; i++) {
            require(submittedProofs[_recipients[i]], "No proof submitted");

            // Transfer tokens to each recipient
            require(_token.transfer(_recipients[i], _amounts[i]), "Token transfer failed");
        }
    }
    }