# ThoughtKhoral Identity Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rename the product and runtime identities to ThoughtKhoral without breaking the existing `n2n.room.v1` wire contract or persisted data.

**Architecture:** The root remains the governance repository. Each current independently versioned child repository is renamed and updates its local specification hierarchy before its own source. Compatibility values in the v1 contract and database remain unchanged; new machine-facing identities use `thought-khoral`.

**Tech Stack:** Git, Rust/Cargo, TypeScript/npm/Vite, Podman Compose, Kubernetes YAML, shell validation.

**Spec:** `.ai/specs/what/thoughtkhoral-product-identity.md`; `.ai/specs/how/thoughtkhoral-identity-migration.md`; `.ai/specs/decisions/003-thoughtkhoral-product-identity.md`

## Global Constraints

- Display/prose identifiers use `ThoughtKhoral`; machine/package identifiers use `thought-khoral`.
- No new `n2n` identifiers except explicitly documented historical or `n2n.room.v1` wire-compatible values.
- Do not rename database tables, persisted records, event payload fields, or `n2n.room.v1` values.
- Update root and project-local Markdown specifications before changing code or deployment assets.
- Each renamed child remains independently versioned; do not absorb it into root Git.
- Verify the complete contracts, gateway, UI, platform, and browser governed-room flow after the rename.

---

### Task 1: Record local rename decisions and rename project directories

**Files:**
- Modify: root `.gitignore`, root `.ai/specs/README.md`
- Create: each child `.ai/specs/decisions/002-thoughtkhoral-identity.md`
- Modify: each child `.ai/specs/{README.md,what/*.md,how/*.md}`
- Rename: six `n2n-*` project directories to the corresponding `thought-khoral-*` names.

**Interfaces:**
- Consumes: decision 003 and the root migration design.
- Produces: six direct-child ThoughtKhoral repositories with local, accepted rename records.

- [ ] **Step 1: Write a failing root structure check**

Extend `scripts/verify-spec-hierarchy.sh` to require the six `thought-khoral-*` directories and reject active root Git tracking below them. It must initially fail because the directories retain their N2N names.

- [ ] **Step 2: Run the check**

Run: `bash scripts/verify-spec-hierarchy.sh`

Expected: FAIL, naming the legacy directories.

- [ ] **Step 3: Update child specs, then rename directories**

In every local decision, cite root decision 003; state the exact old and new directory name, preserve `n2n.room.v1`, and state that databases and persisted values are excluded. Commit each local spec update in its child repository before renaming its directory. Rename the directory only after that commit.

- [ ] **Step 4: Update root ignore rules and verify**

Replace every `/n2n-*` direct-child entry with its `/thought-khoral-*` equivalent. Run `bash scripts/verify-spec-hierarchy.sh` and `git ls-files thought-khoral-contracts thought-khoral-room-gateway thought-khoral-workspace-ui thought-khoral-platform`.

Expected: hierarchy check passes; root tracks zero child paths.

- [ ] **Step 5: Commit root governance changes**

```bash
git add .gitignore scripts/verify-spec-hierarchy.sh .ai/specs
git commit -m "docs: rename workspace projects to ThoughtKhoral"
```

### Task 2: Rename contract repository metadata without changing v1 wire values

**Files:**
- Modify: `thought-khoral-contracts/{package.json,protocol.md,.ai/specs/README.md}`
- Test: `thought-khoral-contracts/test/validate-fixtures.mjs`

**Interfaces:**
- Consumes: `n2n.room.v1` schemas and fixtures.
- Produces: package metadata named `thought-khoral-contracts`; unchanged v1 schemas/fixtures.

- [ ] **Step 1: Add a failing metadata regression assertion**

In `test/validate-fixtures.mjs`, assert package name is `thought-khoral-contracts` and `protocol.md` documents `n2n.room.v1` as a retained compatibility value. The assertion initially fails.

