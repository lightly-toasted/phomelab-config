#!/usr/bin/env bash
set -euo pipefail

# ensure that only app tags are specified
blacklist='^$|^(always|base|nix|service)$'

log_dir='logs'
joblog="$log_dir/progress.log"

if [ "$#" -lt 1 ]; then
  echo "usage: $(basename "$0") <playbook> [tag...]" >&2
  exit 1
fi

playbook=$1
shift

mkdir -p "$log_dir"

export ANSIBLE_BECOME_ASK_PASS=False
read -rsp 'Become password: ' ANSIBLE_BECOME_PASS
echo
export ANSIBLE_BECOME_PASS

if [ "$#" -gt 0 ]; then
  tags=("$@")
else
  mapfile -t tags < <(
    ansible-playbook "$playbook" --list-tags \
      | sed -n 's/.*TASK TAGS: \[\(.*\)\]/\1/p' \
      | tr ',' '\n' | tr -d ' ' | sort -u \
      | grep -vE "$blacklist"
  )
fi

status=0
parallel --bar --joblog "$joblog" --results "$log_dir/" \
  ansible-playbook "$playbook" --tags {} ::: "${tags[@]}" || status=$?

if [ -f "$joblog" ]; then
  cat "$joblog"
fi
exit "$status"
