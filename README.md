<p align="center">
  <a href="https://nika.sh">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://nika.sh/brand/nika-logo-dark.svg">
      <img src="https://nika.sh/brand/nika-logo-light.svg" alt="Nika" width="220">
    </picture>
  </a>
</p>

# nika-estate

**The estate of the Nika ecosystem — every file's provenance, declared,
sealed, anchored. The hundred-year machinery.**

One law governs every artifact in the ecosystem:

> Every artifact is **AUTHORED bytes** or a **proven derivation**
> `(hashed inputs, tool, pin) → output + proof`. The closure of all
> derivations folds to **one root hash** · anchored publicly ·
> verifiable in 2126 with sha256 and a ~100-line script — no living
> institution required, including us.

Most projects answer "where does this file come from?" with tribal
knowledge: a bot someone remembers, a script someone wrote, a pin
someone bumps. The estate answers with a **manifest you re-derive
yourself**: every tracked file in every repo declares its class and its
evidence, derived files carry their derivation (tool · gate · hashed
inputs), and a drift gate re-emits the whole manifest and byte-compares
it on every PR.

## Verify today

The manifests are live in the pilot repos — each one checks in seconds:

```sh
git clone https://github.com/supernovae-st/nika-registry && cd nika-registry
python3 scripts/estate.py --check    # ✓ estate.yaml in sync with the tracked tree
```

Exit 0 is sync · exit 5 is drift · exit 3 (schema 2) is a coverage hole,
listing the uncovered paths. Two runs are byte-identical. The full
contract is in [`SCHEMA.md`](SCHEMA.md).

## The three layers

```
LAYER 1 · THE MANIFEST    estate.yaml, per repo — every tracked file declares
                          its class + the evidence it was read from; derived
                          files carry {tool · gate · hashed inputs}
LAYER 2 · THE ROOT        estate.lock — the closure of every per-repo manifest
                          folds to ONE root hash (lands here · E2)
LAYER 3 · THE ANCHOR      a signed checkpoint per root mutation (minisign ·
                          C2SP note), anchored on public transparency rails
                          (Rekor v2 · RFC 3161) — detection without trust
```

A repo never blocks on the estate: per-repo manifests compose, the root
advances by heal-PR, and a red gate simply means the head does not move.
A projection may be **old, but never wrong** — the system fails closed.

## Current state

| Repo | Manifest | Schema | State |
|---|---|---|---|
| [nika-registry](https://github.com/supernovae-st/nika-registry) | `estate.yaml` | 1 · per-file rows | **merged** |
| [nika](https://github.com/supernovae-st/nika) (engine) | `estate.yaml` | 2 · glob patterns | [PR #689](https://github.com/supernovae-st/nika/pull/689) |
| [nika-docs](https://github.com/supernovae-st/nika-docs) | `estate.yaml` | 1 · per-file rows | [PR #116](https://github.com/supernovae-st/nika-docs/pull/116) |
| [nika.sh](https://github.com/supernovae-st/nika.sh) | `estate.yaml` | — | in flight |

All manifests run in **observation mode**: they declare what IS and
enforce nothing yet. Observation before enforcement — the estate earns
its gate.

## What lands here next

| Piece | What | Phase |
|---|---|---|
| `estate.lock` | the per-repo manifests fold to one signed root hash · checkpoint per mutation | E2 |
| the runner | a `.nika.yaml` derivation engine — the manifests drive re-derivation and heal-PRs, run by the language the estate describes | E1 |
| the minimal verifier | sha256 + ~100 independent lines, **never nika itself** — a proof nobody can re-check by hand is a promise, not a proof | E2+ |
| `SUCCESSION.md` | the succession clause as data — see the [stub](SUCCESSION.md) | pending |

## License

Apache-2.0. The estate describes repos under their own licenses; each
manifest stays inside its repo, under that repo's license.
