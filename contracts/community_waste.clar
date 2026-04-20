;; Community Waste Collection Smart Contract
;; Implements SIP-010 fungible token standard for SUSTAIN tokens

;; Token constants
(define-constant TOKEN_NAME "SUSTAIN Token")
(define-constant TOKEN_SYMBOL "SUSTAIN")
(define-constant TOKEN_DECIMALS u6)

;; Error constants
(define-constant ERR_NOT_TOKEN_OWNER (err u101))
(define-constant ERR_INSUFFICIENT_BALANCE (err u102))
(define-constant ERR_INVALID_AMOUNT (err u103))
(define-constant ERR_UNAUTHORIZED (err u403))

(define-constant ERR_INSUFFICIENT_CONTRACT_BALANCE (err u404))

;; Data variables
(define-data-var total-supply uint u0)
(define-data-var total-waste-collected uint u0)
(define-data-var total-stx-received uint u0)
(define-constant CONTRACT_OWNER tx-sender)

;; Maps
(define-map token-balances principal uint)

;; Map each household to its info: registered, waste-count, paid-stx
(define-map households
  { address: principal }
  { registered: bool, waste-count: uint, paid-stx: uint })

;; Project account for withdrawals (devnet deployer)
(define-constant PROJECT_ACCOUNT 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)

;; ---------------------------------------------
;; SIP-010 Fungible Token Functions
;; ---------------------------------------------

(define-read-only (get-name)
  (ok TOKEN_NAME))

(define-read-only (get-symbol)
  (ok TOKEN_SYMBOL))

(define-read-only (get-decimals)
  (ok TOKEN_DECIMALS))

(define-read-only (get-balance (who principal))
  (ok (default-to u0 (map-get? token-balances who))))

(define-read-only (get-total-supply)
  (ok (var-get total-supply)))

(define-read-only (get-token-uri)
  (ok none))

(define-public (transfer (amount uint) (from principal) (to principal) (memo (optional (buff 34))))
  (begin
    (asserts! (or (is-eq from tx-sender) (is-eq from contract-caller)) ERR_NOT_TOKEN_OWNER)
    (asserts! (> amount u0) ERR_INVALID_AMOUNT)
    (let ((from-balance (default-to u0 (map-get? token-balances from))))
      (asserts! (>= from-balance amount) ERR_INSUFFICIENT_BALANCE)
      (map-set token-balances from (- from-balance amount))
      (let ((to-balance (default-to u0 (map-get? token-balances to))))
        (map-set token-balances to (+ to-balance amount))))
    (print { event: "transfer", sender: from, recipient: to, amount: amount, memo: memo })
    (ok true)))

;; Private function to mint tokens
(define-private (mint-to (recipient principal) (amount uint))
  (begin
    (asserts! (> amount u0) ERR_INVALID_AMOUNT)
    (let ((current-balance (default-to u0 (map-get? token-balances recipient))))
      (map-set token-balances recipient (+ current-balance amount))
      (var-set total-supply (+ (var-get total-supply) amount))
      (ok true))))

;; ---------------------------------------------
;; Public read-only getters
;; ---------------------------------------------
(define-read-only (get-household-info (addr principal))
  (match (map-get? households { address: addr })
    entry (ok entry)
    (err u404)))

(define-read-only (get-total-waste-collected)
  (ok (var-get total-waste-collected)))

(define-read-only (get-total-stx-received)
  (ok (var-get total-stx-received)))

(define-read-only (get-contract-owner)
  CONTRACT_OWNER)

;; ---------------------------------------------
;; Registration: add household to system
;; ---------------------------------------------
(define-public (register-household)
  (let ((caller tx-sender))
    (match (map-get? households { address: caller })
      some-entry (err u409)
      (begin
        (map-set households { address: caller } { registered: true, waste-count: u0, paid-stx: u0 })
        (ok true)))))

;; ---------------------------------------------
;; Report waste and pay STX
;; - waste-kg: amount of waste in kg (uint)
;; - fee-per-kg: fee rate in micro-STX per kg
;; STX must be attached
;; ---------------------------------------------
(define-public (report-and-pay (waste-kg uint) (fee-per-kg uint))
  (let (
        (caller tx-sender)
        (required-fee (* waste-kg fee-per-kg)))
    (begin
      ;; Validate inputs
      (asserts! (> waste-kg u0) ERR_INVALID_AMOUNT)
      (asserts! (> fee-per-kg u0) ERR_INVALID_AMOUNT)
      (match (map-get? households { address: caller })
        entry
        (begin
          ;; Transfer STX payment to contract
          (try! (stx-transfer? required-fee caller (as-contract tx-sender)))

          ;; Update household record
          (let (
               (new-waste (+ (get waste-count entry) waste-kg))
               (new-paid (+ (get paid-stx entry) required-fee)))
            (map-set households { address: caller }
                     { registered: true, waste-count: new-waste, paid-stx: new-paid }))

          ;; Update globals
          (var-set total-waste-collected (+ (var-get total-waste-collected) waste-kg))
          (var-set total-stx-received (+ (var-get total-stx-received) required-fee))

          ;; Mint reward tokens equal to waste-kg * 10
          (try! (mint-to caller (* waste-kg u10)))

          (ok required-fee))
        (err u401)))))

;; ---------------------------------------------
;; Admin function: withdraw collected STX to project account
;; ---------------------------------------------
(define-public (withdraw (amount uint))
  (begin
    ;; Only contract deployer can call
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    ;; Must have enough STX in contract
    (let ((balance (stx-get-balance (as-contract tx-sender))))
      (asserts! (>= balance amount) ERR_INSUFFICIENT_CONTRACT_BALANCE))
    ;; Transfer
    (try! (as-contract (stx-transfer? amount tx-sender PROJECT_ACCOUNT)))
    (ok amount)))
