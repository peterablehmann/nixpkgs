#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodejs curl prefetch-npm-deps common-updater-scripts jq git
# shellcheck shell=bash


set -eou pipefail

tempDir=$(mktemp -d)

latestTag=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "https://api.github.com/repos/renovatebot/renovate/releases/latest" | jq -s '.[0].tag_name' | tr -d '"')
gitHash=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "https://api.github.com/repos/renovatebot/renovate/git/ref/tags/$latestTag" | jq -s '.[0].object.sha' | tr -d '"')

if [[ "$UPDATE_NIX_OLD_VERSION" == "$latestTag" ]]; then
    echo 'Version did not change, skipping...'
    exit 0
fi

pushd "$tempDir"
# renovate is a bit weird, and expects the full repo to be there to execute some commands.
# --package-lock-only didn't work, so we do a git clone :(
git clone --depth=1 --branch $latestTag https://github.com/renovatebot/renovate.git .
npm install

npmDepsHash=$(prefetch-npm-deps ./package-lock.json)
popd

update-source-version renovate "${latestTag#v}"

pushd pkgs/by-name/re/renovate
sed -E 's#\bgitHash = ".*?"#gitHash = "'"${gitHash:0:7}"'"#' -i package.nix
sed -E 's#\bnpmDepsHash = ".*?"#npmDepsHash = "'"$npmDepsHash"'"#' -i package.nix
cp "$tempDir/package-lock.json" ./package-lock.json
popd

echo "Update successful, new version: $latestTag"
