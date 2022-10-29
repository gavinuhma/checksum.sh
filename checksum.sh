#!/bin/bash

function checksum() {
  local s
  s=$(curl -fsSL "$1")
  if ! command -v shasum >/dev/null
  then
    shasum() { sha1sum "$@"; }
  fi
  if [ ! "$2" ]
  then
    printf %s\\n "$s" | shasum -a 256 | awk '{print $1}'
    return 1;
  fi
  printf %s\\n "$s" | shasum -a 256 --check --status <(printf '%s  -\n' "$2") || { echo "checksum failed" >&2; return 1; }
  printf %s\\n "$s"
}
