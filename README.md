# 🗑️ Community Waste Collection

A decentralized waste management system built on the Stacks blockchain using Clarity smart contracts. This platform incentivizes proper waste disposal by rewarding participating households with SUSTAIN tokens.

![Clarity](https://img.shields.io/badge/Clarity-2.0-blue)
![Stacks](https://img.shields.io/badge/Stacks-Blockchain-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Smart Contract](#smart-contract)
- [Getting Started](#getting-started)
- [Contract Functions](#contract-functions)
- [Token Economics](#token-economics)
- [Development](#development)
- [Testing](#testing)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

## 🌟 Overview

Community Waste Collection is a blockchain-based solution designed to promote sustainable waste management practices. By leveraging the Stacks blockchain, this system provides:

- **Transparent Waste Tracking**: All waste collection data is immutably recorded on-chain
- **Incentive-Based System**: Households earn SUSTAIN tokens for proper waste disposal
- **Decentralized Governance**: No central authority controls the system
- **STX Fee Collection**: Collection fees are managed transparently through smart contracts

## ✨ Features

- **Household Registration**: Households can register to participate in the waste collection program
- **Waste Reporting & Payment**: Registered households report waste and pay collection fees in STX
- **Token Rewards**: Participants receive SUSTAIN tokens as rewards for waste disposal
- **Admin Operations**: Contract owner can withdraw collected STX fees to a designated project account
- **SIP-010 Compliant**: SUSTAIN token follows the fungible token standard

## 📜 Smart Contract

The main smart contract is located at `contracts/community_waste.clar` and includes:

### Token Standard (SIP-010)
- `get-name` - Returns the token name ("SUSTAIN Token")
- `get-symbol` - Returns the token symbol ("SUSTAIN")
- `get-decimals` - Returns decimal places (6)
- `get-balance` - Returns balance for a principal
- `get-total-supply` - Returns total token supply
- `get-token-uri` - Returns token URI (none)
- `transfer` - Transfer tokens between principals

### Waste Management Functions
- `register-household` - Register a household to the system
- `report-and-pay` - Report waste and pay collection fees
- `get-household-info` - Get household registration and activity data
- `get-total-waste-collected` - Get total waste collected system-wide
- `get-total-stx-received` - Get total STX fees received

### Admin Functions
- `withdraw` - Admin function to withdraw collected STX to project account
- `get-contract-owner` - Get the contract owner principal

## 🚀 Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) - Clarity development environment
- [Node.js](https://nodejs.org/) (v18 or higher)
- npm or yarn

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/itzbayo/community-waste-collection.git
   cd community-waste-collection
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Verify contract syntax**
   ```bash
   clarinet check
   ```

## 🔧 Contract Functions

### Public Functions

#### `register-household`
Register a new household to participate in waste collection.

```clarity
(define-public (register-household))
```
- Returns: `(ok true)` on success, `(err u409)` if already registered

#### `report-and-pay`
Report waste disposal and pay collection fees.

```clarity
(define-public (report-and-pay (waste-kg uint) (fee-per-kg uint)))
```
- Parameters:
  - `waste-kg`: Amount of waste in kilograms
  - `fee-per-kg`: Fee rate in micro-STX per kilogram
- Returns: `(ok required-fee)` on success, error codes:
  - `u401`: Not registered
  - `u402`: Insufficient STX attached

#### `transfer`
Transfer SUSTAIN tokens (SIP-010 standard).

```clarity
(define-public (transfer (amount uint) (from principal) (to principal) (memo (optional (buff 34)))))
```

#### `withdraw`
Admin function to withdraw collected STX fees.

```clarity
(define-public (withdraw (amount uint)))
```
- Only callable by contract owner
- Returns: `(ok amount)` on success

### Read-Only Functions

| Function | Description |
|----------|-------------|
| `get-household-info` | Get household registration status and stats |
| `get-total-waste-collected` | Get system-wide waste collection total |
| `get-total-stx-received` | Get total STX fees collected |
| `get-contract-owner` | Get contract owner principal |
| `get-balance` | Get token balance for a principal |
| `get-total-supply` | Get total token supply |

## 💰 Token Economics

### SUSTAIN Token
- **Name**: SUSTAIN Token
- **Symbol**: SUSTAIN
- **Decimals**: 6
- **Reward Rate**: 10 SUSTAIN tokens per 1 kg of waste disposed

### Fee Structure
- Households pay STX fees based on waste amount and fee-per-kg rate
- Fees are collected in the contract and can be withdrawn by admin
- All fees are tracked transparently on-chain

## 🛠️ Development

### Project Structure

```
community-waste-collection/
├── Clarinet.toml           # Clarinet configuration
├── contracts/
│   └── community_waste.clar  # Main smart contract
├── tests/
│   └── community_waste.test.ts  # Unit tests
├── settings/
│   ├── Devnet.toml         # Devnet settings
│   ├── Testnet.toml        # Testnet settings
│   └── Mainnet.toml        # Mainnet settings
└── package.json            # Node.js dependencies
```

### Running Tests

```bash
npm test
```

### Local Development with Clarinet

1. **Start Clarinet console**
   ```bash
   clarinet console
   ```

2. **Deploy contract**
   ```bash
   clarinet deployments generate --testnet
   ```

3. **Run contract calls**
   ```clarity
   (contract-call? .community_waste register-household)
   (contract-call? .community_waste report-and-pay u10 u100)
   ```

## 🧪 Testing

The project includes comprehensive unit tests using the Clarinet SDK:

```bash
npm test
```

Test coverage includes:
- Household registration
- Waste reporting and payment
- Token minting and transfers
- Admin withdraw functionality
- Error handling

## 📦 Deployment

### Testnet Deployment

1. Configure your Stacks wallet and fund with STX
2. Update `settings/Testnet.toml` with your contract address
3. Deploy using Clarinet:
   ```bash
   clarinet deployments generate --testnet
   clarinet deployments apply -p deployments/default.testnet-plan.yaml
   ```

### Mainnet Deployment

1. Review all contract code thoroughly
2. Update `settings/Mainnet.toml` with your contract address
3. Generate deployment plan:
   ```bash
   clarinet deployments generate --mainnet
   ```
4. Apply deployment:
   ```bash
   clarinet deployments apply -p deployments/default.mainnet-plan.yaml
   ```

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Commit your changes**
   ```bash
   git commit -m 'Add amazing feature'
   ```
4. **Push to the branch**
   ```bash
   git push origin feature/amazing-feature
   ```
5. **Open a Pull Request**

### Code Standards

- Follow Clarity best practices
- Write comprehensive tests for new features
- Ensure all `clarinet check` passes with no errors
- Update documentation for any new functions

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Contact

For questions or support, please open an issue on GitHub.

---

**Built with ❤️ on Stacks Blockchain**
