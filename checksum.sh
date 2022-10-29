#!/bin/bash

function checksum() {
  s=$(curl -fsSL "$1")
  if ! command -v shasum >/dev/null
  then
    shasum() { sha1sum "$@"; }
  fi
  c=$(printf %s\\n "$s" | shasum | awk '{print $1}')
  if [ "$c" = "$2" ]
  then
    printf %s\\n "$s"
  else
    echo "invalid checksum $c != $2" 1>&2;
  fi
  unset s
  unset c
}
