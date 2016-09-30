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
sudo -E apt-get install -y rfc5766-turn-server nodejs

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
[ -f ~/.ipfs ] || ipfs init

touch ipfs.log
tail -f ipfs.log &

# Make sure ipfs daemon is running
while ! </dev/tcp/127.0.0.1/5001 ; do
	nohup ipfs daemon 2>&1 > ipfs.log &
       	sleep 60
done