- [ ] **Step 2: Run the test**

Run: `npm test`

Expected: FAIL on legacy package metadata.

- [ ] **Step 3: Update local How/What docs and metadata**

Update local specs before changing `package.json` and prose. Rename the package while leaving schema `const` values, fixture payloads, and immutable release tags unchanged. Describe future `thought-khoral.room.v2` as a separate migration.

- [ ] **Step 4: Verify compatibility**

Run: `npm test && rg -n 'n2n\.room\.v1' schemas fixtures protocol.md`

Expected: fixtures pass and every remaining v1 occurrence is documented wire compatibility.

- [ ] **Step 5: Commit**

```bash
git add .
git commit -m "chore: rename contracts package to ThoughtKhoral"
```

### Task 3: Rename gateway package, binary, logs, and configuration namespace

**Files:**
- Modify: `thought-khoral-room-gateway/{Cargo.toml,Cargo.lock,src/*.rs,.ai/specs/**,README.md}`
- Modify: `thought-khoral-room-gateway/tests/**/*.rs`
- Test: full Cargo test suite.

**Interfaces:**
- Consumes: unchanged `n2n.room.v1` contract archive.
- Produces: `thought-khoral-room-gateway` crate/binary and ThoughtKhoral runtime labels.

- [ ] **Step 1: Add a failing identity test**

Add a test that starts the health/status response and asserts its product name is `ThoughtKhoral`; assert compiled package/binary metadata uses `thought-khoral-room-gateway`.

- [ ] **Step 2: Run focused tests**

Run: `cargo test --test protocol_test`

Expected: FAIL because legacy metadata/copy remains.

- [ ] **Step 3: Apply the local spec-first rename**

Update gateway local docs and decision first. Rename crate/package/binary identifiers, health/log labels, and newly introduced configuration namespace to ThoughtKhoral. Retain `n2n.room.v1`, vendored historical archive names only where required by the lock, database identifiers, and wire payload values.

- [ ] **Step 4: Verify**

Run: `cargo fmt --check && cargo clippy --all-targets -- -D warnings && cargo test --all-targets && rg -n 'n2n' --glob '!contracts/**' --glob '!migrations/**'`

Expected: all tests pass; remaining matches are explicitly documented compatibility/data exclusions.

- [ ] **Step 5: Commit**

```bash
git add .
git commit -m "chore: rename gateway to ThoughtKhoral"
```

### Task 4: Rename UI package and visible product copy

**Files:**
- Modify: `thought-khoral-workspace-ui/{package.json,index.html,src/**/*.tsx,vite.config.ts,.ai/specs/**,static-preview-smoke.mjs}`
- Test: UI unit suite, production preview smoke, production build.

**Interfaces:**
- Consumes: unchanged `n2n.room.v1` messages and browser `session.authenticate` behavior.
- Produces: ThoughtKhoral-branded browser UI with unchanged room semantics.

- [ ] **Step 1: Add failing visible-brand assertions**

Extend the production-preview smoke test to require `ThoughtKhoral` in the document title and visible workspace heading after bootstrap. The old build must fail those assertions.

- [ ] **Step 2: Run the preview test**

Run: `npm run test:preview`

Expected: FAIL on legacy N:N title/copy.

- [ ] **Step 3: Update local specs then UI identity**

Update project What/How/decision documents before changing Vite/package metadata or visible copy. Rename package metadata, HTML title, headings, labels, and newly authored CSS/test identifiers. Keep normalized v1 event types untouched.

- [ ] **Step 4: Verify**

Run: `npm test && npm run test:preview && npm run build && rg -n 'N:N|n2n' src index.html package.json`

Expected: all tests/build pass; no active legacy UI identity remains.

- [ ] **Step 5: Commit**

```bash
git add .
git commit -m "chore: rename workspace UI to ThoughtKhoral"
```

### Task 5: Rename platform composition and browser entry point

