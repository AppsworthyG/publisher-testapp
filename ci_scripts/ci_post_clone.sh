#!/bin/sh
set -e
# Xcode Cloud secrets: CRICHEROES_TOKEN, CRACKLESDK_TOKEN (Bitbucket repo access tokens).
# netrc allows one login per host, so rewrite each repo URL with its own token.
git config --global url."https://x-token-auth:${CRICHEROES_TOKEN}@bitbucket.org/crackle-tech/cricheroes.git".insteadOf "https://bitbucket.org/crackle-tech/cricheroes.git"
git config --global url."https://x-token-auth:${CRACKLESDK_TOKEN}@bitbucket.org/crackle-tech/cracklesdk_ios.git".insteadOf "https://bitbucket.org/crackle-tech/cracklesdk_ios.git"
cd "$CI_PRIMARY_REPOSITORY_PATH"
pod install
