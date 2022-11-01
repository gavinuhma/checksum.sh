#!/bin/bash

function checksum() {
  local s
  s=$(curl -fsSL "$1")
  local h
  if command -v shasum >/dev/null ; then
    h=shasum
  else
    h=sha1sum
  fi
  if [ ! "$2" ] ; then
    printf %s\\n "$s" | "$h" | awk '{print $1}'
    return 1;
  fi
  printf %s\\n "$s" | "$h" --check --status <(printf '%s  -\n' "$2") || {
    echo "checksum failed" >&2;
    return 1;
  }
  printf %s\\n "$s"
}
