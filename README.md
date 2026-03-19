# Merkle Airdrop Distributor

This repository provides an industry-standard implementation for distributing tokens via a Merkle Tree. This is the same architecture used by major protocols like Uniswap and ENS to handle massive airdrops efficiently.

## Why Merkle Trees?
- **Efficiency**: Instead of sending 5,000 transactions (high gas), the owner sends 1 transaction to set the Merkle Root.
- **Scalability**: Supports an unlimited number of recipients.
- **Security**: Claims are cryptographically verified; unauthorized addresses cannot steal tokens.

## Technical Details
- **Solidity 0.8.20**
- **OpenZeppelin Cryptography Libraries**
- **EIP-712 Compatibility potential**

## License
MIT
