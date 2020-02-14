#!/bin/false
# The above is to prevent this file from being executed. It should only be
# sourced.

set -o errexit
set -o errtrace
set -o pipefail
set -o nounset

function error_handler() {
  echo "Error occurred in ${3} executing line ${1} with status code ${2}"
  echo "The pipe status values were: ${4}"
  echo
  echo "Output from the last run command can be found in ./.last_command_output.txt"
}

# Please note basename... is intentionally at the end as it's a command that
# will effect the value of '$?'
trap 'error_handler ${LINENO} $? "$(basename ${BASH_SOURCE[0]})" "${PIPESTATUS[*]}"' ERR

# Log all commands before they're executed for debugging purposes
if [ -n "${DEBUG:-}" ]; then
  set -o xtrace
fi
