# 🌱 Community Waste Collection

[![Clarity](https://img.shields.io/badge/Clarity-3.1-blue)](https://docs.stacks.co/clarity)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](#license)

A decentralized waste collection management system built on the Stacks blockchain. This smart contract enables communities to track waste collection, manage household registrations, process payments in STX, and reward participants with SUSTAIN tokens.

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

## 🌍 Overview

The Community Waste Collection system is designed to incentivize proper waste management through blockchain technology. Households can register on the platform, report their waste collection activities, pay collection fees in STX, and earn SUSTAIN tokens as rewards for participating in the program.

### Problem Statement

Traditional waste management systems often suffer from:
- Lack of transparency in waste collection tracking
- Inefficient payment systems
- No incentives for proper waste disposal
- Difficulty in managing household registrations

### Solution

This decentralized solution provides:
- **Transparent Tracking**: All waste collection data is recorded on-chain
- **Automated Payments**: STX-based fee collection with smart contract escrow
- **Token Rewards**: SUSTAIN token incentives for program participants
- **Decentralized Governance**: No central authority required

## ✨ Features

- 🏠 **Household Registration**: Households can register to participate in the waste collection program
- 📊 **Waste Tracking**: Track waste collection by household and aggregate totals
- 💰 **STX Payments**: Households pay collection fees in STX (micro-STX per kg)
- 🪙 **SUSTAIN Token Rewards**: Earn 10 SUSTAIN tokens per kg of waste reported
- 🔒 **Secure Withdrawals**: Contract owner can withdraw collected STX
- 📈 **SIP-010 Compliant**: SUSTAIN token follows the fungible token standard

## 📜 Smart Contract

The core smart contract is written in Clarity (v3.1) and located at `contracts/community_waste.clar`.

### Contract Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Community Waste Contract                  │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Households │  │   SUSTAIN   │  │   STX Payment       │  │
│  │    Map      │  │    Token    │  │   System            │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Admin Functions (Owner Only)            │   │
│  │  • Withdraw collected STX to project account         │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## 🚀 Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (v18+ recommended)
- [Clarinet](https://github.com/hirosystems/clarinet) (v3.0+)
- Git

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

3. **Verify contract compilation**
   ```bash
   clarinet check
   ```

## 📚 Contract Functions

### Read-Only Functions

| Function | Description |
|----------|-------------|
| `get-name` | Returns the token name ("SUSTAIN Token") |
| `get-symbol` | Returns the token symbol ("SUSTAIN") |
| `get-decimals` | Returns token decimals (6) |
| `get-balance` | Returns token balance for a principal |
| `get-total-supply` | Returns total SUSTAIN token supply |
| `get-token-uri` | Returns token URI (none) |
| `get-household-info` | Returns registration status and stats for a household |
| `get-total-waste-collected` | Returns total waste collected across all households |
| `get-total-stx-received` | Returns total STX received in fees |
| `get-contract-owner` | Returns the contract owner principal |

### Public Functions

| Function | Parameters | Description |
|----------|------------|-------------|
| `register-household` | - | Register caller as a participating household |
| `report-and-pay` | `waste-kg: uint`, `fee-per-kg: uint` | Report waste and pay STX fees. Mints 10 SUSTAIN per kg |
| `transfer` | `amount: uint`, `from: principal`, `to: principal`, `memo: optional` | Transfer SUSTAIN tokens (SIP-010) |
| `withdraw` | `amount: uint` | Withdraw STX from contract (owner only) |

### Usage Examples

**Register a household:**
```clarity
(contract-call? .community_waste register-household)
```

**Report 100kg of waste at 1000 microSTX per kg:**
```clarity
(contract-call? .community_waste report-and-pay u100 u1000)
;; Caller pays 100,000 microSTX and receives 1,000 SUSTAIN tokens
```

**Transfer SUSTAIN tokens:**
```clarity
(contract-call? .community_waste transfer u500 tx-sender 'SP1ABC... none)
```

## 💎 Token Economics

### SUSTAIN Token (SIP-010)

| Property | Value |
|----------|-------|
| Name | SUSTAIN Token |
| Symbol | SUSTAIN |
| Decimals | 6 |
| Reward Rate | 10 SUSTAIN per kg of waste |

### Fee Structure

- Households pay collection fees in STX (micro-STX per kg)
- Fees are held in the contract escrow
- Contract owner can withdraw accumulated fees

### Reward Mechanism

```
SUSTAIN Tokens Earned = Waste (kg) × 10
```

Example: Reporting 50kg of waste earns 500 SUSTAIN tokens.

## 🛠️ Development

### Project Structure

```
community-waste-collection/
├── Clarinet.toml          # Clarinet project configuration
├── README.md              # Project documentation
├── contracts/
│   └── community_waste.clar  # Main smart contract
├── settings/
│   ├── Devnet.toml        # Devnet configuration
│   ├── Testnet.toml       # Testnet configuration
│   └── Mainnet.toml       # Mainnet configuration
├── tests/
│   └── community_waste.test.ts  # Unit tests
├── package.json           # Node.js dependencies
├── tsconfig.json          # TypeScript configuration
└── vitest.config.js       # Test configuration
```

### Available Scripts

| Script | Description |
|--------|-------------|
| `npm test` | Run unit tests |
| `npm run test:watch` | Run tests in watch mode |
| `npm run test:report` | Run tests with coverage report |

## 🧪 Testing

### Run Tests

```bash
npm install
npm test
```

### Test Coverage

The project includes comprehensive unit tests covering:
- Household registration
- Waste reporting and payments
- Token transfers
- Admin functions
- Error handling

### Writing Tests

Tests are written in TypeScript using the Clarinet SDK:

```typescript
import { describe, expect, it } from "vitest";

const accounts = simnet.getAccounts();
const deployer = accounts.get("deployer")!;
const wallet1 = accounts.get("wallet_1")!;

describe("community waste collection", () => {
  it("should register a household", () => {
    const { result } = simnet.callPublicFn(
      "community_waste",
      "register-household",
      [],
      wallet1
    );
    expect(result).toStrictEqual(Cl.bool(true));
  });
});
```

## 🚀 Deployment

### Deploy to Testnet

1. **Configure Testnet settings** in `settings/Testnet.toml`
2. **Deploy the contract**:
   ```bash
   clarinet deployments generate --testnet
   clarinet deployments apply -p deployments/default.testnet-plan.yaml
   ```

### Deploy to Mainnet

1. **Configure Mainnet settings** in `settings/Mainnet.toml`
2. **Deploy the contract**:
   ```bash
   clarinet deployments generate --mainnet
   clarinet deployments apply -p deployments/default.mainnet-plan.yaml
   ```

### Contract Owner

The contract owner is set to the deployer's principal at deployment time. The owner has exclusive access to the `withdraw` function.

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
4. **Run tests**
   ```bash
   npm test
   ```
5. **Run clarinet check**
   ```bash
   clarinet check
   ```
6. **Commit your changes**
   ```bash
   git commit -m "feat: your feature description"
   ```
7. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```
8. **Open a Pull Request**

### Code Style

- Follow Clarity best practices
- Add comments for complex logic
- Write tests for new features
- Ensure `clarinet check` passes with no warnings

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Stacks Foundation](https://www.stacks.co/) for the blockchain platform
- [Hiro Systems](https://www.hiro.so/) for Clarinet and developer tools
- The Clarity community for documentation and support

---

<p align="center">
  <strong>Built with ❤️ for sustainable waste management</strong>
</p>

<p align="center">
  <a href="https://github.com/itzbayo/community-waste-collection">GitHub</a> •
  <a href="https://docs.stacks.co/">Stacks Docs</a> •
  <a href="https://clarity-lang.org/">Clarity</a>
</p>
