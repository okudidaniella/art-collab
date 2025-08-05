;; Art-Collab: Collaborative Artwork Royalties Contract
;; Automatically distributes NFT royalties among collaborators

;; Contract constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-authorized (err u101))
(define-constant err-artwork-not-found (err u102))
(define-constant err-invalid-shares (err u103))
(define-constant err-collaborator-not-found (err u104))
(define-constant err-insufficient-balance (err u105))
(define-constant err-artwork-exists (err u106))
(define-constant err-invalid-collaborators (err u107))

;; Data variables
(define-data-var next-artwork-id uint u1)

;; Data maps
;; Map to store artwork information
(define-map artworks
  { artwork-id: uint }
  {
    title: (string-ascii 100),
    creator: principal,
    total-shares: uint,
    collaborator-count: uint,
    is-active: bool
  }
)

;; Map to store collaborator shares for each artwork
(define-map collaborator-shares
  { artwork-id: uint, collaborator: principal }
  { shares: uint }
)

;; Map to store collaborators list for each artwork (up to 10 collaborators)
(define-map artwork-collaborators
  { artwork-id: uint }
  {
    collab-0: (optional principal),
    collab-1: (optional principal),
    collab-2: (optional principal),
    collab-3: (optional principal),
    collab-4: (optional principal),
    collab-5: (optional principal),
    collab-6: (optional principal),
    collab-7: (optional principal),
    collab-8: (optional principal),
    collab-9: (optional principal)
  }
)

;; Map to store pending withdrawals for each collaborator
(define-map pending-withdrawals
  { collaborator: principal }
  { amount: uint }
)

;; Private helper functions

;; Add pending withdrawal amount
(define-private (add-pending-withdrawal (collaborator principal) (amount uint))
  (let (
    (current-pending (default-to u0 (get amount (map-get? pending-withdrawals { collaborator: collaborator }))))
  )
    (map-set pending-withdrawals
      { collaborator: collaborator }
      { amount: (+ current-pending amount) }
    )
  )
)

;; Public functions

;; Create a new collaborative artwork (simplified version with 1 collaborator)
(define-public (create-artwork-simple (title (string-ascii 100)) (collaborator-1 principal) (shares-1 uint))
  (let (
    (artwork-id (var-get next-artwork-id))
  )
    ;; Validate inputs
    (asserts! (> shares-1 u0) err-invalid-shares)
    
    ;; Create artwork entry
    (map-set artworks
      { artwork-id: artwork-id }
      {
        title: title,
        creator: tx-sender,
        total-shares: shares-1,
        collaborator-count: u1,
        is-active: true
      }
    )
    
    ;; Set collaborator shares
    (map-set collaborator-shares
      { artwork-id: artwork-id, collaborator: collaborator-1 }
      { shares: shares-1 }
    )
    
    ;; Set collaborators list
    (map-set artwork-collaborators
      { artwork-id: artwork-id }
      {
        collab-0: (some collaborator-1),
        collab-1: none,
        collab-2: none,
        collab-3: none,
        collab-4: none,
        collab-5: none,
        collab-6: none,
        collab-7: none,
        collab-8: none,
        collab-9: none
      }
    )
    
    ;; Increment artwork ID for next artwork
    (var-set next-artwork-id (+ artwork-id u1))
    
    (ok artwork-id)
  )
)

;; Create artwork with 2 collaborators
(define-public (create-artwork-duo (title (string-ascii 100)) (collaborator-1 principal) (shares-1 uint) (collaborator-2 principal) (shares-2 uint))
  (let (
    (artwork-id (var-get next-artwork-id))
    (total-shares (+ shares-1 shares-2))
  )
    ;; Validate inputs
    (asserts! (and (> shares-1 u0) (> shares-2 u0)) err-invalid-shares)
    
    ;; Create artwork entry
    (map-set artworks
      { artwork-id: artwork-id }
      {
        title: title,
        creator: tx-sender,
        total-shares: total-shares,
        collaborator-count: u2,
        is-active: true
      }
    )
    
    ;; Set collaborator shares
    (map-set collaborator-shares
      { artwork-id: artwork-id, collaborator: collaborator-1 }
      { shares: shares-1 }
    )
    (map-set collaborator-shares
      { artwork-id: artwork-id, collaborator: collaborator-2 }
      { shares: shares-2 }
    )
    
    ;; Set collaborators list
    (map-set artwork-collaborators
      { artwork-id: artwork-id }
      {
        collab-0: (some collaborator-1),
        collab-1: (some collaborator-2),
        collab-2: none,
        collab-3: none,
        collab-4: none,
        collab-5: none,
        collab-6: none,
        collab-7: none,
        collab-8: none,
        collab-9: none
      }
    )
    
    ;; Increment artwork ID
    (var-set next-artwork-id (+ artwork-id u1))
    
    (ok artwork-id)
  )
)

