const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');
const { ethers } = require('ethers');

// Sample dataset: [index, address, amount_in_wei]
const recipients = [
  [0, "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", ethers.parseEther("100")],
  [1, "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", ethers.parseEther("250")]
];

// Hash function matching the Solidity abi.encodePacked logic
const leaves = recipients.map(v => 
  keccak256(ethers.solidityPacked(['uint256', 'address', 'uint256'], [v[0], v[1], v[2]]))
);

const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });
const root = tree.getHexRoot();

console.log("Merkle Root:", root);

// Generate proof for the first user
const proof = tree.getHexProof(leaves[0]);
console.log("Proof for User 0:", proof);
