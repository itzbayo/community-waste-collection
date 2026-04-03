(impl-trait 'SP2C2H9C4JZX97PYJBE3T38SJCZD57R1HNQZRV5F0.fungible-token::fungible-token-standard)  ;; customize with your principal

(define-constant token-name (string-ascii 32 "SUSTAIN Token"))
(define-constant token-symbol (string-ascii 6 "SUSTAIN"))
(define-constant token-decimals u6)

(define-data-var total-waste-collected uint u0)
(define-data-var total-stx-received uint u0)

;; Map each household to its info: registered, waste-count, paid-stx
(define-map households
  ((address principal))
  ((registered bool) (waste-count uint) (paid-stx uint)))

;; ---------------------------------------------
;; Public read-only getters
;; ---------------------------------------------
(define-read-only (get-household-info (addr principal))
  (match (map-get? households {address: addr})
    entry entry
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
    (begin
      (match (map-get? households {address: caller})
        some _ (err u409)  ;; Already registered
        none
        (begin
          (map-set households {address: caller} {registered: true, waste-count: u0, paid-stx: u0})
          (ok true))))))

;; ---------------------------------------------
;; Report waste and pay STX
;; - amount: amount of waste in kg (uint)
;; - fee-per-kg: fee rate in micro-STX per kg
;; STX must be attached
;; ---------------------------------------------
(define-public (report-and-pay (waste-kg uint) (fee-per-kg uint))
  (let (
        (caller tx-sender)
        (required-fee (* waste-kg fee-per-kg)))
    (begin
      ;; Must be registered
      (match (map-get? households {address: caller})
        none (err u401)
        some entry
        (begin
          ;; Check attached STX
          (asserts! (>= (stx-get-spent) required-fee) (err u402))

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

          (ok required-fee)))))))

;; ---------------------------------------------
;; Admin function: withdraw collected STX to project account
;; ---------------------------------------------
(define-constant project-account 'SP3FBR2AGK7NZX1M4YXYRSBNPK7EDD1XT31X7FYYP)

(define-public (withdraw (amount uint))
  (begin
    ;; Only contract deployer can call
    (asserts! (is-eq tx-sender (contract-owner)) (err u403))
    ;; Must have enough STX in contract
    (let ((balance (stx-get-balance (as-contract))))
      (asserts! (>= balance amount) (err u404)))
    ;; Transfer
    (try! (stx-transfer? amount (as-contract) project-account))
    (ok amount)))

;; ---------------------------------------------
;; Utility: get contract owner
;; ---------------------------------------------
(define-read-only (contract-owner)
  tx-sender)