;; Create artwork with 3 collaborators
(define-public (create-artwork-trio (title (string-ascii 100)) (collaborator-1 principal) (shares-1 uint) (collaborator-2 principal) (shares-2 uint) (collaborator-3 principal) (shares-3 uint))
  (let (
    (artwork-id (var-get next-artwork-id))
    (total-shares (+ (+ shares-1 shares-2) shares-3))
  )
    ;; Validate inputs
    (asserts! (and (and (> shares-1 u0) (> shares-2 u0)) (> shares-3 u0)) err-invalid-shares)
    
    ;; Create artwork entry
    (map-set artworks
      { artwork-id: artwork-id }
      {
        title: title,
        creator: tx-sender,
        total-shares: total-shares,
        collaborator-count: u3,
        is-active: true
      }
    )
    
    ;; Set collaborator shares
    (map-set collaborator-shares
      { artwork-id: artwork-id, collaborator: collaborator-1 }
      { shares: shares-1 }
    )
    (map-set collaborator-shares
      { artwork-id: artwork-id, collaborator: collaborator-2 }
      { shares: shares-2 }
    )
    (map-set collaborator-shares
      { artwork-id: artwork-id, collaborator: collaborator-3 }
      { shares: shares-3 }
    )
    
    ;; Set collaborators list
    (map-set artwork-collaborators
      { artwork-id: artwork-id }
      {
        collab-0: (some collaborator-1),
        collab-1: (some collaborator-2),
        collab-2: (some collaborator-3),
        collab-3: none,
        collab-4: none,
        collab-5: none,
        collab-6: none,
        collab-7: none,
        collab-8: none,
        collab-9: none
      }
    )
    
    ;; Increment artwork ID
    (var-set next-artwork-id (+ artwork-id u1))
    
    (ok artwork-id)
  )
)

;; Distribute royalties to all collaborators of an artwork
(define-public (distribute-royalties (artwork-id uint))
  (let (
    (artwork-info (unwrap! (map-get? artworks { artwork-id: artwork-id }) err-artwork-not-found))
    (contract-balance (stx-get-balance (as-contract tx-sender)))
    (total-shares (get total-shares artwork-info))
    (collaborators (unwrap! (map-get? artwork-collaborators { artwork-id: artwork-id }) err-artwork-not-found))
  )
    ;; Only allow contract owner or artwork creator to distribute
    (asserts! (or (is-eq tx-sender contract-owner) (is-eq tx-sender (get creator artwork-info))) err-not-authorized)
    (asserts! (get is-active artwork-info) err-artwork-not-found)
    (asserts! (> contract-balance u0) err-insufficient-balance)
    
    ;; Distribute to each collaborator based on their shares
    (match (get collab-0 collaborators)
      collab-0 (let (
        (shares-0 (default-to u0 (get shares (map-get? collaborator-shares { artwork-id: artwork-id, collaborator: collab-0 }))))
        (amount-0 (/ (* contract-balance shares-0) total-shares))
      )
        (add-pending-withdrawal collab-0 amount-0)
      )
      true
    )
    
    (match (get collab-1 collaborators)
      collab-1 (let (
        (shares-1 (default-to u0 (get shares (map-get? collaborator-shares { artwork-id: artwork-id, collaborator: collab-1 }))))
        (amount-1 (/ (* contract-balance shares-1) total-shares))
      )
        (add-pending-withdrawal collab-1 amount-1)
      )
      true
    )
    
    (match (get collab-2 collaborators)
      collab-2 (let (
        (shares-2 (default-to u0 (get shares (map-get? collaborator-shares { artwork-id: artwork-id, collaborator: collab-2 }))))
        (amount-2 (/ (* contract-balance shares-2) total-shares))
      )
        (add-pending-withdrawal collab-2 amount-2)
      )
      true
    )
    
    (match (get collab-3 collaborators)
      collab-3 (let (
        (shares-3 (default-to u0 (get shares (map-get? collaborator-shares { artwork-id: artwork-id, collaborator: collab-3 }))))
        (amount-3 (/ (* contract-balance shares-3) total-shares))
      )
        (add-pending-withdrawal collab-3 amount-3)
      )
      true
    )
    
    (ok true)
  )
)

