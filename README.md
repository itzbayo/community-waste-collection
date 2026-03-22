# 🗑️ Community Waste Collection

[![Clarity](https://img.shields.io/badge/Clarity-2.0-blue)](https://docs.stacks.co/clarity)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A decentralized smart contract platform for managing community waste collection with token-based incentives built on the Stacks blockchain.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Smart Contract](#smart-contract)
- [Getting Started](#getting-started)
- [Installation](#installation)
- [Usage](#usage)
- [Testing](#testing)
- [Project Structure](#project-structure)
- [Technology Stack](#technology-stack)
- [Contributing](#contributing)
- [License](#license)

## 🌟 Overview

Community Waste Collection is a blockchain-based solution that incentivizes proper waste disposal by rewarding participating households with SUSTAIN tokens. The platform enables:

- **Household Registration**: Households can register to participate in the waste collection program
- **Waste Reporting**: Registered households report their waste in kilograms
- **Fee Collection**: Automatic STX fee collection for waste services
- **Token Rewards**: Households earn 10 SUSTAIN tokens per kilogram of waste reported
- **Admin Withdrawals**: Contract administrators can withdraw collected STX to fund operations

## ✨ Features

- **SIP-010 Compliant Token**: SUSTAIN token follows the fungible token standard for interoperability
- **Decentralized Waste Tracking**: Immutable records of waste collection on the Stacks blockchain
- **Incentive Mechanism**: Token rewards encourage community participation
- **Transparent Fee Management**: All fees and transactions are verifiable on-chain
- **Admin Controls**: Secure withdrawal functionality for project funding

## 📜 Smart Contract

The core smart contract (`community_waste.clar`) implements the following functionality:

### SIP-010 Fungible Token Functions

| Function | Description |
|----------|-------------|
| `get-name` | Returns the token name ("SUSTAIN Token") |
| `get-symbol` | Returns the token symbol ("SUSTAIN") |
| `get-decimals` | Returns token decimals (6) |
| `get-balance` | Returns token balance for a principal |
| `get-total-supply` | Returns total token supply |
| `get-token-uri` | Returns token URI (none) |
| `transfer` | Transfers tokens between principals |

### Waste Collection Functions

| Function | Description |
|----------|-------------|
| `register-household` | Registers caller as a participating household |
| `get-household-info` | Returns household registration and waste data |
| `report-and-pay` | Report waste (kg) and pay collection fee |
| `get-total-waste-collected` | Returns total waste collected system-wide |
| `get-total-stx-received` | Returns total STX fees received |

### Admin Functions

| Function | Description |
|----------|-------------|
| `withdraw` | Admin-only: Withdraw collected STX to project account |
| `get-contract-owner` | Returns the contract deployer address |

### Error Codes

| Code | Description |
|------|-------------|
| `u100` | Owner-only operation |
| `u101` | Not token owner |
| `u102` | Insufficient token balance |
| `u103` | Invalid amount |
| `u401` | Household not registered |
| `u402` | Insufficient payment |
| `u404` | Insufficient contract balance |
| `u409` | Already registered |

## 🚀 Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (v18 or higher)
- [npm](https://www.npmjs.com/) or [yarn](https://yarnpkg.com/)
- [Clarinet](https://github.com/hirosystems/clarinet) (v2.5.0 or higher)

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

3. **Verify installation**
   ```bash
   clarinet --version
   ```

## 📖 Usage

### Running Clarinet Console

Start the Clarinet REPL to interact with the contract:

```bash
clarinet console
```

### Example Interactions

**Register a household:**
```clarity
(contract-call? .community_waste register-household)
```

**Report waste and pay fee (100 kg waste, 1000 microSTX per kg):**
```clarity
(contract-call? .community_waste report-and-pay u100 u1000)
```

**Check household info:**
```clarity
(contract-call? .community_waste get-household-info tx-sender)
```

**Check token balance:**
```clarity
(contract-call? .community_waste get-balance tx-sender)
```

**Admin withdrawal (admin only):**
```clarity
(contract-call? .community_waste withdraw u1000000)
```

## 🧪 Testing

Run the test suite to verify contract functionality:

```bash
npm test
```

Run tests with coverage report:

```bash
npm run test:report
```

Watch mode for development:

```bash
npm run test:watch
```

## 📁 Project Structure

```
community-waste-collection/
├── Clarinet.toml              # Clarinet project configuration
├── README.md                  # Project documentation
├── contracts/
│   └── community_waste.clar   # Main smart contract
├── settings/
│   ├── Devnet.toml            # Devnet configuration
│   ├── Mainnet.toml           # Mainnet configuration
│   └── Testnet.toml           # Testnet configuration
└── tests/
    └── community_waste.test.ts # Contract tests
```

## 🛠️ Technology Stack

- **Blockchain**: Stacks (Bitcoin Layer 2)
- **Smart Contract Language**: Clarity
- **Development Framework**: Clarinet
- **Testing**: Vitest with Clarinet SDK
- **Package Manager**: npm

## 🤝 Contributing

We welcome contributions! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- All smart contracts must pass `clarinet check`
- All tests must pass (`npm test`)
- Follow existing code style and documentation patterns
- Add tests for new functionality

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  Built with ❤️ for sustainable waste management on the Stacks blockchain
</p>