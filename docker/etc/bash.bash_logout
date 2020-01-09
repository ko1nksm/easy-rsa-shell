[ "${DONE:-}" ] || printf "\033[01;31mAborted, discard changes.\033[m\n"
if [ $$ -eq 1 ]; then
  cd /
  mountpoint -q /root && umount /root ||:
  crypt unmount "/$DATAFILE" data >/dev/null
fi
