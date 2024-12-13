#!/bin/bash

log_line () {
  #printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$@" >> /tmp/scripted_update.log 2>&1
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$@"
}

update () {
  local org="$1"; shift
  local app="$1"; shift
  local version="$1"; shift
  local binaries="$@"

  local current_version=$("$app" --version | head -n1 | cut -d" " -f3)

  if [ "$current_version" = "$version" ]; then
    log_line "${org}/${app}@v${version} already installed, skipping"; return
  fi

  log_line "Preparing to install ${org}/${app}@v${version}"

  local tarball="https://github.com/${org}/${app}/releases/download/v${version}/${app}-${version}.linux-amd64.tar.gz"
  local tarball_basename=$(basename "$tarball")

  local checksums="https://github.com/${org}/${app}/releases/download/v${version}/sha256sums.txt"
  local checksums_basename=$(basename "$checksums")
 
  log_line "Creating and changing to temporary directory" 
  sudo mkdir -vp "/tmp/${app}" && cd "/tmp/${app}" || exit 1
  
  log_line "Downloading"
  sudo wget -nv "$tarball" -O "$tarball_basename" || exit 1
  sudo wget -nv "$checksums" -O "$checksums_basename" || exit 1
  
  log_line "Checking checksum(s)"
  sha256sum --check --ignore-missing "$checksums_basename" || exit 1
  
  log_line "Extracting and installing binaries"
  sudo tar -vxzf "$tarball_basename" --strip-components 1 --wildcards -C /usr/local/bin/ $binaries || exit 1
  
  log_line "Restarting service(s)"
  sudo systemctl restart "$app" || (log_line "Failed to restart"; exit 1)
  
  log_line "Cleaning up"
  sudo rm -vrf "/tmp/${app}"
}

update prometheus prometheus 3.0.1 */prometheus */promtool
update prometheus alertmanager 0.27.0 */alertmanager */amtool
update prometheus node_exporter 1.8.2 */node_exporter
update prometheus blackbox_exporter 0.25.0 */blackbox_exporter
