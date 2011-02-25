#!/bin/bash
OUTPUT=$(pear $@ 2>&1)
if [ "$?" -eq 1 ]
  then
  if [[ "$OUTPUT" =~ "is already installed and is the same as the released" ]]
  then
    echo "package is already installed and is the same as the released"
    exit 0
  fi
  if [[ "$OUTPUT" =~ "is already initialized" ]]
  then
    echo "channel is already initialized"
    exit 0
  fi
  echo $OUTPUT
  exit 1
fi
exit 0
