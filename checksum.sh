#!/bin/bash

function checksum() {
  s=$(curl -fsSL $1)
  if ! command -v shasum >/dev/null
  then
    alias shasum=sha1sum
  fi
  c=$(echo $s | shasum | awk '{print $1}')
  if [ "$c" = "$2" ]
  then
    echo $s
  else
    echo "invalid checksum $c != $2" 1>&2;
  fi
  unset s
  unset c
}
