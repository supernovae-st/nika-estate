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
three; reverting the index read to a disk read kills the case that guards
it, and restoring the tool byte for byte returns 12 of 12. **A suite that cannot
fail proves nothing.** CI runs it on every push and every pull request.

## One question, one answer

Every hash in the manifest now asks git the same thing: **what will you
record?** The index answers that. The disk does not.

It used to be split. A `files:` row hashed the bytes on disk while a pattern
aggregate hashed the blob git had staged, so the same file gave two different
answers depending on how it happened to be classified. That shipped drift
twice in a single day: regenerate before staging an edit and the pattern side
simply could not see it.

The manifest reads the index throughout, and when the disk says something
else the tool says so rather than measuring a tree you are not about to
commit:

```
estate.py: the manifest describes the INDEX, and your disk says something else:
  modified, not staged  scripts/estate_rules.py
  untracked             docs/new-page.md
  stage them first if they belong in this manifest (git add), then re-run.
```

Two properties worth knowing. On a clean tree the index and the disk agree, so
this changed **nothing**: re-deriving `nika`, `nika-docs` and `nika-registry`
moved zero lines. `nika-spec` moved nine, and the *old* tool moves the same
nine on the same clone, so those are its own pre-existing drift rather than
anything this introduced. And the warning is silent on a normal regeneration, including for `estate.yaml`
itself, which `--write` modifies by definition and which would otherwise
complain on every single run.

The generator still falls back to the disk for a path the index does not carry
yet, which is how it classifies itself before it has ever been added.
