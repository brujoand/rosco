#!/bin/sh -e

# ubuntu
# check that owner group exists
if ! getent group spinnaker; then
  groupadd spinnaker
fi

# check that user exists
if ! getent passwd spinnaker; then
  useradd --gid spinnaker spinnaker -m --home-dir /home/spinnaker
fi

install_packer() {
  required_version='0.12.3'
  current_version=$(/usr/bin/packer --version)
  packer_status=$?
  if [ $packer_status -ne 0 ] || [ "$current_version" != "$required_version" ]; then
    temp_dir=$(mktemp -d installrosco.XXXX)
    cd "$temp_dir"
    wget https://releases.hashicorp.com/packer/${required_version}/packer_${required_version}_linux_amd64.zip
    unzip -o "packer_${required_version}_linux_amd64.zip" -d /usr/bin
    cd ..
    rm -rf "$temp_dir"
  fi
}

install_packer
install --mode=755 --owner=spinnaker --group=spinnaker --directory  /var/log/spinnaker/rosco
