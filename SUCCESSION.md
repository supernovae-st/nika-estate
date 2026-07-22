# Succession · the estate survives its maintainer

> Decided 2026-07-22 (operator lock · schema 2, superseding the same-day
> schema-1 second-key design before any key existed) · one of the six
> requirements of the hundred-year machinery (nika-spec timeline ·
> « succession is written down: named successors, key escrow, the project
> survives its maintainer »). This file is DATA: the machine-readable
> clause lives in the `succession:` block below · the prose explains it.

## The clause

```yaml
succession:
  schema: 2
  crypto_scope:
    keys: root (operator, offline) + daily (CI, 1-year rotation, cross-signed)
    third_keys: none                      # nobody else ever holds a key
  continuity:
    kind: vault-letter                    # a sealed instruction letter, vaulted WITH the root paper
    designates: whoever the operator names (changeable by the operator alone, any time)
    effect: lawful access to the vault restores the root · the root certifies
      the continuation keys in-band (the signify chain continues)
  trigger:
    kind: dead-man
    silence_months: 6                     # no signed estate head for 6 months →
    effect_1: the vault-letter channel MAY restore and advance (root-certified continuation)
    silence_months_2: 6                   # 6 further months with no root-certified continuation →
    effect_2: the estate is declared frozen-final · the record stays verifiable forever
    status: pending-legal-review          # the clause becomes BINDING only after counsel review (never a naked filing)
  fork_right:                             # the universal fallback · always available
    clause: any continuation MAY fork from the last witnessed head under NEW
      keys, publishing a signed genesis-of-continuation document · legitimacy
      accrues by adoption · the frozen line stays verifiable forever
  designation_upgrade:
    clause: the root MAY certify a successor key any day (one small ceremony) ·
      re-posed at the second-independent-implementation milestone
  terminal_custodian:
    intent: neutral foundation            # the Rust model, custody moved BEFORE crisis
    review_at: second-independent-implementation milestone
status: keys-pending                      # flips to active at the key ceremony (CEREMONY.md)
```

## Why this shape

- **Two keys, no third** · a decades-long third-party passphrase is the
  likeliest failure in any key system · the vault already held the root
  paper, so the vault IS the succession instrument · a letter designates,
  and a letter is changeable without a ceremony.
- **Dead-man over testament** · mechanical, lawful-by-prepublication in
  intent, requires no heroics at the worst moment, reviewed by counsel
  before it binds.
- **Fork-right written down** · if every channel fails, the world may
  continue from the last witnessed head under new keys, openly declared ·
  the estate never needs permission to survive.
- **Frozen-final is not death** · every proof in the estate verifies
  offline forever (sha256 + a ~100-line script). Succession governs only
  the right to ADVANCE, never the ability to VERIFY.

🦋
