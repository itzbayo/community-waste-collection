# 🌍 Community Waste Collection

![Clarity](https://img.shields.io/badge/Clarity-2.0-blue)
![Stacks](https://img.shields.io/badge/Stacks-Blockchain-orange)
![License](https://img.shields.io/badge/License-MIT-green)

A decentralized waste management system built on the Stacks blockchain that incentivizes proper waste disposal through token rewards. Households register on the platform, report their waste, pay collection fees in STX, and receive SUSTAIN tokens as rewards.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Smart Contract](#smart-contract)
- [Getting Started](#getting-started)
- [Contract Functions](#contract-functions)
- [Tokenomics](#tokenomics)
- [Development](#development)
- [Testing](#testing)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

## 🌟 Overview

Community Waste Collection is a blockchain-based solution that addresses waste management challenges by:

- **Incentivizing proper waste disposal** through token rewards
- **Creating transparent records** of waste collection activities
- **Enabling decentralized governance** through smart contracts
- **Reward households** with SUSTAIN tokens for proper waste management

The platform leverages the Stacks blockchain's security and Bitcoin settlement to provide a trustless, transparent waste management ecosystem.

## ✨ Features

- 🏠 **Household Registration** - Households can register on the platform
- 📊 **Waste Reporting** - Report waste collection with detailed tracking
- 💰 **STX Payment System** - Pay collection fees in STX cryptocurrency
- 🎁 **Token Rewards** - Earn SUSTAIN tokens for waste disposal
- 👤 **Admin Controls** - Contract owner can withdraw collected STX
- 📈 **Analytics** - Track total waste collected and STX received
- 🪙 **SIP-010 Compliant** - SUSTAIN token follows the fungible token standard

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Community Waste Collection                │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ Households  │  │    Admin    │  │      Contract       │  │
│  │  (Users)    │  │   (Owner)   │  │   (Smart Contract)  │  │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘  │
│         │                │                    │             │
│         │ register       │ withdraw           │             │
│         │ report-and-pay │                    │             │
│         ▼                ▼                    ▼             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              Stacks Blockchain (Clarity)             │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   SUSTAIN   │  │    STX      │  │     Households      │  │
│  │   Token     │  │  Payments   │  │       Map           │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## 📜 Smart Contract

The core smart contract is written in Clarity 2.0 and is located at `contracts/community_waste.clar`.

### Contract Structure

| Component | Description |
|-----------|-------------|
| **Token Constants** | SUSTAIN token name, symbol, and decimals |
| **Error Constants** | Defined error codes for various failure cases |
| **Data Variables** | Total supply, waste collected, STX received, contract owner |
| **Maps** | Token balances, household information |
| **Functions** | Registration, payment, withdrawal, token operations |

### Key Data Structures

```clarity
;; Household information
{registered: bool, waste-count: uint, paid-stx: uint}

;; Token balances map
principal -> uint
```

## 🚀 Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) v2.0+
- [Node.js](https://nodejs.org/) v18+
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

### Running Tests

```bash
npm test
```

## 📚 Contract Functions

### Public Functions

| Function | Description | Parameters | Returns |
|----------|-------------|------------|---------|
| `register-household` | Register a new household | None | `(ok true)` or error |
| `report-and-pay` | Report waste and pay STX fee | `waste-kg: uint`, `fee-per-kg: uint` | `(ok required-fee)` or error |
| `transfer` | Transfer SUSTAIN tokens | `amount: uint`, `from: principal`, `to: principal`, `memo: (optional (buff 34))` | `(ok true)` or error |
| `withdraw` | Withdraw collected STX (owner only) | `amount: uint` | `(ok amount)` or error |

### Read-Only Functions

| Function | Description | Parameters | Returns |
|----------|-------------|------------|---------|
| `get-name` | Get token name | None | `(ok "SUSTAIN Token")` |
| `get-symbol` | Get token symbol | None | `(ok "SUSTAIN")` |
| `get-decimals` | Get token decimals | None | `(ok u6)` |
| `get-balance` | Get token balance | `who: principal` | `(ok balance)` |
| `get-total-supply` | Get total token supply | None | `(ok supply)` |
| `get-token-uri` | Get token URI | None | `(ok none)` |
| `get-household-info` | Get household details | `addr: principal` | `(ok entry)` or error |
| `get-total-waste-collected` | Get total waste | None | `(ok total)` |
| `get-total-stx-received` | Get total STX received | None | `(ok total)` |
| `get-contract-owner` | Get contract owner | None | `principal` |

### Error Codes

| Code | Constant | Description |
|------|----------|-------------|
| u100 | `err-owner-only` | Only owner can call |
| u101 | `err-not-token-owner` | Not token owner |
| u102 | `err-insufficient-balance` | Insufficient balance |
| u103 | `err-invalid-amount` | Invalid amount |
| u401 | `err-not-registered` | Household not registered |
| u402 | `err-insufficient-payment` | Insufficient payment |
| u403 | `err-unauthorized` | Unauthorized action |
| u404 | `err-not-found` | Not found |
| u409 | `err-already-registered` | Already registered |

## 🪙 Tokenomics

### SUSTAIN Token

- **Name**: SUSTAIN Token
- **Symbol**: SUSTAIN
- **Decimals**: 6
- **Standard**: SIP-010 (Fungible Token)

### Reward Mechanism

For every 1kg of waste reported, the household receives **10 SUSTAIN tokens**.

```
Reward Tokens = waste_kg × 10
```

### Fee Structure

Households pay collection fees in STX based on:
- Waste amount (kg)
- Fee per kg (micro-STX)

```
Total Fee = waste_kg × fee_per_kg (in micro-STX)
```

### Fund Flow

```
Household → STX Payment → Contract → Admin Withdrawal → Project Account
                    ↓
              Reward Tokens Minted
                    ↓
              Household Balance
```

## 💻 Development

### Project Structure

```
community-waste-collection/
├── Clarinet.toml          # Clarinet configuration
├── README.md              # This file
├── contracts/
│   └── community_waste.clar
├── settings/
│   ├── Devnet.toml
│   ├── Mainnet.toml
│   └── Testnet.toml
├── tests/
│   └── community_waste.test.ts
├── package.json
├── tsconfig.json
└── vitest.config.js
```

### Available Scripts

| Script | Description |
|--------|-------------|
| `npm test` | Run all tests |
| `clarinet check` | Validate contract syntax |
| `clarinet console` | Interactive contract console |
| `clarinet deployments` | Manage deployments |

### Local Development

1. **Start local devnet**
   ```bash
   clarinet devnet start
   ```

2. **Interact with contract**
   ```bash
   clarinet console
   ```

3. **Run tests**
   ```bash
   npm test
   ```

## 🧪 Testing

The project uses the Clarinet SDK with Vitest for testing.

### Running Tests

```bash
npm test
```

### Writing Tests

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
    expect(result).toStrictEqual(Cl.bool(true));
  });
});
```

## 🚀 Deployment

### Testnet Deployment

1. **Configure settings**
   Edit `settings/Testnet.toml` with your account details.

2. **Generate deployment plan**
   ```bash
   clarinet deployments generate --testnet
   ```

3. **Apply deployment**
   ```bash
   clarinet deployments apply -p deployments/default.testnet-plan.yaml
   ```

### Mainnet Deployment

1. **Configure settings**
   Edit `settings/Mainnet.toml` with your account details.

2. **Generate deployment plan**
   ```bash
   clarinet deployments generate --mainnet
   ```

3. **Apply deployment**
   ```bash
   clarinet deployments apply -p deployments/default.mainnet-plan.yaml
   ```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

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

### Code Style

- Follow existing code formatting
- Write clear, descriptive commit messages
- Add tests for new functionality
- Update documentation as needed

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Stacks Foundation](https://www.stacks.co/) for the blockchain platform
- [Hiro Systems](https://www.hiro.so/) for Clarinet and developer tools
- The Clarity community for resources and support

## 📞 Contact

For questions or support, please open an issue on GitHub.

---

**Built with ❤️ for a cleaner planet** 🌍
