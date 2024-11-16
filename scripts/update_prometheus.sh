#!/bin/bash

log_line () {
  #printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$@" >> /tmp/scripted_update.log 2>&1
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$@"
}

update () {
  local organisation="$1"; shift
  local repository="$1"; shift
  local version="$1"; shift
  local binaries="$@"

  local current_version=$("$repository" --version | head -n1 | cut -d" " -f3)

  if [ "$current_version" = "$version" ]; then
    log_line "${organisation}/${repository}@v${version} already installed, skipping"; return
  fi

  log_line "Preparing to install ${organisation}/${repository}@v${version}"

  local tarball="https://github.com/${organisation}/${repository}/releases/download/v${version}/${repository}-${version}.linux-amd64.tar.gz"
  local tarball_basename=$(basename "$tarball")

  local checksums="https://github.com/${organisation}/${repository}/releases/download/v${version}/sha256sums.txt"
  local checksums_basename=$(basename "$checksums")
 
  log_line "Creating and changing to temporary directory" 
  sudo mkdir -vp "/tmp/${repository}" && cd "/tmp/${repository}" || exit 1
  
  log_line "Downloading"
  sudo wget -nv "$tarball" -O "$tarball_basename" || exit 1
  sudo wget -nv "$checksums" -O "$checksums_basename" || exit 1
  
  log_line "Checking checksum(s)"
  sha256sum --check --ignore-missing "$checksums_basename" || exit 1
  
  log_line "Extracting and installing binaries"
  sudo tar -vxzf "$tarball_basename" --strip-components 1 --wildcards -C /usr/local/bin/ $binaries || exit 1
  
  log_line "Restarting service(s)"
  sudo systemctl restart "$repository" || (log_line "Failed to restart"; exit 1)
  systemctl status "$repository"
  
  log_line "Cleaning up"
  sudo rm -vrf "/tmp/${repository}"
}

update prometheus prometheus 3.0.0 */prometheus */promtool
update prometheus alertmanager 0.27.0 */alertmanager */amtool
update prometheus node_exporter 1.8.2 */node_exporter
update prometheus blackbox_exporter 0.25.0 */blackbox_exporter
