#!/bin/bash

. ./_error_handling.sh

CONTINUE_FROM="${1:-}"
if [ -z "${CONTINUE_FROM}" ]; then
  echo 'Need to provide an ID to start from'
  exit 1
fi

for segment in $(ls 0*.sh | sort -n); do
  seg_num="$(echo ${segment} | cut -d _ -f 1)"

  if [ "${seg_num}" -ge "${CONTINUE_FROM}" ]; then
    echo "Executing segment: ${segment}"
    ./${segment}
    echo "Segment complete"
  fi
done
