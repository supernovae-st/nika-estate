<p align="center">
  <a href="https://nika.sh">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://nika.sh/brand/nika-logo-dark.svg">
      <img src="https://nika.sh/brand/nika-logo-light.svg" alt="Nika" width="220">
    </picture>
  </a>
</p>

# nika-estate

**The estate of the Nika ecosystem: every file's provenance, declared,
sealed, anchored. The hundred-year machinery.**

One law governs every artifact in the ecosystem:

> Every artifact is **AUTHORED bytes** or a **proven derivation**
> `(hashed inputs, tool, pin) → output + proof`. The closure of all
> derivations folds to **one root hash** · anchored publicly ·
> verifiable in 2126 with sha256 and a ~100-line script, no living
> institution required, including us.

Most projects answer "where does this file come from?" with tribal
knowledge: a bot someone remembers, a script someone wrote, a pin
someone bumps. The estate answers with a **manifest you re-derive
yourself**: every tracked file in every repo declares its class and its
evidence, derived files carry their derivation (tool · gate · hashed
inputs), and a drift gate re-emits the whole manifest and byte-compares
it on every PR.

## The tool lives here

[`scripts/estate.py`](scripts/estate.py) is **the** implementation. Every repo
that carries an estate runs a byte-identical copy of it; what stays per-repo is
the data (`scripts/estate_rules.py`: the `FILES` exceptions and the ordered
`PATTERNS`), because that genuinely describes that repo. Dependency-free by
design: the hundred-year machinery has to run on a stock interpreter in 2126,
with no package manager still alive to serve it.

It was not always here. On 2026-07-29 a probe found the tool that enforces
*"every fact has exactly one home"* living in four homes, two of them still on
the previous schema and unable to name two of the law's own classes. The
reconciliation, the proof it produced no unexplained drift, and what each step
cost are in [`MIGRATION.md`](MIGRATION.md).

## It proves it says no

A gate that returns 0 on a clean tree has proven nothing: so does `true`. What
has to be proven is that it returns non-zero on each thing it claims to catch.

```sh
python3 scripts/selftest.py
```

builds a throwaway repository, plants one known violation at a time, and
asserts the verdict: an edited file and an undeclared file are drift (5) · an
uncovered file is a hole that **names** its offender (3) · a seventh class is
refused (3) · missing rules are refused rather than silently declaring an empty
estate (3) · a hand-edited manifest cannot outlive a re-emission (5) · a
projection claim dies with the marker that proved it · duplicate and stale
`files:` rows are caught before anything renders.

The suite is itself mutation-proven, which is the part that matters. Removing
the class validation from the tool kills exactly one case; silencing the
coverage-hole check kills exactly one; making `--check` always return 0 kills
three; restoring the tool byte for byte returns 10 of 10. **A suite that cannot
fail proves nothing.** CI runs it on every push and every pull request.

## One thing still undecided

`files:` rows hash the **real bytes on disk**; pattern aggregates hash the
**git index**. One file's provenance is therefore measured from two different
sources depending on how it happens to be classified, and that asymmetry has
already shipped drift twice: regenerate before staging an edit and the pattern
side cannot see it.

Both sides have a case. Index blobs are platform-independent (a repo with
`.gitattributes text=auto` hands you different working-tree bytes on Windows)
and cost no file reads. Real bytes see the working tree, which is deliberate
for the generator's own row so it can classify itself before being committed.

Picking one costs a single churn of every aggregate in four manifests. Until it
is picked, the discipline is uniform and written down: **stage first, generate
second, `--check` to confirm.**

## Verify today

The manifests are live in the pilot repos; each one checks in seconds:

```sh
git clone https://github.com/supernovae-st/nika-registry && cd nika-registry
python3 scripts/estate.py --check    # ✓ estate.yaml in sync with the tracked tree
```

Exit 0 is sync · exit 5 is drift · exit 3 (schema 2) is a coverage hole,
listing the uncovered paths. Two runs are byte-identical. The full
contract is in [`SCHEMA.md`](SCHEMA.md).

## The three layers

```
LAYER 1 · THE MANIFEST    estate.yaml, per repo · every tracked file declares
                          its class + the evidence it was read from; derived
                          files carry {tool · gate · hashed inputs}
LAYER 2 · THE ROOT        estate.lock · the closure of every per-repo manifest
                          folds to ONE root hash (lands here · E2)
LAYER 3 · THE ANCHOR      a signed checkpoint per root mutation (minisign ·
                          C2SP note), anchored on public transparency rails
                          (Rekor v2 · RFC 3161) · detection without trust
```

