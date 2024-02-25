#!/bin/bash

case "$1" in
  web|api|pb)
    true ;;
  *)
    echo "Can't deploy '${1}'. Usage: ${0} [ web | api | pb ]"; exit 1 ;;
esac

setup_ssh () {
  DEPLOY_SSH="${DEPLOY_USER}@${DEPLOY_HOST}"

  eval `ssh-agent -s`
  ssh-add - <<< "$PRIVATE_KEY"

  mkdir -p ~/.ssh
  ssh-keyscan -H "$DEPLOY_HOST" >> ~/.ssh/known_hosts

  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/known_hosts
}

pack_and_send () {
  local DIR="$1"

  if [ ! -d "$DIR" ]; then exit 1; fi

  local TAR="${DIR}.tar"
  local MD5="${DIR}.tar.md5"

  tar -cf "$TAR" "$DIR"
  md5sum "$TAR" >> "$MD5"

  scp "$MD5" "$TAR" "$DEPLOY_SSH":/tmp/
}

run_install () {
  local SCRIPT="${1}_install.sh"
  local PATH=".github/scripts/${SCRIPT}"

  if [ ! -f "$PATH" ]; then exit 1; fi

  scp "$PATH" "$DEPLOY_SSH":/tmp/
  ssh "$DEPLOY_SSH" "/bin/bash /tmp/${SCRIPT}"
}

setup_ssh
pack_and_send "$1"
run_install "$1"
