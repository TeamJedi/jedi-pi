#!/bin/bash -xe

# Idempotent purposing script for jedi gateway

# Ensure that we use this script's directory for everything
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

# Update ubuntu repository indexes
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get update
sudo -E apt-get dist-upgrade -y

# Install dependencies
sudo -E apt-get install -y git nodejs olsrd olsrd-plugins libpam-systemd python-pip jq fuse uuid coturn

# Install official fs-repo-migrations, go-ipfs, gx, ipfs-update, and ipget binaries: https://dist.ipfs.io

[ -f fs-repo-migrations_v1.1.0_linux-arm.tar.gz ] || wget https://dist.ipfs.io/fs-repo-migrations/v1.1.0/fs-repo-migrations_v1.1.0_linux-arm.tar.gz
[ -d fs-repo-migrations ] || tar xzf fs-repo-migrations_v1.1.0_linux-arm.tar.gz
[ -f /usr/local/bin/fs-repo-migrations ] || sudo mv fs-repo-migrations/fs-repo-migrations /usr/local/bin/fs-repo-migrations

[ -f go-ipfs_v0.4.3_linux-arm.tar.gz ] || wget https://dist.ipfs.io/go-ipfs/v0.4.3/go-ipfs_v0.4.3_linux-arm.tar.gz
[ -d go-ipfs ] || tar xzf go-ipfs_v0.4.3_linux-arm.tar.gz
[ -f /usr/local/bin/ipfs ] || sudo mv go-ipfs/ipfs /usr/local/bin/ipfs

[ -f gx_v0.9.0_linux-arm.tar.gz ] || wget https://dist.ipfs.io/gx/v0.9.0/gx_v0.9.0_linux-arm.tar.gz
[ -d gx ] || tar xzf gx_v0.9.0_linux-arm.tar.gz
[ -f /usr/local/bin/gx ] || sudo mv -f gx/gx /usr/local/bin/gx

[ -f ipfs-update_v1.3.0_linux-arm.tar.gz ] || wget https://dist.ipfs.io/ipfs-update/v1.3.0/ipfs-update_v1.3.0_linux-arm.tar.gz
[ -d ipfs-update ] || tar xzf ipfs-update_v1.3.0_linux-arm.tar.gz
[ -f /usr/local/bin/ipfs-update ] || sudo mv -f ipfs-update/ipfs-update /usr/local/bin/ipfs-update

[ -f ipget_v0.0.1_linux-arm.tar.gz ] || wget https://dist.ipfs.io/ipget/v0.0.1/ipget_v0.0.1_linux-arm.tar.gz
[ -d ipget ] || tar xzf ipget_v0.0.1_linux-arm.tar.gz
[ -f /usr/local/bin/ipget ] || sudo mv -f ipget/ipget /usr/local/bin/ipget

# Initialize ipfs if necessary
[ -d ~/.ipfs ] || ipfs init

# Disable things we don't need (cron, triggerhappy)
sudo systemctl stop cron.service
sudo systemctl disable cron.service
sudo systemctl stop triggerhappy.service
sudo systemctl disable triggerhappy.service

# Make sure this pi user has access to manage user services
sudo loginctl enable-linger pi
#systemctl --user status || shutdown -r now

# Prepare ipfs
systemctl --user enable ipfs
systemctl --user start ipfs

# Prepare olsrd
sudo cp -f /etc/olsrd/olsrd.conf.overlay /etc/olsrd/olsrd.conf

ipfs id | jq -r .ID | sudo tee /etc/olsrd/olsrd.uuid

sudo systemctl enable olsrd || true
sudo systemctl start olsrd

# Prepare coturn
sudo cp -f /etc/default/coturn.overlay /etc/default/coturn

sudo systemctl enable coturn || true
sudo systemctl start coturn


