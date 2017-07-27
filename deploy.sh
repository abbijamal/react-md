#!/bin/bash
# exit on any error
set -e
tar_name=react-md.tar.bz2
ssh_alias=react-md
server_location=/var/www/react-md/v1.1.x

yarn
yarn prebuild && yarn scripts
cp lib ./docs
cd docs
yarn && yarn build

cd ..
rm -f "$tar_name"
tar --exclude='docs/src/server/databases/.gitkeep' \
  --exclude='docs/src/server/databases/airQuality.json' \
  -jcvf "$tar_name" \
    lib \
    docs/public/assets \
    docs/public/sassdoc \
    docs/src/server/databases \
    docs/webpack-assets.json

ssh "$ssh_alias" "cd $server_location && git pull && yarn && yarn prebuild && cd docs && rm -rf public/assets"
scp "$tar_name" "$sh_alias":"$server_location"

ssh "$ssh_alias" "cd $server_location && tar jxvf $tar_name"