A repo never blocks on the estate: per-repo manifests compose, the root
advances by heal-PR, and a red gate simply means the head does not move.
A projection may be **old, but never wrong**: the system fails closed.

## Current state

| Repo | Manifest | Schema | State |
|---|---|---|---|
| [nika-registry](https://github.com/supernovae-st/nika-registry) | `estate.yaml` | 1 · per-file rows | **merged** |
| [nika](https://github.com/supernovae-st/nika) (engine) | `estate.yaml` | 2 · glob patterns | [PR #689](https://github.com/supernovae-st/nika/pull/689) |
| [nika-docs](https://github.com/supernovae-st/nika-docs) | `estate.yaml` | 1 · per-file rows | [PR #116](https://github.com/supernovae-st/nika-docs/pull/116) |
| [nika-spec](https://github.com/supernovae-st/nika-spec) | `estate.yaml` | 2 · glob patterns | [PR #165](https://github.com/supernovae-st/nika-spec/pull/165) |
| [nika.sh](https://github.com/supernovae-st/nika.sh) | `estate.yaml` | 2 · glob patterns | [PR #365](https://github.com/supernovae-st/nika.sh/pull/365) |

All manifests run in **observation mode**: they declare what IS and
enforce nothing yet. Observation before enforcement: the estate earns
its gate.

## What lands here next

| Piece | What | Phase |
|---|---|---|
| `estate.lock` | the per-repo manifests fold to one signed root hash · checkpoint per mutation | E2 |
| the runner | a `.nika.yaml` derivation engine: the manifests drive re-derivation and heal-PRs, run by the language the estate describes | E1 |
| the minimal verifier | sha256 + ~100 independent lines, **never nika itself**: a proof nobody can re-check by hand is a promise, not a proof | E2+ |
| `SUCCESSION.md` | the succession clause as data · see the [stub](SUCCESSION.md) | pending |

## License

Apache-2.0. The estate describes repos under their own licenses; each
manifest stays inside its repo, under that repo's license.

<!-- city:map -->
## The city · where this repo sits

```
📜 nika-spec ──── the civil code · the law tables, the corpus, the exam
    │ sync-pack: byte-gated mirror        │ projectors: drift-gated
    ▼                                     ▼
⚙️ nika ───────── the engine + the catalog (the yellow pages)
    │ the release train                  🖥️ nika.sh · 📖 nika-docs
    ▼                                     the showroom · the manual
📦 homebrew-tap · npm · Docker ── the docks
🔌 nika-client · 🎨 nika-vscode · 🤖 nika-agents · ⚡ gh-nika ── the doors
🏭 nika-action · 🧪 nika-actions-starter ── the CI district
🏪 nika-registry ── the market · 🏛 nika-estate ── the land registry   ◀── you are here
```

**This building** · THE LAND REGISTRY · one law for every artifact in the city: authored bytes, or a proven derivation.

**Root** · the ESTATE root · it owns the six classes, the schema and the succession clause. It owns neither the language nor the engine; it says how every file in every building proves where it came from.

**Consumes** · nothing. It sits upstream of every repository that carries an `estate.yaml`.

**Serves** · every building that runs the drift gate · the anchored root hash that outlives all of us.

**Truth lives** · the manifest is re-emitted and byte-compared on every pull request · exit 0 is sync, exit 5 is drift, exit 3 is a coverage hole. Prose in this repo is never the proof.

All the buildings: [nika-spec](https://github.com/supernovae-st/nika-spec) · [nika](https://github.com/supernovae-st/nika) · [nika.sh](https://github.com/supernovae-st/nika.sh) · [nika-docs](https://github.com/supernovae-st/nika-docs) · [nika-client](https://github.com/supernovae-st/nika-client) · [nika-vscode](https://github.com/supernovae-st/nika-vscode) · [nika-agents](https://github.com/supernovae-st/nika-agents) · [gh-nika](https://github.com/supernovae-st/gh-nika) · [homebrew-tap](https://github.com/supernovae-st/homebrew-tap) · [nika-action](https://github.com/supernovae-st/nika-action) · [nika-actions-starter](https://github.com/supernovae-st/nika-actions-starter) · [nika-registry](https://github.com/supernovae-st/nika-registry) · [nika-estate](https://github.com/supernovae-st/nika-estate)

Every fact has one home · everything else is a gated projection.
The living map: [nika.sh/map](https://nika.sh/map).
<!-- /city:map -->
