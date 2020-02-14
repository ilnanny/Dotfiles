#!/bin/bash

. ./_error_handling.sh

for segment in $(ls 0*.sh | sort -n); do
  echo "Executing segment: ${segment}"
  ./${segment}
  echo "Segment complete"
done
