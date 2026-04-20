# 🌍 Community Waste Collection

[![Clarinet Check](https://img.shields.io/badge/Clarinet-Passing-brightgreen)](https://github.com/hirosystems/clarinet)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Stacks](https://img.shields.io/badge/Stacks-Blockchain-blue)](https://www.stacks.co/)

A decentralized smart contract system for community waste collection management built on the Stacks blockchain using Clarity smart contracts.

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#️-architecture)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Smart Contract API](#-smart-contract-api)
- [Security Considerations](#-security-considerations)
- [Testing](#-testing)
- [Deployment](#-deployment)
- [Contributing](#-contributing)
- [License](#-license)
- [Authors](#-authors)
- [Acknowledgments](#-acknowledgments)

## 📋 Overview

Community Waste Collection is a blockchain-based platform that incentivizes proper waste disposal through a reward token system. Households register with the system, report their waste collection, pay fees in STX, and earn SUSTAIN tokens as rewards.

This project demonstrates a complete waste management solution leveraging the Stacks blockchain for transparency, immutability, and decentralized governance.

## ✨ Features

| Feature | Description |
|---------|-------------|
| **Household Registration** | Secure registration system for community households with duplicate prevention |
| **Waste Reporting & Payment** | Report waste in kilograms and pay collection fees in STX with automatic validation |
| **Reward Token System** | Earn SUSTAIN fungible tokens based on waste reported (10 tokens per kg) |
| **STX Fee Collection** | Transparent fee collection and owner-only withdrawal system |
| **SIP-010 Compliant** | Fully implements the Stacks fungible token standard for interoperability |
| **Global Analytics** | Track total waste collected and total STX received across all households |

## 🏗️ Architecture

### Smart Contract: `community_waste`

The core smart contract manages:

| Component | Description |
|-----------|-------------|
| **Token System** | SUSTAIN token (SIP-010 compliant) with 6 decimals |
| **Household Registry** | Maps household principals to registration status and statistics |
| **Waste Tracking** | Global counters for total waste collected and STX received |
| **Reward Minting** | Automatic minting of reward tokens upon waste reporting |
| **Admin Controls** | Owner-only withdrawal of collected STX fees |

### Data Structures

```clarity
;; Household information stored per address
{
  registered: bool,    ;; Registration status
  waste-count: uint,   ;; Total waste reported (kg)
  paid-stx: uint       ;; Total STX paid for collection
}

;; Token balances (SIP-010)
(define-map token-balances principal uint)
```

### Constants

| Constant | Value | Description |
|----------|-------|-------------|
| `TOKEN_NAME` | "SUSTAIN Token" | Name of the reward token |
| `TOKEN_SYMBOL` | "SUSTAIN" | Token ticker symbol |
| `TOKEN_DECIMALS` | 6 | Number of decimal places |
| `CONTRACT_OWNER` | tx-sender | Contract deployer (immutable) |
| `PROJECT_ACCOUNT` | ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM | Account for fee withdrawals |

### Error Codes

| Error Code | Value | Description |
|------------|-------|-------------|
| `ERR_NOT_TOKEN_OWNER` | u101 | Caller is not authorized to transfer tokens |
| `ERR_INSUFFICIENT_BALANCE` | u102 | Insufficient token balance |
| `ERR_INVALID_AMOUNT` | u103 | Amount must be greater than zero |
| `ERR_UNAUTHORIZED` | u403 | Only contract owner can call this function |
| `ERR_INSUFFICIENT_CONTRACT_BALANCE` | u404 | Contract has insufficient STX balance |

## 📁 Project Structure

```
community-waste-collection/
├── Clarinet.toml                    # Clarinet project configuration
├── README.md                        # Project documentation
├── contracts/
│   └── community_waste.clar         # Main smart contract (SIP-010 compliant)
├── settings/
│   ├── Devnet.toml                  # Devnet configuration
│   ├── Testnet.toml                 # Testnet configuration
│   └── Mainnet.toml                 # Mainnet configuration
├── tests/
│   └── community_waste.test.ts      # Unit tests (Clarinet SDK)
├── package.json                     # Node.js dependencies
├── tsconfig.json                    # TypeScript configuration
└── vitest.config.js                 # Vitest test configuration
```

## 🚀 Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) v2.0+ - Stacks development environment
- Node.js 18+ (for testing)
- npm or yarn package manager
- Stacks wallet with STX tokens (for mainnet/testnet deployment)

### Installation

```bash
# Clone the repository
git clone https://github.com/itzbayo/community-waste-collection.git
cd community-waste-collection

# Install dependencies
npm install
```

### Running Tests

```bash
# Run all tests
npm test

# Run tests with coverage report
npm run test:report

# Watch mode for development
npm run test:watch
```

### Using Clarinet

```bash
# Check contract syntax and types (must pass without warnings)
clarinet check

# Start local devnet
clarinet devnet start

# Open REPL for interactive testing
clarinet console

# Generate deployment plan
clarinet deployments generate --testnet

# Apply deployment
clarinet deployments apply -p deployments/default.testnet-plan.yaml
```

### Verify Contract

```bash
# Run clarinet check - should pass with no warnings
clarinet check
# Output: ✔ 1 contract checked
```

## 📖 Smart Contract API

### Read-Only Functions

| Function | Description | Returns |
|----------|-------------|---------|
| `get-name` | Get token name | `(response (string-ascii 32) uint)` |
| `get-symbol` | Get token symbol | `(response (string-ascii 10) uint)` |
| `get-decimals` | Get token decimals | `(response uint uint)` |
| `get-balance` | Get token balance for address | `(response uint uint)` |
| `get-total-supply` | Get total token supply | `(response uint uint)` |
| `get-token-uri` | Get token metadata URI | `(response (optional (string-utf8 256)) uint)` |
| `get-household-info` | Get household registration details | `(response (tuple ...) uint)` |
| `get-total-waste-collected` | Get total waste collected (kg) | `(response uint uint)` |
| `get-total-stx-received` | Get total STX collected | `(response uint uint)` |
| `get-contract-owner` | Get contract owner principal | `principal` |

### Public Functions

| Function | Description | Parameters | Returns |
|----------|-------------|------------|---------|
| `register-household` | Register as a household | None | `(response bool uint)` |
| `report-and-pay` | Report waste and pay fee | `waste-kg: uint`, `fee-per-kg: uint` | `(response uint uint)` |
| `transfer` | Transfer SUSTAIN tokens (SIP-010) | `amount: uint`, `from: principal`, `to: principal`, `memo: (optional (buff 34))` | `(response bool uint)` |
| `withdraw` | Withdraw collected STX (owner only) | `amount: uint` | `(response uint uint)` |

### Usage Examples

#### Register a Household

```clarity
(contract-call? .community_waste register-household)
;; Returns (ok true) on success
;; Returns (err u409) if already registered
```

#### Report Waste and Pay

```clarity
;; Report 50kg of waste at 1000 micro-STX per kg (requires 50,000 micro-STX attached)
(contract-call? .community_waste report-and-pay u50 u1000)
;; Returns (ok 50000) and mints 500 SUSTAIN tokens to caller
```

#### Check Household Info

```clarity
(contract-call? .community_waste get-household-info tx-sender)
;; Returns (ok {registered: true, waste-count: u50, paid-stx: u50000})
```

#### Check Token Balance

```clarity
(contract-call? .community_waste get-balance tx-sender)
;; Returns (ok 500) for 500 SUSTAIN tokens
```

#### Transfer Tokens

```clarity
(contract-call? .community_waste transfer u100 tx-sender 'SP2C2H9C4JZX97PYJBE3T38SJCZD57R1HNQZRV5F0 none)
;; Transfers 100 SUSTAIN tokens to recipient
```

#### Withdraw Fees (Owner Only)

```clarity
(contract-call? .community_waste withdraw u1000000)
;; Transfers 1,000,000 micro-STX to project account
;; Only callable by contract owner
```

## 🔒 Security Considerations

| Security Feature | Implementation |
|------------------|----------------|
| **Owner Controls** | Only `CONTRACT_OWNER` (deployer) can call `withdraw` |
| **Registration Check** | `report-and-pay` requires prior household registration |
| **Input Validation** | All amounts validated (> 0) before processing |
| **STX Validation** | Payment transferred before state updates |
| **Token Standards** | Full SIP-010 compliance for interoperability |
| **Balance Checks** | Insufficient balance errors prevent overdrafts |

### Best Practices

1. Always verify registration before reporting waste
2. Attach sufficient STX when calling `report-and-pay`
3. Use `get-balance` to verify token holdings before transfers
4. Only contract owner should call `withdraw`

## 🧪 Testing

The project includes unit tests using the Clarinet SDK and Vitest:

```typescript
import { describe, expect, it } from "vitest";

const accounts = simnet.getAccounts();
const address1 = accounts.get("wallet_1")!;

describe("Community Waste Collection", () => {
  it("ensures simnet is well initialised", () => {
    expect(simnet.blockHeight).toBeDefined();
  });

  it("allows household registration", () => {
    const { result } = simnet.callPublicFn(
      'community_waste', 
      'register-household', 
      [], 
      address1
    );
    expect(result).toBeOk(true);
  });
});
```

Run tests:
```bash
npm test
```

## 📦 Deployment

### Devnet (Local Development)

```bash
# Start devnet
clarinet devnet start

# In another terminal, interact via console
clarinet console
```

### Testnet

```bash
# Generate deployment plan
clarinet deployments generate --testnet

# Apply deployment
clarinet deployments apply -p deployments/default.testnet-plan.yaml
```

### Mainnet

```bash
# Generate deployment plan
clarinet deployments generate --mainnet

# Apply deployment (requires confirmation)
clarinet deployments apply -p deployments/default.mainnet-plan.yaml
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines

- Run `clarinet check` before committing - must pass without warnings
- Add tests for new functionality
- Update README.md for API changes
- Follow Clarity naming conventions (SCREAMING_SNAKE_CASE for constants)

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

```
MIT License

Copyright (c) 2024 itzbayo

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

## 👥 Authors

- **itzbayo** - Initial development and architecture

## 🙏 Acknowledgments

- [Stacks Foundation](https://www.stacks.co/) for the blockchain platform
- [Hiro Systems](https://www.hiro.so/) for Clarinet and development tools
- [Bitcoin](https://bitcoin.org/) for the underlying security model
- Community contributors and testers

---

**Built with ❤️ for sustainable communities**

*Making waste management transparent, incentivized, and decentralized.*
