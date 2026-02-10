# Community Waste Collection Smart Contract

[![Clarity](https://img.shields.io/badge/Clarity-2.0-blue)](https://clarity-lang.org/)
[![Stacks](https://img.shields.io/badge/Stacks-Blockchain-orange)](https://www.stacks.co/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A decentralized community waste collection management system built on the Stacks blockchain using Clarity smart contracts. This project incentivizes proper waste disposal through a tokenized reward system.

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#-architecture)
- [Smart Contract Functions](#-smart-contract-functions)
- [Getting Started](#-getting-started)
- [Testing](#-testing)
- [Deployment](#-deployment)
- [Security Considerations](#-security-considerations)
- [Contributing](#-contributing)
- [License](#-license)

## 🌍 Overview

The Community Waste Collection smart contract creates a transparent and incentive-driven waste management system. Households can register, report their waste collection, pay associated fees in STX, and earn SUSTAIN tokens as rewards for their participation in responsible waste disposal.

### Problem Statement

Traditional waste management systems lack:
- Transparency in fee collection and usage
- Incentives for households to participate actively
- Immutable records of waste collection data
- Community engagement mechanisms

### Solution

This smart contract addresses these issues by:
- Recording all transactions on the Stacks blockchain
- Rewarding participants with fungible SUSTAIN tokens
- Maintaining transparent records of waste collection
- Enabling decentralized community waste management

## ✨ Features

- **Household Registration**: Households can register to participate in the waste collection program
- **Waste Reporting & Payment**: Report waste quantities and pay collection fees in STX
- **Token Rewards**: Earn SUSTAIN tokens (10 tokens per kg of waste) as incentives
- **SIP-010 Compliant Token**: SUSTAIN token follows the fungible token standard
- **Transparent Tracking**: View total waste collected and STX received by the system
- **Admin Controls**: Secure withdrawal function for project funds

## 🏗 Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Community Waste Contract              │
├─────────────────────────────────────────────────────────┤
│  Token Layer (SIP-010 Compliant)                        │
│  ├── SUSTAIN Token (6 decimals)                         │
│  ├── Transfer functionality                             │
│  └── Balance tracking                                   │
├─────────────────────────────────────────────────────────┤
│  Household Management                                    │
│  ├── Registration system                                │
│  ├── Waste count tracking                               │
│  └── Payment history                                    │
├─────────────────────────────────────────────────────────┤
│  Admin Functions                                         │
│  ├── STX withdrawal                                     │
│  └── Owner verification                                 │
└─────────────────────────────────────────────────────────┘
```

## 📜 Smart Contract Functions

### Read-Only Functions

| Function | Description | Returns |
|----------|-------------|---------|
| `get-name` | Get token name | `(ok "SUSTAIN Token")` |
| `get-symbol` | Get token symbol | `(ok "SUSTAIN")` |
| `get-decimals` | Get token decimals | `(ok u6)` |
| `get-balance (who)` | Get token balance for address | `(ok uint)` |
| `get-total-supply` | Get total token supply | `(ok uint)` |
| `get-token-uri` | Get token URI | `(ok none)` |
| `get-household-info (addr)` | Get household registration info | `(ok {registered, waste-count, paid-stx})` or `(err u404)` |
| `get-total-waste-collected` | Get total waste collected (kg) | `(ok uint)` |
| `get-total-stx-received` | Get total STX received | `(ok uint)` |
| `get-contract-owner` | Get contract owner address | `principal` |

### Public Functions

| Function | Description | Parameters |
|----------|-------------|------------|
| `register-household` | Register caller as participant | None |
| `report-and-pay` | Report waste and pay fee | `waste-kg: uint, fee-per-kg: uint` |
| `transfer` | Transfer SUSTAIN tokens | `amount: uint, from: principal, to: principal, memo: optional buff` |
| `withdraw` | Admin: withdraw STX to project account | `amount: uint` |

### Error Codes

| Code | Meaning |
|------|---------|
| `u100` | Owner only operation |
| `u101` | Not token owner |
| `u102` | Insufficient balance |
| `u103` | Invalid amount |
| `u401` | Not registered |
| `u403` | Unauthorized |
| `u404` | Not found |
| `u409` | Already registered |

## 🚀 Getting Started

### Prerequisites

- [Clarinet](https://docs.hiro.so/clarinet) (v2.4.0 or higher)
- [Node.js](https://nodejs.org/) (v18 or higher)
- [npm](https://www.npmjs.com/) or [yarn](https://yarnpkg.com/)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/itzbayo/community-waste-collection.git
   cd community-waste-collection
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Verify the smart contract:
   ```bash
   clarinet check
   ```

### Project Structure

```
community-waste-collection/
├── contracts/
│   └── community_waste.clar    # Main smart contract
├── tests/
│   └── community_waste.test.ts # Unit tests
├── settings/
│   ├── Devnet.toml            # Devnet configuration
│   ├── Testnet.toml           # Testnet configuration
│   └── Mainnet.toml           # Mainnet configuration
├── Clarinet.toml              # Clarinet project configuration
├── package.json               # Node.js dependencies
├── vitest.config.js           # Test configuration
└── README.md                  # This file
```

## 🧪 Testing

### Run All Tests

```bash
npm test
```

### Run Tests with Coverage

```bash
npm run coverage
```

### Interactive Console

Launch the Clarinet console for interactive testing:

```bash
clarinet console
```

Example console commands:
```clarity
;; Register a household
(contract-call? .community_waste register-household)

;; Check household info
(contract-call? .community_waste get-household-info tx-sender)

;; Report waste and pay
(contract-call? .community_waste report-and-pay u10 u100)

;; Check token balance
(contract-call? .community_waste get-balance tx-sender)
```

## 🌐 Deployment

### Devnet Deployment

```bash
clarinet devnet start
```

### Testnet Deployment

1. Configure your wallet in `settings/Testnet.toml`
2. Ensure you have testnet STX
3. Deploy:
   ```bash
   clarinet deploy --testnet
   ```

### Mainnet Deployment

1. Configure your wallet in `settings/Mainnet.toml`
2. Ensure you have mainnet STX for deployment fees
3. Deploy:
   ```bash
   clarinet deploy --mainnet
   ```

## 🔐 Security Considerations

### Implemented Security Measures

- **Owner-Only Functions**: Withdrawal restricted to contract owner
- **Registration Checks**: Only registered households can report waste
- **Balance Verification**: Checks for sufficient STX before transfers
- **Input Validation**: Validates amounts are greater than zero

### Recommendations for Production

1. **Multi-Signature**: Consider implementing multi-sig for admin functions
2. **Rate Limiting**: Add limits on waste reporting frequency
3. **Maximum Values**: Implement caps on single transaction amounts
4. **Audit**: Conduct a professional security audit before mainnet deployment
5. **Upgrade Path**: Consider implementing a contract upgrade mechanism

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Make your changes
4. Run tests:
   ```bash
   npm test
   clarinet check
   ```
5. Commit your changes:
   ```bash
   git commit -m "feat: add your feature description"
   ```
6. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
7. Open a Pull Request

### Commit Message Convention

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `test:` Test additions/modifications
- `refactor:` Code refactoring
- `chore:` Maintenance tasks

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Contact

For questions, suggestions, or collaboration opportunities:

- **GitHub Issues**: [Create an issue](https://github.com/itzbayo/community-waste-collection/issues)
- **Pull Requests**: Contributions are welcome!

## 🙏 Acknowledgments

- [Stacks Foundation](https://stacks.org/) for the blockchain infrastructure
- [Hiro Systems](https://hiro.so/) for Clarinet and development tools
- The Clarity community for documentation and support

---

**Built with ❤️ for sustainable communities on the Stacks blockchain**
