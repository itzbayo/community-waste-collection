# Community Waste Collection Smart Contract

A decentralized waste management platform built on the Stacks blockchain that incentivizes proper waste disposal through SUSTAIN token rewards. Households can register, report waste, and earn tokens for responsible waste management while administrators can track collection metrics and manage collected STX fees.

## 🌟 Features

- **Household Registration**: Households can register on the platform to participate in waste collection programs
- **Waste Reporting & Payment**: Registered households report waste in kg and pay collection fees in STX
- **SUSTAIN Token Rewards**: Earn SUSTAIN tokens (10 tokens per kg of waste) for participating
- **SIP-010 Compliant**: Full fungible token implementation following the SIP-010 standard
- **Admin Controls**: Contract owner can withdraw collected STX fees to project account
- **Comprehensive Tracking**: Track total waste collected and total STX received

## 📋 Table of Contents

- [Smart Contract Overview](#smart-contract-overview)
- [Installation](#installation)
- [Usage](#usage)
- [Contract Functions](#contract-functions)
- [Error Codes](#error-codes)
- [Development](#development)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)

## 🔧 Smart Contract Overview

The `community_waste.clar` smart contract implements:

1. **SIP-010 Fungible Token Standard** for SUSTAIN tokens
2. **Household Management System** for waste collection tracking
3. **Fee Collection** in STX with reward token distribution
4. **Admin Withdrawal System** for collected fees

### Token Details

| Property | Value |
|----------|-------|
| Name | SUSTAIN Token |
| Symbol | SUSTAIN |
| Decimals | 6 |
| Reward Rate | 10 tokens per kg of waste |

## 🚀 Installation

### Prerequisites

- Node.js (v18 or higher)
- npm or yarn
- Git

### Clone the Repository

```bash
git clone https://github.com/itzbayo/community-waste-collection.git
cd community-waste-collection
```

### Install Dependencies

```bash
npm install
```

### Install Clarinet

Follow the official Clarinet installation guide:

```bash
curl -sL https://raw.githubusercontent.com/hirosystems/clarinet/main/install.sh | sh -s -- -y
```

Or visit: https://github.com/hirosystems/clarinet#installation

## 📖 Usage

### Register a Household

Households must register before reporting waste:

```clarity
(contract-call? .community_waste register-household)
```

### Report Waste and Pay

Registered households report waste in kilograms and pay fees:

```clarity
(contract-call? .community_waste report-and-pay u10 u1000)
;; Parameters: waste-kg (uint), fee-per-kg (uint in micro-STX)
;; Requires STX to be attached to the transaction
```

### Check Household Info

```clarity
(contract-call? .community_waste get-household-info tx-sender)
```

### Get Global Statistics

```clarity
(contract-call? .community_waste get-total-waste-collected)
(contract-call? .community_waste get-total-stx-received)
```

### SIP-010 Token Functions

```clarity
;; Get token info
(contract-call? .community_waste get-name)
(contract-call? .community_waste get-symbol)
(contract-call? .community_waste get-decimals)
(contract-call? .community_waste get-balance tx-sender)
(contract-call? .community_waste get-total-supply)

;; Transfer tokens
(contract-call? .community_waste transfer u1000 tx-sender recipient none)
```

### Admin: Withdraw Collected Fees

Only the contract deployer can withdraw:

```clarity
(contract-call? .community_waste withdraw u1000000)
;; Parameter: amount (uint in micro-STX)
```

## 📚 Contract Functions

### Public Functions

| Function | Parameters | Description |
|----------|------------|-------------|
| `register-household` | None | Register the caller as a household |
| `report-and-pay` | `waste-kg: uint`, `fee-per-kg: uint` | Report waste and pay STX (requires attached STX) |
| `transfer` | `amount: uint`, `from: principal`, `to: principal`, `memo: (optional (buff 34))` | Transfer SUSTAIN tokens |
| `withdraw` | `amount: uint` | Admin withdraw collected STX (owner only) |

### Read-Only Functions

| Function | Parameters | Description |
|----------|------------|-------------|
| `get-name` | None | Get token name |
| `get-symbol` | None | Get token symbol |
| `get-decimals` | None | Get token decimals |
| `get-balance` | `who: principal` | Get SUSTAIN token balance |
| `get-total-supply` | None | Get total token supply |
| `get-token-uri` | None | Get token URI (returns none) |
| `get-household-info` | `addr: principal` | Get household information |
| `get-total-waste-collected` | None | Get total waste collected |
| `get-total-stx-received` | None | Get total STX received |
| `get-contract-owner` | None | Get contract owner principal |

### SIP-010 Compliance

The contract implements the following SIP-010 standard functions:

- ✅ `get-name` - Returns token name
- ✅ `get-symbol` - Returns token symbol
- ✅ `get-decimals` - Returns decimal places
- ✅ `get-balance` - Returns balance for principal
- ✅ `get-total-supply` - Returns total supply
- ✅ `get-token-uri` - Returns optional URI
- ✅ `transfer` - Transfer tokens between principals

## ⚠️ Error Codes

| Code | Name | Description |
|------|------|-------------|
| u100 | err-owner-only | Only contract owner can perform this action |
| u101 | err-not-token-owner | Not authorized to transfer tokens |
| u102 | err-insufficient-balance | Insufficient token balance |
| u103 | err-invalid-amount | Invalid amount (must be greater than 0) |
| u401 | - | Household not registered |
| u402 | - | Insufficient STX attached |
| u403 | - | Only contract owner can withdraw |
| u404 | - | Insufficient contract balance / Household not found |
| u409 | - | Household already registered |

## 🛠️ Development

### Project Structure

```
community-waste-collection/
├── Clarinet.toml           # Clarinet configuration
├── contracts/
│   └── community_waste.clar # Main smart contract
├── settings/
│   ├── Devnet.toml
│   ├── Mainnet.toml
│   └── Testnet.toml
├── tests/
│   └── community_waste.test.ts  # Unit tests
├── package.json
├── tsconfig.json
├── vitest.config.js
└── README.md
```

### Build and Check

```bash
# Check contract syntax
clarinet check

# Run clarinet console
clarinet console
```

### Run Tests

```bash
# Run all tests
npm test

# Run tests with coverage
npm run test:report

# Watch mode
npm run test:watch
```

## 🧪 Testing

The project includes comprehensive test coverage using the Clarinet SDK and Vitest:

```bash
npm test
```

Test categories include:
- Token SIP-010 function tests
- Household registration tests
- Report and pay functionality tests
- Global statistics tests
- Contract owner tests
- Withdrawal authorization tests

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style

- Follow existing Clarity code conventions
- Add tests for new functionality
- Update documentation for any new features

## 📄 License

This project is licensed under the ISC License - see the [package.json](package.json) for details.

## 🔗 Resources

- [Stacks Documentation](https://docs.stacks.co/)
- [Clarity Language Reference](https://docs.stacks.co/clarity)
- [SIP-010 Fungible Token Standard](https://github.com/stacksgov/sips/blob/main/sips/sip-010/sip-010-fungible-token-standard.md)
- [Clarinet Documentation](https://github.com/hirosystems/clarinet)

## 👤 Author

Built with ❤️ for sustainable waste management on the Stacks blockchain.

---

**Note**: This contract is deployed on the Stacks blockchain. Always verify contract addresses and test thoroughly on testnet before mainnet deployment.
