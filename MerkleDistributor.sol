// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MerkleDistributor
 * @dev Contract to distribute tokens to a list of users verified by a Merkle Root.
 */
contract MerkleDistributor is Ownable {
    address public immutable token;
    bytes32 public merkleRoot;

    // Track whether an index has been claimed
    mapping(uint256 => bool) private _isClaimed;

    event Claimed(uint256 index, address account, uint256 amount);
    event MerkleRootUpdated(bytes32 oldRoot, bytes32 newRoot);

    constructor(address token_, bytes32 merkleRoot_) Ownable(msg.sender) {
        token = token_;
        merkleRoot = merkleRoot_;
    }

    /**
     * @dev Check if an airdrop index has already been claimed.
     */
    function isClaimed(uint256 index) public view returns (bool) {
        return _isClaimed[index];
    }

    /**
     * @dev Claim tokens using a Merkle Proof.
     */
    function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external {
        require(!isClaimed(index), "Drop already claimed.");

        // Verify the merkle proof
        bytes32 node = keccak256(abi.encodePacked(index, account, amount));
        require(MerkleProof.verify(merkleProof, merkleRoot, node), "Invalid proof.");

        // Mark it claimed and send the tokens
        _isClaimed[index] = true;
        require(IERC20(token).transfer(account, amount), "Transfer failed.");

        emit Claimed(index, account, amount);
    }

    /**
     * @dev Allows the owner to update the Merkle Root for subsequent rounds.
     */
    function updateMerkleRoot(bytes32 newMerkleRoot) external onlyOwner {
        emit MerkleRootUpdated(merkleRoot, newMerkleRoot);
        merkleRoot = newMerkleRoot;
    }

    /**
     * @dev Emergency withdraw for remaining tokens after the drop.
     */
    function emergencyWithdraw() external onlyOwner {
        uint256 balance = IERC20(token).balanceOf(address(this));
        IERC20(token).transfer(owner(), balance);
    }
}
