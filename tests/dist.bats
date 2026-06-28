#!/usr/bin/env bats
# tests/dist.bats — BATS test suite for quicklisp-dist
#
# BDD: tests define the contract for the Makefile-driven metadata generation.
# Run: bats tests/dist.bats
# Requires: bats-core, make, git

setup() {
    REPO_ROOT="${BATS_TEST_DIRNAME}/.."
    DISTINFO="${REPO_ROOT}/distinfo.txt"
    SYSTEMS="${REPO_ROOT}/systems.txt"
    RELEASES="${REPO_ROOT}/releases.txt"
}

# ── distinfo.txt format ──────────────────────────────────────────────────── #

@test "distinfo.txt exists" {
    [ -f "$DISTINFO" ]
}

@test "distinfo.txt has name field" {
    grep -q "^name:" "$DISTINFO"
}

@test "distinfo.txt name is denzuko" {
    grep -q "^name: denzuko" "$DISTINFO"
}

@test "distinfo.txt has version field" {
    grep -q "^version:" "$DISTINFO"
}

@test "distinfo.txt version matches YYYY-MM-DD format" {
    grep -qE "^version: [0-9]{4}-[0-9]{2}-[0-9]{2}" "$DISTINFO"
}

@test "distinfo.txt has system-index-url field" {
    grep -q "^system-index-url:" "$DISTINFO"
}

@test "distinfo.txt has release-index-url field" {
    grep -q "^release-index-url:" "$DISTINFO"
}

@test "distinfo.txt has canonical-distinfo-url field" {
    grep -q "^canonical-distinfo-url:" "$DISTINFO"
}

@test "distinfo.txt URLs reference github.com/denzuko" {
    grep "url" "$DISTINFO" | grep -q "denzuko"
}

# ── systems.txt format ───────────────────────────────────────────────────── #

@test "systems.txt exists" {
    [ -f "$SYSTEMS" ]
}

@test "systems.txt has header comment" {
    head -1 "$SYSTEMS" | grep -q "^#"
}

# ── releases.txt format ──────────────────────────────────────────────────── #

@test "releases.txt exists" {
    [ -f "$RELEASES" ]
}

@test "releases.txt has header comment" {
    head -1 "$RELEASES" | grep -q "^#"
}

# ── Makefile targets ─────────────────────────────────────────────────────── #

@test "Makefile has dist target" {
    grep -q "^dist:" "${REPO_ROOT}/Makefile"
}

@test "Makefile has add-package target" {
    grep -q "^add-package" "${REPO_ROOT}/Makefile"
}

@test "Makefile has update-submodules target" {
    grep -q "^update-submodules" "${REPO_ROOT}/Makefile"
}

# ── SLSA provenance paths ────────────────────────────────────────────────── #

@test "Makefile exists at deterministic path" {
    [ -f "${REPO_ROOT}/Makefile" ]
}

@test "distinfo.txt exists at deterministic path" {
    [ -f "${REPO_ROOT}/distinfo.txt" ]
}
