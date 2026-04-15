# 🌍 Community Waste Collection

A decentralized smart contract system for community waste collection management built on the Stacks blockchain using Clarity smart contracts.

## 📋 Overview

Community Waste Collection is a blockchain-based platform that incentivizes proper waste disposal through a reward token system. Households register with the system, report their waste collection, pay fees in STX, and earn SUSTAIN tokens as rewards.

## ✨ Features

- **Household Registration**: Secure registration system for community households
- **Waste Reporting & Payment**: Report waste in kilograms and pay collection fees in STX
- **Reward Token System**: Earn SUSTAIN fungible tokens based on waste reported (10 tokens per kg)
- **STX Fee Collection**: Transparent fee collection and withdrawal system
- **SIP-010 Compliant**: Fully implements the Stacks fungible token standard

## 🏗️ Architecture

### Smart Contract: `community_waste`

The core smart contract manages:

| Component | Description |
|-----------|-------------|
| **Token System** | SUSTAIN token (SIP-010 compliant) with 6 decimals |
| **Household Registry** | Maps household principals to registration status and stats |
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
```

## 📁 Project Structure

```
community-waste-collection/
├── Clarinet.toml              # Clarinet project configuration
├── README.md                  # This file
├── contracts/
│   └── community_waste.clar   # Main smart contract
├── settings/
│   ├── Devnet.toml           # Devnet configuration
│   ├── Testnet.toml          # Testnet configuration
│   └── Mainnet.toml          # Mainnet configuration
├── tests/
│   └── community_waste.test.ts # Unit tests
└── package.json               # Node.js dependencies
```

## 🚀 Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) - Stacks development environment
- Node.js 18+ (for testing)
- Stacks wallet with STX tokens

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

# Run tests with coverage
npm run test:report

# Watch mode for development
npm run test:watch
```

### Using Clarinet

```bash
# Check contract syntax and types
clarinet check

# Start local devnet
clarinet devnet start

# Open REPL for interactive testing
clarinet console

# Deploy contracts
clarinet deployments generate --testnet
clarinet deployments apply -p deployments/default.testnet-plan.yaml
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

| Function | Description | Parameters |
|----------|-------------|------------|
| `register-household` | Register as a household | None |
| `report-and-pay` | Report waste and pay fee | `waste-kg: uint`, `fee-per-kg: uint` |
| `transfer` | Transfer SUSTAIN tokens (SIP-010) | `amount`, `from`, `to`, `memo` |
| `withdraw` | Withdraw collected STX (owner only) | `amount: uint` |

### Usage Examples

#### Register a Household

```clarity
(contract-call? .community_waste register-household)
;; Returns (ok true) on success, (err u409) if already registered
```

#### Report Waste and Pay

```clarity
;; Report 50kg of waste at 1000 micro-STX per kg
(contract-call? .community_waste report-and-pay u50 u1000)
;; Must attach 50,000 micro-STX (50 * 1000)
;; Returns (ok 50000) and mints 500 SUSTAIN tokens
```

#### Check Household Info

```clarity
(contract-call? .community_waste get-household-info tx-sender)
;; Returns (ok {registered: true, waste-count: u50, paid-stx: u50000})
```

#### Withdraw Fees (Owner Only)

```clarity
(contract-call? .community_waste withdraw u1000000)
;; Transfers 1,000,000 micro-STX to project account
```

## 🔒 Security Considerations

- **Owner Controls**: Only the contract deployer can withdraw collected STX
- **Registration Check**: Waste reporting requires prior household registration
- **STX Validation**: Payment amount is validated before processing
- **Token Standards**: Full SIP-010 compliance for interoperability

## 🧪 Testing

The project includes comprehensive tests using the Clarinet SDK:

```typescript
import { Simnet } from '@hirosystems/clarinet-sdk';

const simnet = await Simnet.fromProject();
const { result } = simnet.callPublicFn('community_waste', 'register-household', [], address);
```

## 📦 Deployment

### Devnet (Local)

```bash
clarinet devnet start
```

### Testnet

```bash
clarinet deployments generate --testnet
clarinet deployments apply -p deployments/default.testnet-plan.yaml
```

### Mainnet

```bash
clarinet deployments generate --mainnet
clarinet deployments apply -p deployments/default.mainnet-plan.yaml
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 👥 Authors

- **itzbayo** - Initial development

## 🙏 Acknowledgments

- [Stacks Foundation](https://www.stacks.co/) for the blockchain platform
- [Hiro Systems](https://www.hiro.so/) for Clarinet and development tools
- Community contributors and testers

---

**Built with ❤️ for sustainable communities**
