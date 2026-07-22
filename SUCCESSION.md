# Succession · the estate survives its maintainer

> Decided 2026-07-22 (operator lock c·a·a) · one of the six requirements of
> the hundred-year machinery (nika-spec timeline · « succession is written
> down: named successors, key escrow, the project survives its maintainer »).
> This file is DATA — the machine-readable clause lives in the `succession:`
> block below · the prose explains it.

## The clause

```yaml
succession:
  schema: 1
  second_key:
    holder: Nicolas (co-founder)          # certified in-band: keys/estate-succession.pub.minisig (cross-signed by root)
    escrow: sealed paper backup, vaulted  # the loss arm — protects against loss, the holder against incapacity
  trigger:
    kind: dead-man
    silence_months: 6                     # no root/daily-signed estate head for 6 months →
    effect_1: succession key MAY advance the estate head
    silence_months_2: 6                   # 6 further months of silence →
    effect_2: the estate is declared frozen-final — the record stays verifiable forever
    status: pending-legal-review          # the clause becomes BINDING only after counsel review (never a naked filing)
  terminal_custodian:
    intent: neutral foundation            # the Rust model — custody moved BEFORE crisis
    review_at: second-independent-implementation milestone
status: keys-pending                      # flips to active at the key ceremony (CEREMONY.md)
```

## Why this shape

- **Two arms for two failure modes** · the sealed backup answers LOSS ·
  the second keyholder answers INCAPACITY. Either alone is a gap.
- **Dead-man over testament** · mechanical, lawful-by-prepublication in
  intent, requires no heroics at the worst moment — reviewed by counsel
  before it binds.
- **Frozen-final is not death** · every proof in the estate verifies
  offline forever (sha256 + a ~100-line script). Succession governs only
  the right to ADVANCE — never the ability to VERIFY.

🦋
