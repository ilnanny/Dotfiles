#!/bin/false
# The above is to prevent this file from being executed. It should only be
# sourced.

#TTY_COLOR_GREEN="$(tput setaf 2)"
#TTY_COLOR_RED="$(tput setaf 1)"
#TTY_COLOR_RST="$(tput sgr0)"
TTY_COLOR_GREEN=""
TTY_COLOR_RED=""
TTY_COLOR_RST=""

function fatal() {
  echo "${TTY_COLOR_RED}${@}${TTY_COLOR_RST}"
  exit 1
}

# Shortcut for the kernel CLI config utility
function kernel_config {
  run_command /usr/src/linux ./scripts/config ${@}
}

function log() {
  echo -e "${@}"
}

function run_command() {
  local working_directory="${1}"
  shift

  if [ -z "${CHROOT_DIRECTORY:-}" ]; then
    if [ ! -d "${working_directory}" ]; then
      fatal "Provided working directory doesn't exist"
    fi

    (cd "${working_directory}"; ${@}) > .last_command_output.txt 2>&1
  else
    if [ ! -d "${CHROOT_DIRECTORY}" ]; then
      fatal "Specified chroot directory doesn't exist"
    fi

    if [ ! -d "${CHROOT_DIRECTORY}/${working_directory}" ]; then
      fatal "Provided working directory doesn't exist inside chroot"
    fi

    # For some reason the chroot doesn't like the command and argument being
    # mushed together in the chroot string... who knows...
    local command="${1}"
    shift
    local args="${@}"

    chroot "${CHROOT_DIRECTORY}" /bin/bash -c "cd ${working_directory}; ${command} ${args}" > .last_command_output.txt 2>&1
  fi
}
