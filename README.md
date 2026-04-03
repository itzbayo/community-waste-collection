# Community Waste Collection

A blockchain-based system for managing community waste collection using Stacks blockchain and Clarity smart contracts. Households register, report waste, pay fees in STX, and receive SUSTAIN tokens as rewards for sustainable practices.

## Features

- **Household Registration**: Register to participate in the waste collection program.
- **Waste Reporting**: Report waste collected and pay corresponding STX fee.
- **Reward System**: Receive SUSTAIN tokens for reported waste (10 tokens per kg).
- **Admin Withdrawal**: Project account can withdraw collected STX.
- **FT Standard**: Implements SIP-010 fungible token standard for SUSTAIN token.

## Smart Contract

The main contract is `community_waste.clar` located in the `contracts/` folder.

### Functions

- `register-household`: Register a household.
- `report-and-pay`: Report waste amount and pay fee.
- `withdraw`: Admin function to withdraw STX.
- `get-household-info`: Get household details.
- SIP-010 methods for token.

## Setup

This project uses Clarinet for development and testing.

1. Install dependencies:
   ```
   npm install
   ```

2. Check contracts:
   ```
   clarinet check
   ```

3. Run tests:
   ```
   npm test
   ```

## Deployment

Deploy on Stacks testnet or mainnet using Clarinet or Hiro platform.

## License

MIT

## Contributing

Pull requests welcome. For major changes, please open an issue first.

