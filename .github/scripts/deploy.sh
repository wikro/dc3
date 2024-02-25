#!/bin/bash

DEPLOY_SSH="${DEPLOY_USER}@${DEPLOY_HOST}"

DEPLOY_WEB=false
DEPLOY_API=false
DEPLOY_PB=false

ARGS=()
while [ $# -gt 0 ]; do
  case "$1" in
    web)
      DEPLOY_WEB=true
      shift
      ;;
    api)
      DEPLOY_API=true
      shift
      ;;
    pb)
      DEPLOY_PB=true
      shift
      ;;
    *)
      echo "Can't deploy '${1}'. Usage: ${0} [ web | api | pb ]"
      exit 1
      ;;
  esac
done

eval `ssh-agent -s`
ssh-add - <<< "$PRIVATE_KEY"

mkdir -p ~/.ssh
ssh-keyscan -H "$DEPLOY_HOST" >> ~/.ssh/known_hosts

chmod 700 ~/.ssh
chmod 600 ~/.ssh/known_hosts

pack_and_send () {
  if [ ! -d "$1" ]; then exit 1; fi

  local DIR="$1"
  local TAR="${1}.tar"

  tar -cf "$TAR" "$DIR"
  md5sum "$TAR" >> md5sums.txt

  scp "$TAR" "$DEPLOY_SSH":/tmp/
}

if $DEPLOY_WEB; then
  pack_and_send web
fi

if $DEPLOY_PB; then
  pack_and_send pb
fi

if $DEPLOY_API; then
  mv api/*.tmpl .

  .github/scripts/render_template.sh directus.env.tmpl > api/directus.env
  .github/scripts/render_template.sh postgresql.env.tmpl > api/postgresql.env

  pack_and_send api
fi

touch md5sums.txt
scp md5sums.txt .github/scripts/install.sh "${DEPLOY_SSH}":/tmp/
ssh "${DEPLOY_SSH}" "/bin/bash /tmp/install.sh"
