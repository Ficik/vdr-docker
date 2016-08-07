#!/bin/bash
set -e
# if command starts with an option, prepend vdr
if [ "${1:0:1}" = '-' ]; then
  set -- vdr $@
fi

if [ "$1" = 'vdr' ]; then
  CONFDIR=/var/lib/vdr
fi
exec $@
