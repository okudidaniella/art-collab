# Art-Collab: Collaborative Artwork Royalties Contract

A Clarity smart contract for automatically distributing NFT royalties among collaborators based on predefined shares.

## Overview

Art-Collab enables artists to create collaborative artworks with automatic royalty distribution. When royalties are received, they are automatically distributed to all collaborators based on their ownership shares, eliminating the need for manual calculations and payments.

## Features

- **Multi-Collaborator Support**: Support for 1-3 collaborators per artwork (easily extensible)
- **Automatic Royalty Distribution**: Fair distribution based on predefined shares
- **Pending Withdrawal System**: Secure two-step withdrawal process
- **Flexible Share Management**: Creators can update collaborator shares
- **Artwork Management**: Activate/deactivate artworks for royalty distribution

## Contract Functions

### Public Functions

#### Creating Artworks

**`create-artwork-simple`**
```clarity
(create-artwork-simple title collaborator-1 shares-1)
```
Creates an artwork with a single collaborator.

**`create-artwork-duo`**
```clarity
(create-artwork-duo title collaborator-1 shares-1 collaborator-2 shares-2)
```
Creates an artwork with two collaborators.

**`create-artwork-trio`**
```clarity
(create-artwork-trio title collaborator-1 shares-1 collaborator-2 shares-2 collaborator-3 shares-3)
```
Creates an artwork with three collaborators.

#### Royalty Management

**`add-royalty-funds`**
```clarity
(add-royalty-funds amount)
```
Adds STX funds to the contract for royalty distribution.

**`distribute-royalties`**
```clarity
(distribute-royalties artwork-id)
```
Distributes all contract funds to collaborators of the specified artwork based on their shares. Only callable by the contract owner or artwork creator.

**`withdraw-royalties`**
```clarity
(withdraw-royalties)
```
Allows collaborators to withdraw their pending royalty payments.

#### Administrative Functions

**`update-collaborator-shares`**
```clarity
(update-collaborator-shares artwork-id collaborator new-shares)
```
Updates a collaborator's share allocation. Only callable by the artwork creator.

**`deactivate-artwork`**
```clarity
(deactivate-artwork artwork-id)
```
Deactivates an artwork, stopping future royalty distributions. Only callable by the contract owner or artwork creator.

### Read-Only Functions

- `get-artwork-info(artwork-id)` - Get artwork details
- `get-collaborator-shares(artwork-id, collaborator)` - Get specific collaborator's shares
- `get-pending-withdrawal(collaborator)` - Get pending withdrawal amount for a collaborator
- `get-contract-balance()` - Get current contract STX balance
- `get-next-artwork-id()` - Get the next artwork ID to be assigned
- `get-artwork-collaborators(artwork-id)` - Get all collaborators for an artwork

## Usage Example

### 1. Create a Collaborative Artwork

```clarity
;; Create artwork with two collaborators
(contract-call? .art-collab create-artwork-duo 
  "Digital Masterpiece #1" 
  'SP1ABC...ARTIST1 
  u60  ;; 60% share
  'SP2DEF...ARTIST2 
  u40) ;; 40% share
```

### 2. Add Royalty Funds

```clarity
;; Add 1000 microSTX to contract for distribution
(contract-call? .art-collab add-royalty-funds u1000000)
```

### 3. Distribute Royalties

```clarity
;; Distribute royalties for artwork ID 1
(contract-call? .art-collab distribute-royalties u1)
```

### 4. Withdraw Royalties

```clarity
;; Collaborator withdraws their pending royalties
(contract-call? .art-collab withdraw-royalties)
```

## Data Structure

### Artwork Information
```clarity
{
  title: (string-ascii 100),
  creator: principal,
  total-shares: uint,
  collaborator-count: uint,
  is-active: bool
}
```

### Collaborator Shares
```clarity
{
  artwork-id: uint,
  collaborator: principal,
  shares: uint
}
```

## Error Codes

- `u100` - Owner only operation
- `u101` - Not authorized
- `u102` - Artwork not found
- `u103` - Invalid shares
- `u104` - Collaborator not found
- `u105` - Insufficient balance
- `u106` - Artwork already exists
- `u107` - Invalid collaborators

## Security Features

- **Access Control**: Only authorized users can perform sensitive operations
- **Input Validation**: All inputs are validated before processing
- **Pending Withdrawal System**: Two-step withdrawal process prevents double-spending
- **Deactivation Protection**: Artworks can be deactivated to stop distributions

## Limitations

- Maximum of 10 collaborators per artwork (currently implemented for 3)
- Fixed collaborator slots (not dynamically expandable)
- Shares must be positive integers
- Only STX token support

## Deployment

Deploy this contract to the Stacks blockchain using the Clarity CLI or Clarinet:

```bash
clarinet deploy --network testnet
```

## Testing

Test the contract using Clarinet:

```bash
clarinet test
```

## License

This smart contract is provided as-is for educational and commercial use.

## Contributing

Contributions are welcome! Please ensure all tests pass before submitting pull requests.

---

**Note**: This contract handles financial transactions. Please thoroughly test on testnet before mainnet deployment.