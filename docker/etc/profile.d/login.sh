PS1='\[\033[01;31m\]\u@ca:\[\033[01;34m\]\w\[\033[00m\]\$ '

eval "$(dircolors -b)"
alias ls='ls --color=auto -H'
alias ll='ls --color=auto -l -H'
alias l='ls --color=auto -lA -H'

exit() { [ "${1:-0}" -eq 0 ] && DONE=1 || DONE=; builtin exit ${1:-0}; }
logout() { exit "$@"; }
abort() { DONE=; exit 1; }
help() { $(which help); }

if [ $$ -eq 1 ]; then
  set -eu
  mkdir -p "$DATADIR"
  if [ -s "/$DATAFILE" ]; then
    echo "Mount encrypted volume"
    crypt mount "/$DATAFILE" "$DATADIR"
  else
    echo "Create encrypted volume"
    crypt create "/$DATAFILE" "$DATADIR"
  fi
  initialize-home
  cd $PWD
  mount -r -o remount /
  mount -t tmpfs -o size=100M tmpfs /tmp
  help
  set +eu
fi
