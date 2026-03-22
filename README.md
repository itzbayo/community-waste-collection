# 🗑️ Community Waste Collection

[![Clarity](https://img.shields.io/badge/Clarity-2.0-blue.svg)](https://clarity-lang.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Tests](https://img.shields.io/badge/Tests-Passing-success.svg)](#testing)

A decentralized community waste management platform built on the Stacks blockchain. This smart contract enables households to register, report waste collection, pay collection fees in STX, and earn SUSTAIN reward tokens.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Smart Contract Architecture](#smart-contract-architecture)
- [Getting Started](#getting-started)
- [Contract Functions](#contract-functions)
- [Error Codes](#error-codes)
- [Testing](#testing)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

## 🌟 Overview

Community Waste Collection is a blockchain-based solution for managing community waste collection services. The platform incentivizes proper waste disposal by rewarding participating households with SUSTAIN tokens, while tracking waste collection metrics and managing fee collection transparently.

### How It Works

1. **Registration**: Households register on the platform via `register-household`
2. **Report & Pay**: Registered households report waste and pay collection fees in STX via `report-and-pay`
3. **Earn Rewards**: For every kg of waste reported, households earn 10 SUSTAIN tokens
4. **Withdrawals**: Contract owner can withdraw collected STX fees to the project account

## ✨ Features

- ✅ **SIP-010 Compliant**: Full implementation of the Stacks fungible token standard
- ✅ **Household Registry**: Track registered households and their waste collection history
- ✅ **Fee Collection**: Automated STX fee collection for waste collection services
- ✅ **Reward System**: Mint SUSTAIN tokens as rewards for waste reporting
- ✅ **Admin Controls**: Owner-only withdrawal and ownership transfer functions
- ✅ **Comprehensive Testing**: Unit tests using Clarinet SDK

## 🏗️ Smart Contract Architecture

### Data Structures

| Structure | Description |
|-----------|-------------|
| `token-balances` | Maps principal to token balance (SUSTAIN tokens) |
| `households` | Maps principal to household info (registered, waste-count, paid-stx) |

### Data Variables

| Variable | Description |
|----------|-------------|
| `total-supply` | Total SUSTAIN tokens in circulation |
| `total-waste-collected` | Total waste collected across all households (kg) |
| `total-stx-received` | Total STX fees collected |
| `contract-owner` | Principal address of contract owner |

### Token Details

| Property | Value |
|----------|-------|
| Name | SUSTAIN Token |
| Symbol | SUSTAIN |
| Decimals | 6 |
| Reward Rate | 10 tokens per kg of waste |

## 🚀 Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (v18 or higher)
- [Clarinet](https://github.com/hirosystems/clarinet) (v2.0 or higher)
- [Git](https://git-scm.com/)

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

3. **Run tests**
   ```bash
   npm test
   ```

4. **Check contract syntax**
   ```bash
   clarinet check
   ```

### Development with Clarinet Console

```bash
# Start Clarinet console for interactive testing
clarinet console

# Inside the console:
# Register a household
(contract-call? .community_waste register-household)

# Report waste and pay (e.g., 5kg at 1000 microSTX per kg)
(contract-call? .community_waste report-and-pay u5 u1000)
```

## 📝 Contract Functions

### Public Functions

| Function | Parameters | Description |
|----------|------------|-------------|
| `register-household` | None | Register the caller as a household |
| `report-and-pay` | `waste-kg: uint`, `fee-per-kg: uint` | Report waste and pay STX fees |
| `transfer` | `amount: uint`, `sender: principal`, `recipient: principal`, `memo: optional` | Transfer SUSTAIN tokens (SIP-010) |
| `withdraw` | `amount: uint` | Withdraw STX to project account (owner only) |
| `transfer-ownership` | `new-owner: principal` | Transfer contract ownership (owner only) |

### Read-Only Functions

| Function | Parameters | Description |
|----------|------------|-------------|
| `get-name` | None | Get token name (SIP-010) |
| `get-symbol` | None | Get token symbol (SIP-010) |
| `get-decimals` | None | Get token decimals (SIP-010) |
| `get-balance` | `who: principal` | Get SUSTAIN token balance (SIP-010) |
| `get-total-supply` | None | Get total token supply (SIP-010) |
| `get-token-uri` | None | Get token metadata URI (SIP-010) |
| `get-household-info` | `addr: principal` | Get household registration info |
| `get-total-waste-collected` | None | Get total waste collected |
| `get-total-stx-received` | None | Get total STX received |
| `get-contract-owner` | None | Get current contract owner |

## ❌ Error Codes

| Code | Constant | Description |
|------|----------|-------------|
| u100 | `err-owner-only` | Only contract owner can call this function |
| u101 | `err-not-token-owner` | Sender is not authorized to transfer tokens |
| u102 | `err-insufficient-balance` | Insufficient token balance |
| u103 | `err-invalid-amount` | Amount must be greater than zero |
| u401 | `err-not-registered` | Household is not registered |
| u402 | `err-insufficient-payment` | Insufficient STX payment |
| u404 | `err-insufficient-contract-balance` | Contract has insufficient STX balance |
| u409 | `err-already-registered` | Household is already registered |

## 🧪 Testing

### Run All Tests

```bash
npm test
```

### Run Tests with Coverage

```bash
npm run test:report
```

### Watch Mode

```bash
npm run test:watch
```

### Test Structure

Tests are located in `tests/community_waste.test.ts` and use the Clarinet SDK with Vitest:

```typescript
import { describe, expect, it } from "vitest";

const accounts = simnet.getAccounts();
const address1 = accounts.get("wallet_1")!;

describe("Community Waste Collection", () => {
  it("should register a household", () => {
    const { result } = simnet.callPublicFn(
      "community_waste",
      "register-household",
      [],
      address1
    );
    expect(result).toStrictEqual(Cl.ok(Cl.bool(true)));
  });
});
```

## 📦 Deployment

### Devnet Deployment

```bash
# Start local devnet
clarinet devnet start
```

### Testnet/Mainnet Deployment

1. **Configure deployment settings** in `settings/Testnet.toml` or `settings/Mainnet.toml`

2. **Generate deployment plan**
   ```bash
   clarinet deployments generate --testnet
   ```

3. **Apply deployment**
   ```bash
   clarinet deployments generate --testnet --apply
   ```

### Contract Address

After deployment, the contract will be available at:
```
{DEPLOYER_ADDRESS}.community_waste
```

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
   clarinet check
   ```
5. **Commit your changes**
   ```bash
   git commit -m "feat: add your feature description"
   ```
6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Create a Pull Request**

### Code Standards

- Follow Clarity best practices
- Add unit tests for new functionality
- Ensure `clarinet check` passes without errors
- Update documentation as needed

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Clarinet](https://github.com/hirosystems/clarinet) by Hiro
- Stacks blockchain ecosystem
- Community waste management initiatives worldwide

---

<p align="center">
  Made with ❤️ for cleaner communities
</p>