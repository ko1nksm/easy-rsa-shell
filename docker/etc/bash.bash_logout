[ "${DONE:-}" ] || printf "\033[01;31mAborted, discard changes.\033[m\n"
if [ $$ -eq 1 ]; then
  cd /
  mountpoint -q "$HOME" && umount "$HOME" ||:
  crypt unmount "/$DATAFILE" "$DATADIR" >/dev/null
fi
