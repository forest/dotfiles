#!/bin/bash

LIVEBOOK_HOME=~/code/notebooks

eval "$(
  cat ~/.gsc/spog-dev/credentials | awk '!/^\s*#/' | awk '!/^\s*$/' | while IFS='' read -r line; do
    key=$(echo "$line" | cut -d '=' -f 1 | sed 's/^[ \t]*//;s/[ \t]*$//')
    value=$(echo "$line" | cut -d '=' -f 2- | sed 's/^[ \t]*//;s/[ \t]*$//')
    echo "export $key=\"$value\""
  done
)"
