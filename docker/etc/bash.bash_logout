#shellcheck shell=bash

[ "${DONE:-}" ] || printf "\033[01;31mAborted, discard changes.\033[m\n"
if [ $$ -eq 1 ]; then
  cd /
  if mountpoint -q "$HOME"; then
    umount "$HOME" ||:
  fi
  crypt unmount "$DATAFILE" "$DATADIR" >/dev/null
fi
