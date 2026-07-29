# Migration · one tool, four repos

> Written 2026-07-29, after a probe found the tool that enforces
> *"every fact has exactly one home"* living in **four** homes.

## What the probe found

`scripts/estate.py` existed in four repositories. Not four copies: four
divergent forks.

| repo | lines | schema | classes it can express |
|---|---|---|---|
| `nika` | 475 | **2** | all six |
| `nika-spec` | 566 | **2** | all six |
| `nika-registry` | 321 | **1** | four (no `authored-pin`, no `testimonial`) |
| `nika-docs` | 270 | **1** | four |

Half the ecosystem was applying a superseded schema and could not *name* two
of the law's classes. Files that are testimonials in those repos are
classified as something else, because the vocabulary to say otherwise was
not there.

Three different wordings of `pinned-copy` and `testimonial` were live at the
same time: one in `SCHEMA.md`, one in each schema-2 pilot. The law had forked
against itself.

## What the probe also found, which was better news

Split each schema-2 file into its tool and its data, and the picture changes:

```
nika/scripts/estate.py       191 lines of tool  +  227 lines of FILES/PATTERNS
nika-spec/scripts/estate.py  191 lines of tool  +  320 lines of FILES/PATTERNS
```

The two tools differ by **one line**: the hardcoded `repo:` slug. Everything
else, all 191 lines, is byte-identical. This was never a design divergence.
It was copy-paste, and copy-paste is mechanical to undo.

## The shape

```
nika-estate/scripts/estate.py     THE tool · one home · mirrored byte-gated
    │
    ├── CLASSES                   the law's vocabulary, verbatim from SCHEMA.md
    ├── _repo_slug()              derived from the origin remote, never typed
    └── _load_rules()             imports the consuming repo's data, refuses to run without it

<any repo>/scripts/estate.py       byte-identical mirror · editing it is a lost gesture
<any repo>/scripts/estate_rules.py FILES + PATTERNS · authored · genuinely per-repo
<any repo>/estate.yaml             generated · byte-compared on every PR
```

The tool is shared because it is the same tool. The rules are per-repo because
they genuinely describe that repo. Nothing else moves.

## Step 1 · schema-2 repos (`nika`, `nika-spec`)

Mechanical, and **proven** on a clean `nika-spec` clone on 2026-07-29:

