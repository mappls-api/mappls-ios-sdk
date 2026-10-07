# SDK docs updater

`update_sdk_docs.py` keeps the Mappls iOS SDK documentation in sync with the
latest module versions published on **Swift Package Manager** — the
distribution repos under [github.com/MapmyIndia](https://github.com/MapmyIndia).

## How it works

1. Finds the newest `docs/vX.Y.Z` folder (or the one you pass with
   `--docs-version`).
2. For each module `.md` in that folder, reads the SPM distribution repo URL
   from its "Add Package Dependencies" install block.
3. Runs `git ls-remote --tags` against each repo to find the highest released
   semantic-version tag (this is the "latest SDK released on SPM").
4. If that version is newer than the local doc, the local module doc is
   **replaced with the distribution repo's full README** (fetched at the
   matching version tag), so **all** content is copied — new API sections, the
   real changelog, everything. If a repo exposes no README (some plugins ship
   only `Package.swift`), or if you pass `--row-only`, the script instead
   splices a single version-history row (real date/description when a README
   exists, otherwise the `--date` / `--note` fallback).
5. Refreshes the module version numbers in the current-version row of the
   **Documentation History** table in both `README.md` and
   `docs/vX.Y.Z/README.md`.

The script is idempotent: running it again when nothing new has shipped makes
no changes.

## Update current version, or create a new one?

When you run the script it first asks how to apply the update:

```
How should the docs be updated?
  [1] Update the CURRENT doc version in place (v1.0.35)
  [2] Create a NEW doc version (suggested: v1.0.36)
Choose 1 or 2 [1]:
```

- **Option 1 (update current)** edits the existing `docs/vX.Y.Z` folder in
  place — handy for correcting or topping up the latest published docs.
- **Option 2 (create new)** copies the current folder to a new
  `docs/vNEW` folder (patch auto-bumped, e.g. `v1.0.36`), adds it as the newest
  row of the Documentation History tables (promoting the previous version to a
  history row with corrected relative links), and then applies the SPM version
  updates there. The previous folder is left untouched.
  The Documentation History tables are kept to a rolling window: each time a new
  version row is added, the **oldest** version row is dropped (from both the
  root `README.md` and the new folder's `README.md`), so the table doesn't grow
  without bound. Older versions remain available via the folders and
  `Version-History.md`.

Skip the prompt with flags:

```bash
python3 scripts/update_sdk_docs.py --update-current      # option 1
python3 scripts/update_sdk_docs.py --new-version         # option 2, auto-bump patch
python3 scripts/update_sdk_docs.py --new-version v1.0.40  # option 2, explicit version
python3 scripts/update_sdk_docs.py --yes                 # non-interactive, keep defaults (option 1)
```

## Requirements

- Python 3.9+
- A working `git` CLI with network access to github.com

## Usage

```bash
# Preview what would change (recommended first step)
python3 scripts/update_sdk_docs.py --dry-run

# Run interactively (prompts: update current vs. create a new version)
python3 scripts/update_sdk_docs.py

# Target a specific docs folder
python3 scripts/update_sdk_docs.py --docs-version v1.0.35

# Only check specific modules
python3 scripts/update_sdk_docs.py --only MapplsMap MapplsAPIKit

# Customise the date / release note stamped on new rows
python3 scripts/update_sdk_docs.py --date "07 Oct 2026" --note "- Added new features."
```

## Where the documentation comes from

Each module doc points at a distribution repo under
[github.com/MapmyIndia](https://github.com/MapmyIndia) or
[github.com/mappls-api](https://github.com/mappls-api) (e.g.
`mappls-api-kit-distribution`). Those repos host the authoritative module
README — the complete documentation with the real Version History, API
reference, and code samples. When a newer version is found, the script fetches
that repo's README (trying the version tag, then the default branch, and the
`README.md` / `Readme.md` casings) and **replaces the whole local module doc
with it**.

```bash
# Default: copy the full documentation from the distribution repos
python3 scripts/update_sdk_docs.py

# Only add a version-history row, don't replace the whole doc
python3 scripts/update_sdk_docs.py --row-only

# Skip all network fetches; stamp --date / --note instead
python3 scripts/update_sdk_docs.py --no-fetch --note "- Bug fixes."
```

Note: because the full README is copied, a module doc may legitimately start
pointing at a newer distribution channel (the repo's README can reference its
own successor repo). In that case a follow-up run converges on the newest
version — run the script again until it reports everything up to date.

## Notes

- Only modules that expose an SPM distribution URL in their doc are updated.
  Modules not yet on SPM (e.g. some plugins) are skipped automatically.
- When a distribution repo has no README (ships only `Package.swift`), the
  script falls back to adding a single version-history row with a generic note
  (`- Improvements and Bug Fixes.`). Pass `--note` to customise it.
- Full-doc replacement overwrites the local module doc entirely. The source
  `docs/vX.Y.Z` folder you create a new version from is never modified; only
  the target (current or new) folder is written.
- Only the current docs-version row of the README tables is edited; historical
  rows are left untouched.
