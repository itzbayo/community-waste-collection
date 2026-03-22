;; Community Waste Collection Smart Contract
;; Implements SIP-010 fungible token standard for SUSTAIN tokens
;; Households register, report waste, pay STX fees, and receive SUSTAIN token rewards

;; ---------------------------------------------
;; SIP-010 Fungible Token Implementation
;; ---------------------------------------------

(define-constant token-name "SUSTAIN Token")
(define-constant token-symbol "SUSTAIN")
(define-constant token-decimals u6)

;; Error constants
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant err-insufficient-balance (err u102))
(define-constant err-invalid-amount (err u103))
(define-constant err-already-registered (err u409))
(define-constant err-not-registered (err u401))
(define-constant err-insufficient-payment (err u402))
(define-constant err-insufficient-contract-balance (err u404))

;; Data variables
(define-data-var total-supply uint u0)
(define-data-var total-waste-collected uint u0)
(define-data-var total-stx-received uint u0)
(define-data-var contract-owner principal tx-sender)

;; Token balances map
(define-map token-balances principal uint)

;; Map each household to its info: registered, waste-count, paid-stx
(define-map households
  {address: principal}
  {registered: bool, waste-count: uint, paid-stx: uint})

;; ---------------------------------------------
;; SIP-010 Fungible Token Functions
;; ---------------------------------------------

(define-read-only (get-name)
  (ok token-name))

(define-read-only (get-symbol)
  (ok token-symbol))

(define-read-only (get-decimals)
  (ok token-decimals))

(define-read-only (get-balance (who principal))
  (ok (default-to u0 (map-get? token-balances who))))

(define-read-only (get-total-supply)
  (ok (var-get total-supply)))

(define-read-only (get-token-uri)
  (ok none))

(define-public (transfer (amount uint) (from principal) (to principal) (memo (optional (buff 34))))
  (begin
    (asserts! (or (is-eq from tx-sender) (is-eq from contract-caller)) err-not-token-owner)
    (asserts! (> amount u0) err-invalid-amount)
    (let ((from-balance (default-to u0 (map-get? token-balances from))))
      (asserts! (>= from-balance amount) err-insufficient-balance)
      (map-set token-balances from (- from-balance amount))
      (map-set token-balances to (+ (default-to u0 (map-get? token-balances to)) amount)))
    (print memo)
    (ok true)))

;; Private function to mint tokens
(define-private (mint-to (recipient principal) (amount uint))
  (begin
    (asserts! (> amount u0) err-invalid-amount)
    (let ((current-balance (default-to u0 (map-get? token-balances recipient))))
      (map-set token-balances recipient (+ current-balance amount))
      (var-set total-supply (+ (var-get total-supply) amount))
      (ok true))))

;; ---------------------------------------------
;; Public read-only getters
;; ---------------------------------------------
(define-read-only (get-household-info (addr principal))
  (match (map-get? households {address: addr})
    entry (ok entry)
    (err u404)))

(define-read-only (get-total-waste-collected)
  (ok (var-get total-waste-collected)))

(define-read-only (get-total-stx-received)
  (ok (var-get total-stx-received)))

;; ---------------------------------------------
;; Registration: add household to system
;; ---------------------------------------------
(define-public (register-household)
  (let ((caller tx-sender))
    (match (map-get? households {address: caller})
      some-entry (err u409)  ;; Already registered
      (begin
        (map-set households {address: caller} {registered: true, waste-count: u0, paid-stx: u0})
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
      (asserts! (> waste-kg u0) err-invalid-amount)
      (asserts! (> fee-per-kg u0) err-invalid-amount)
      
      ;; Must be registered
      (match (map-get? households {address: caller})
        entry
        (begin
          ;; Transfer STX payment to contract
          (try! (stx-transfer? required-fee caller (as-contract tx-sender)))

          ;; Update household record
          (let (
               (new-waste (+ (get waste-count entry) waste-kg))
               (new-paid (+ (get paid-stx entry) required-fee)))
            (map-set households {address: caller}
                     {registered: true, waste-count: new-waste, paid-stx: new-paid}))

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
(define-constant project-account 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)

(define-public (withdraw (amount uint))
  (begin
    ;; Only contract deployer can call
    (asserts! (is-eq tx-sender (var-get contract-owner)) err-owner-only)
    ;; Must have enough STX in contract
    (let ((balance (stx-get-balance (as-contract tx-sender))))
      (asserts! (>= balance amount) err-insufficient-contract-balance))
    ;; Transfer
    (try! (as-contract (stx-transfer? amount tx-sender project-account)))
    (ok amount)))

;; ---------------------------------------------
;; Utility: get contract owner
;; ---------------------------------------------
(define-read-only (get-contract-owner)
  (var-get contract-owner))
