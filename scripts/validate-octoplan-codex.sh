#!/bin/sh
# Backward-compatible entry point; Octoplan now has one shared source.
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
exec python3 "$root/scripts/validate-octoplan.py"
