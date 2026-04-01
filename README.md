# 🏭 Community Waste Collection

![Clarity](https://img.shields.io/badge/Clarity-2.4-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Status](https://img.shields.io/badge/Status-Active-success.svg)

A decentralized waste management platform built on the Stacks blockchain that incentivizes proper waste disposal through SUSTAIN token rewards. Households register, report waste collection, pay STX fees, and earn fungible token rewards.

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Smart Contract Architecture](#-smart-contract-architecture)
- [Getting Started](#-getting-started)
- [Installation](#-installation)
- [Usage](#-usage)
- [API Reference](#-api-reference)
- [Testing](#-testing)
- [Deployment](#-deployment)
- [Project Structure](#-project-structure)
- [Contributing](#-contributing)
- [License](#-license)

## 🌟 Overview

Community Waste Collection is a blockchain-based solution designed to revolutionize waste management in communities. By leveraging the Stacks blockchain and Clarity smart contracts, this platform provides:

- **Transparent Waste Tracking**: Immutable records of waste collection data
- **Incentive Mechanism**: SUSTAIN token rewards for proper waste disposal
- **Fee Collection**: STX-based fee system for waste collection services
- **Decentralized Governance**: Contract-owned fund management

### The Problem

Traditional waste management systems lack transparency, accountability, and incentive structures for proper waste disposal. Communities often struggle with:

- Unreliable waste collection records
- Lack of motivation for proper waste segregation
- Difficulty tracking waste generation patterns
- Inefficient fee collection and fund management

### The Solution

Our smart contract provides a complete decentralized waste management ecosystem:

1. **Households** register on the platform
2. **Report waste** and pay collection fees in STX
3. **Receive SUSTAIN tokens** as rewards (10 tokens per kg of waste)
4. **Tokens** can be traded or used within the ecosystem

## ✨ Features

| Feature | Description |
|---------|-------------|
| **SIP-010 Compliant** | Full implementation of the Stacks fungible token standard |
| **Household Registration** | Secure principal-based household registration system |
| **Waste Reporting** | Track waste collection with detailed records per household |
| **STX Fee Collection** | Automated fee collection in micro-STX per kg of waste |
| **Token Rewards** | Automatic minting of SUSTAIN tokens (10x waste kg) |
| **Admin Withdrawals** | Secure fund withdrawal by contract owner |
| **Data Analytics** | Track total waste collected and STX received |

## 🏗️ Smart Contract Architecture

### Contract: `community_waste.clar`

The main smart contract implements both the SIP-010 fungible token standard and the waste collection business logic.

#### Data Structures

```clarity
;; Token balances for SIP-010 compliance
(define-map token-balances principal uint)

;; Household registration and tracking
(define-map households
  {address: principal}
  {registered: bool, waste-count: uint, paid-stx: uint})

;; Global statistics
(define-data-var total-waste-collected uint u0)
(define-data-var total-stx-received uint u0)
(define-data-var total-supply uint u0)
(define-data-var contract-owner principal tx-sender)
```

#### Error Codes

| Code | Constant | Description |
|------|----------|-------------|
| u100 | `err-owner-only` | Only contract owner can call |
| u101 | `err-not-token-owner` | Not authorized for token transfer |
| u102 | `err-insufficient-balance` | Insufficient token balance |
| u103 | `err-invalid-amount` | Invalid amount (zero or less) |
| u401 | `err-not-registered` | Household not registered |
| u402 | `err-insufficient-payment` | Insufficient STX payment |
| u404 | `err-insufficient-contract-balance` | Insufficient contract STX balance |
| u409 | `err-already-registered` | Household already registered |

### Workflow Diagram

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  Register       │     │  Report Waste    │     │  Receive Tokens │
│  Household      │────▶│  & Pay STX       │────▶│  (10x waste kg) │
│                 │     │                  │     │                 │
└─────────────────┘     └──────────────────┘     └─────────────────┘
        │                        │                        │
        ▼                        ▼                        ▼
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  households     │     │  STX → Contract  │     │  token-balances │
│  map updated    │     │  Globals updated │     │  map updated    │
└─────────────────┘     └──────────────────┘     └─────────────────┘
```

## 🚀 Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) v2.0+
- [Node.js](https://nodejs.org/) v18+
- [npm](https://www.npmjs.com/) or [yarn](https://yarnpkg.com/)

### Quick Start

```bash
# Clone the repository
git clone https://github.com/itzbayo/community-waste-collection.git
cd community-waste-collection

# Install dependencies
npm install

# Run clarinet checks
clarinet check

# Run tests
npm test
```

## 📦 Installation

### 1. Install Clarinet

```bash
# macOS (via Homebrew)
brew install clarinet

# Linux
curl -L https://github.com/hirosystems/clarinet/releases/download/v2.5.1/clarinet-linux-x64-glibc.tar.gz | tar xz
sudo mv clarinet /usr/local/bin/

# Verify installation
clarinet --version
```

### 2. Clone Repository

```bash
git clone https://github.com/itzbayo/community-waste-collection.git
cd community-waste-collection
```

### 3. Install Dependencies

```bash
npm install
```

## 💡 Usage

### Local Development

```bash
# Start Clarinet console for interactive testing
clarinet console

# In the console:
>> (contract-call? .community_waste register-household)
>> (contract-call? .community_waste report-and-pay u10 u1000)
>> (contract-call? .community_waste get-household-info tx-sender)
```

### Contract Interaction Examples

#### Register a Household

```clarity
;; Register the caller as a household
(contract-call? .community_waste register-household)
;; Returns: (ok true)
```

#### Report Waste and Pay

```clarity
;; Report 10 kg of waste at 1000 microSTX per kg
;; Must attach 10000 microSTX (10 * 1000)
(contract-call? .community_waste report-and-pay u10 u1000)
;; Returns: (ok u10000)
;; Also mints: 100 SUSTAIN tokens (10 * 10)
```

#### Query Household Info

```clarity
;; Get info for a specific principal
(contract-call? .community_waste get-household-info 'SP...)
;; Returns: (ok {registered: true, waste-count: u10, paid-stx: u10000})
```

#### Transfer SUSTAIN Tokens

```clarity
;; Transfer 50 SUSTAIN tokens
(contract-call? .community_waste transfer u50 tx-sender 'SP... none)
;; Returns: (ok true)
```

#### Admin: Withdraw STX

```clarity
;; Contract owner withdraws collected fees
(contract-call? .community_waste withdraw u1000000)
;; Returns: (ok u1000000)
```

## 📚 API Reference

### SIP-010 Token Functions

| Function | Type | Description |
|----------|------|-------------|
| `get-name` | read-only | Returns token name "SUSTAIN Token" |
| `get-symbol` | read-only | Returns token symbol "SUSTAIN" |
| `get-decimals` | read-only | Returns decimals (6) |
| `get-balance` | read-only | Returns balance for a principal |
| `get-total-supply` | read-only | Returns total token supply |
| `get-token-uri` | read-only | Returns token URI (none) |
| `transfer` | public | Transfers tokens between principals |

### Waste Collection Functions

| Function | Type | Parameters | Description |
|----------|------|------------|-------------|
| `register-household` | public | - | Register caller as household |
| `report-and-pay` | public | `waste-kg`, `fee-per-kg` | Report waste, pay STX, receive tokens |
| `get-household-info` | read-only | `addr` | Get household registration and stats |
| `get-total-waste-collected` | read-only | - | Get total waste collected |
| `get-total-stx-received` | read-only | - | Get total STX received |
| `withdraw` | public | `amount` | Admin withdraw of collected STX |

### Utility Functions

| Function | Type | Description |
|----------|------|-------------|
| `get-contract-owner` | read-only | Returns the contract deployer |

## 🧪 Testing

### Run All Tests

```bash
npm test
```

### Run Tests in Watch Mode

```bash
npm test -- --watch
```

### Test Coverage

The test suite covers:

- ✅ Household registration
- ✅ Duplicate registration prevention
- ✅ Waste reporting and STX payment
- ✅ Token minting verification
- ✅ Global statistics tracking
- ✅ Authorization checks
- ✅ SIP-010 token transfers

### Writing Tests

Tests are located in `tests/community_waste.test.ts`:

```typescript
import { describe, expect, it } from "vitest";
import { Cl } from "@stacks/transactions";

const accounts = simnet.getAccounts();
const deployer = accounts.get("deployer")!;

describe("community_waste", () => {
  it("should register a household", () => {
    const { result } = simnet.callPublicFn(
      "community_waste",
      "register-household",
      [],
      deployer
    );
    expect(result).toStrictEqual(Cl.ok(Cl.bool(true)));
  });
});
```

## 🚀 Deployment

### Devnet Deployment

```bash
# Start devnet
clarinet devnet start
```

### Testnet Deployment

1. Update `settings/Testnet.toml` with your private key
2. Configure contract deployment settings
3. Run deployment:

```bash
clarinet deployments generate --testnet
clarinet deployments apply -p deployments/default.testnet-plan.yaml
```

### Mainnet Deployment

1. Update `settings/Mainnet.toml` with your private key
2. Review security checklist
3. Deploy:

```bash
clarinet deployments generate --mainnet
clarinet deployments apply -p deployments/default.mainnet-plan.yaml
```

### Security Considerations

- ✅ Contract owner is set at deployment time
- ✅ All public functions have proper authorization checks
- ✅ Input validation on all parameters
- ✅ Overflow protection through Clarity's uint type
- ✅ SIP-010 standard compliance for token interoperability

## 📁 Project Structure

```
community-waste-collection/
├── Clarinet.toml              # Clarinet configuration
├── README.md                  # This file
├── package.json               # Node.js dependencies
├── contracts/
│   └── community_waste.clar   # Main smart contract
├── settings/
│   ├── Devnet.toml            # Devnet settings
│   ├── Testnet.toml           # Testnet settings
│   └── Mainnet.toml           # Mainnet settings
└── tests/
    └── community_waste.test.ts # Test suite
```

## 🔧 Configuration

### Clarinet.toml

```toml
[project]
name = 'community_waste_collection'
clarity_version = 2
epoch = 2.4

[contracts.community_waste]
path = 'contracts/community_waste.clar'
```

### Token Economics

| Parameter | Value | Description |
|-----------|-------|-------------|
| Token Name | SUSTAIN Token | Platform utility token |
| Token Symbol | SUSTAIN | Trading symbol |
| Decimals | 6 | Micro-token precision |
| Reward Rate | 10x waste kg | Tokens minted per kg |
| Project Account | Configurable | STX withdrawal destination |

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines

- Follow Clarity best practices
- Write tests for new functionality
- Update documentation
- Run `clarinet check` before committing
- Ensure all tests pass

### Code Style

- Use descriptive function and variable names
- Add comments for complex logic
- Follow the existing file structure
- Keep functions focused and single-purpose

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Stacks Foundation](https://www.stacks.co/) for the blockchain infrastructure
- [Hiro Systems](https://www.hiro.so/) for Clarinet and development tools
- [SIP-010](https://github.com/stacksgov/sips/blob/main/sips/sip-010/sip-010-fungible-token-standard.md) for the fungible token standard

## 📞 Contact

For questions or support:

- **GitHub Issues**: [Open an issue](https://github.com/itzbayo/community-waste-collection/issues)
- **Email**: [Project maintainer]

---

<p align="center">
  Built with ❤️ on the Stacks Blockchain
</p>

<p align="center">
  <a href="#-community-waste-collection">Back to Top ↑</a>
</p>
