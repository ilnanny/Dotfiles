#/bin/bash

. ./_config.sh
. ./_error_handling.sh

if [ "${LOCAL}" != "yes" ]; then
  if [ -z "${GENTOO_MIRRORS:-}" ]; then
    mirrorselect -o -s 1 -q -D -H -R 'North America' 2> /dev/null >> ./_config.sh
  fi
fi