```sh
# split: everything from `FILES = [` to `def glob_to_re` becomes the rules
python3 - <<'PY'
import pathlib
src = pathlib.Path("scripts/estate.py").read_text()
i, j = src.index("FILES = ["), src.index("def glob_to_re")
pathlib.Path("scripts/estate_rules.py").write_text(
    "# Per-repo estate rules. The tool is shared; these are ours.\n\n" + src[i:j].rstrip() + "\n")
PY

# mirror the tool, then regenerate
curl -fsSL https://raw.githubusercontent.com/supernovae-st/nika-estate/main/scripts/estate.py \
  -o scripts/estate.py
python3 scripts/estate.py --write
```

### What the proof produced

`estate.yaml` changed on **14 lines out of 340**, and every one is accounted
for:

| Change | Why |
|---|---|
| 2 class-description lines | the deliberate reconciliation of the fork |
| `classified_files 1256 → 1257`, `authored 930 → 931` | `estate_rules.py` is a new tracked file |
| `match_count 16 → 17` on `scripts/**` | same reason |
| the `aggregate_sha256` of every touched pattern | the two `scripts/` blobs changed |
| the `sha256` of `estate.py` | it is the canonical tool now |

Row count identical (43). Every path identical. Every classification
identical. **Zero unexplained differences** · that is the bar, and it was met
before any of this shipped.

## Step 2 · schema-1 repos (`nika-registry`, `nika-docs`)

Not mechanical. These carry an imperative `classify()` plus repo-specific
helpers (`spec_pin_rev`, `engine_version`, `index_artifact_keys`,
`registry_entry_exists`, `video_stems`) that must become declarative
`PATTERNS` rows. Budget real time, and expect the migration to *surface*
files that were silently misclassified because the four-class vocabulary had
no word for them. Those findings are the point, not an obstacle.

## Step 3 · the gate, and why it matters more than it looks

Once every repo runs the mirror, the drift gate compares the local
`scripts/estate.py` against this repo's copy at the pinned rev, exactly like
the spec pack. Until then the mirror is a convention, and a convention is not
a gate.

That distinction is not academic. Applying step 1 surfaced something nobody
had seen: **both manifests were already stale at HEAD.** The engine declared
4210 classified files against 4213 real; the spec declared 1256 against 1258.
Running the original tool at an untouched checkout returned exit 5 in both.

The reason nobody noticed is written in the workflow:

```yaml
on:
  pull_request          # never on push
continue-on-error: true # never blocks
```

That is correct for E0, and it is exactly why E0 cannot be the resting state.
A gate that observes and never speaks is indistinguishable from no gate at
all once the humans stop reading its logs. Step 3 is not "add enforcement
later" · it is the step that makes every step before it mean something.

Anyone re-running the migration should expect part of their diff to be
absorbed pre-existing drift, and should attribute it explicitly rather than
claim it. The bar is zero unexplained lines, not a small diff.

### One trap, paid on the first attempt

`tracked_index()` reads `git ls-files -s`, which is the **index**. A brand new
`estate_rules.py` that has not been `git add`ed does not exist as far as the
tool is concerned, so the manifest generates cleanly while silently omitting
the file that was just created. Stage first, generate second, and verify with
`--check` that the result is self-consistent before committing.

## What step 2 actually cost, and what it paid

It was not mechanical, and the interesting part is what the richer vocabulary
made sayable:

| repo | reclassified | why schema 1 could not say it |
|---|---|---|
| `nika-docs` | `LICENSE` · authored → **pinned-copy** | calling it authored claimed a human here wrote the GNU AGPL |
| `nika-registry` | `SPEC_PIN` · authored → **authored-pin** | its own header reads "Bump deliberately: edit this"; it is the input every projection derives from |
| `nika-registry` | `LICENSE` → **pinned-copy** | same as above, verbatim Apache text |
| `nika-registry` | 3 shell completions → **generated**, gate NONE | clap output committed once inside a release-heal PR; nothing here re-derives them and the engine version behind their bytes is recorded nowhere |

The registry did **not** become a pile of globs, and that was the right call.
Every cert cites the artifact it certified, every projected entry cites the
spec rev it came from, and a badge whose registry entry was deleted is a
leftover projection nothing re-proves. None of that survives being flattened
into one shared evidence string, so its rules module **computes** its rows.
That is the shape to reach for: the tool is shared, the rules are code.

Verified path by path against the schema-1 classification before either
shipped · `nika-docs` 151 files, 148 identical · `nika-registry` 108 files,
103 identical · zero coverage holes in either · every difference named above.

### Three defects the comparison caught that reading would not have

1. **`**/*.mdx` never matched a root-level page.** In this glob dialect `**`
   expands to `.*`, so the pattern demands a slash. Every top-level `.mdx`
   was silently falling through to the catch-all. Same trap in
   `images/**/*.svg`. The forms that work are `**.mdx` and `images/**.svg`.
2. **The honesty budget could shrink without anything becoming known.** The
   `unverified` list was built from pattern rows only, so six bitmaps that
   became computed `files:` rows quietly left it: 23 became 18 with not one
   file better understood. Both sources count now.
3. **The generator littered the tree it measures.** Importing the rules
   module makes Python write a `.pyc` beside it, and one reached a commit.
   `sys.dont_write_bytecode` is set before the import now.

## Status · all four steps closed 2026-07-29

- **Step 0** · the canonical tool lands here · `ec8bb8d`
- **Step 1** · the two schema-2 pilots mirror it · `nika-spec bf9faf2` ·
  `nika dcf67c99` · zero unexplained lines in either
- **Step 2** · the two schema-1 pilots migrate · `nika-docs 4ccdf81` ·
  `nika-registry 5009e4a` · every reclassification named above
- **Step 3** · byte-gate the mirror · `nika fc3f7aa8` · `nika-spec 449706f` ·
  `nika-docs 33823be` · `nika-registry a51c6ba`

Four repos, one tool, one vocabulary. `scripts/estate.py` is a `pinned-copy`
in every one of them, `ESTATE_PIN` is the `authored-pin` the gate compares
against, and the `mirror` job fails the run on any difference. Editing a
mirror is no longer a convention to remember. It is a red build.

The estate itself stays in **observation mode** (E0): it declares what is and
enforces nothing about provenance. What is enforced is narrower and harder to
argue with · that the tool doing the declaring is the tool everyone agreed on,
and that the tool refuses what it claims to refuse.

## What the verification pass found afterwards

Ten adversarial mutations, each planted on a throwaway clone, each caught with
the documented exit code. That battery is no longer a transcript: it is
`scripts/selftest.py`, wired into this repo's gate on every push, and itself
mutation-proven so it cannot quietly stop guarding anything.

Running `--check` on **fresh clones of origin** rather than on the local tree
then caught something the local trees could not show: `nika-spec` was at exit 5.
The mirror-gate commit had changed a workflow file and the manifest was
regenerated before that edit was staged, so the pattern aggregates, which read
the git index, recorded the file as it was before the mirror job existed.
Confirmed rather than assumed · restoring the pre-mirror workflow into the
index reproduces the committed aggregate exactly. Fixed in `nika-spec f84dc20`.

That was the same index trap as the rules file, in a second shape, inside one
arc. The structural cause is named in the README under *One thing still
undecided*: `files:` rows hash disk bytes, pattern aggregates hash index blobs.
It is a real trade-off rather than an obvious bug, so it is written down for a
decision instead of resolved unilaterally.

**The lesson that generalises past this repo:** verify on a fresh clone of the
remote, never on the tree you just worked in. The tree you worked in is the one
place where your own mistake is invisible.
