#!/usr/bin/env bash
# CommitMind PreToolUse hook: warns (advisory, never blocks) when another live
# session is already editing the same file in this checkout, so two agents don't
# clobber each other on commit (spec 80ebc2ab, Layer B). Logic lives in
# `commitmind hook file-lease-check`. Silent-allow when the binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook file-lease-check