;; Withdraw pending royalties
(define-public (withdraw-royalties)
  (let (
    (pending-amount (default-to u0 (get amount (map-get? pending-withdrawals { collaborator: tx-sender }))))
  )
    (asserts! (> pending-amount u0) err-insufficient-balance)
    
    ;; Reset pending withdrawal
    (map-delete pending-withdrawals { collaborator: tx-sender })
    
    ;; Transfer STX to collaborator
    (try! (as-contract (stx-transfer? pending-amount tx-sender tx-sender)))
    
    (ok pending-amount)
  )
)

;; Add funds to contract (for royalty distribution)
(define-public (add-royalty-funds (amount uint))
  (begin
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    (ok true)
  )
)

;; Update collaborator shares (only creator can do this)
(define-public (update-collaborator-shares (artwork-id uint) (collaborator principal) (new-shares uint))
  (let (
    (artwork-info (unwrap! (map-get? artworks { artwork-id: artwork-id }) err-artwork-not-found))
    (current-shares (default-to u0 (get shares (map-get? collaborator-shares { artwork-id: artwork-id, collaborator: collaborator }))))
  )
    ;; Only artwork creator can update shares
    (asserts! (is-eq tx-sender (get creator artwork-info)) err-not-authorized)
    
    ;; Update collaborator shares
    (map-set collaborator-shares
      { artwork-id: artwork-id, collaborator: collaborator }
      { shares: new-shares }
    )
    
    ;; Update total shares in artwork
    (map-set artworks
      { artwork-id: artwork-id }
      (merge artwork-info { total-shares: (+ (- (get total-shares artwork-info) current-shares) new-shares) })
    )
    
    (ok true)
  )
)

;; Deactivate artwork (stops royalty distribution)
(define-public (deactivate-artwork (artwork-id uint))
  (let (
    (artwork-info (unwrap! (map-get? artworks { artwork-id: artwork-id }) err-artwork-not-found))
  )
    ;; Only creator or contract owner can deactivate
    (asserts! (or (is-eq tx-sender contract-owner) (is-eq tx-sender (get creator artwork-info))) err-not-authorized)
    
    (map-set artworks
      { artwork-id: artwork-id }
      (merge artwork-info { is-active: false })
    )
    
    (ok true)
  )
)

;; Read-only functions

;; Get artwork information
(define-read-only (get-artwork-info (artwork-id uint))
  (map-get? artworks { artwork-id: artwork-id })
)

;; Get collaborator shares for an artwork
(define-read-only (get-collaborator-shares (artwork-id uint) (collaborator principal))
  (map-get? collaborator-shares { artwork-id: artwork-id, collaborator: collaborator })
)

;; Get pending withdrawals for a collaborator
(define-read-only (get-pending-withdrawal (collaborator principal))
  (map-get? pending-withdrawals { collaborator: collaborator })
)

;; Get contract balance
(define-read-only (get-contract-balance)
  (stx-get-balance (as-contract tx-sender))
)

;; Get next artwork ID
(define-read-only (get-next-artwork-id)
  (var-get next-artwork-id)
)

;; Get all collaborators for an artwork
(define-read-only (get-artwork-collaborators (artwork-id uint))
  (map-get? artwork-collaborators { artwork-id: artwork-id })
)