**Files:**
- Modify: `thought-khoral-platform/{compose.yaml,README.md,containers/**,kube/*.yaml,ui/**,scripts/**,.ai/specs/**}`
- Test: `scripts/smoke.sh`, `scripts/validate-kube.sh`.

**Interfaces:**
- Consumes: renamed sibling directories and their new binary/package artifacts.
- Produces: `thought-khoral-*` container images/services/labels and a browser entry point branded ThoughtKhoral.

- [ ] **Step 1: Add failing composition assertions**

Extend `scripts/smoke.sh` to reject legacy `n2n_` Compose service/container names and require the expected ThoughtKhoral UI page title after login. Extend `scripts/validate-kube.sh` to reject active N2N labels outside documented v1/data compatibility annotations.

- [ ] **Step 2: Run checks**

Run: `bash scripts/smoke.sh && bash scripts/validate-kube.sh`

Expected: FAIL until composition identifiers are renamed.

- [ ] **Step 3: Update platform specs then references**

Rename Compose services, image tags, network/volume names, Kubernetes resource names and labels, environment-variable namespaces, container scripts, browser bootstrap namespace, and documentation. Retain existing database names and v1 contract strings. Use the renamed sibling build contexts.

- [ ] **Step 4: Verify the runnable stack**

Run: `podman-compose up --build -d && bash scripts/smoke.sh && bash scripts/validate-kube.sh`

Expected: all services healthy; `http://localhost:8082` displays ThoughtKhoral and reaches the authenticated room.

- [ ] **Step 5: Commit and perform scoped cleanup**

```bash
git add .
git commit -m "chore: rename local platform to ThoughtKhoral"
podman-compose down
```

### Task 6: Run the cross-project rename release gate

**Files:**
- Modify: root `.ai/specs/README.md`, `thought-khoral-platform/README.md`
- Test: contracts, gateway, UI, platform, browser flow, stale-name scan.

**Interfaces:**
- Consumes: all renamed repositories and retained v1 compatibility contract.
- Produces: reproducible evidence that ThoughtKhoral is the active product identity.

- [ ] **Step 1: Write the failing stale-name allowlist check**

Create root `scripts/verify-thoughtkhoral-identity.sh`. It must fail on every `n2n` match unless its path is in an allowlist containing only contract fixtures/schemas, gateway contract lock/archive references, migration files, and the historical rename-map table.

- [ ] **Step 2: Run the check**

Run: `bash scripts/verify-thoughtkhoral-identity.sh`

Expected: FAIL until all active identifiers are migrated.

- [ ] **Step 3: Document historical exceptions**

Update root and platform READMEs with the exact retained `n2n.room.v1` and persisted-data exceptions. Do not add broad wildcard allowances.

- [ ] **Step 4: Run complete validation**

Run: `cd thought-khoral-contracts && npm test && cd ../thought-khoral-room-gateway && cargo fmt --check && cargo clippy --all-targets -- -D warnings && cargo test --all-targets && cd ../thought-khoral-workspace-ui && npm test && npm run test:preview && npm run build && cd ../thought-khoral-platform && podman-compose up --build -d && bash scripts/smoke.sh && bash scripts/validate-kube.sh && cd .. && bash scripts/verify-thoughtkhoral-identity.sh`

Expected: PASS; browser displays ThoughtKhoral and all remaining N2N references are deliberate exceptions.

- [ ] **Step 5: Commit release evidence**

```bash
git add .ai/specs scripts/verify-thoughtkhoral-identity.sh
git commit -m "test: verify ThoughtKhoral identity migration"
```

## Spec coverage review

| Requirement | Tasks |
| --- | --- |
| Canonical display and machine naming | 1–5 |
| Independent repositories | 1 |
| Preserve v1 wire/data values | 2–6 |
| Rename runtime/deployment identity | 3–5 |
| Browser governed-room verification | 5–6 |
| Stale active-name detection | 6 |
