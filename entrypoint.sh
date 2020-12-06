#!/bin/bash
export PACKAGER="$USER_NAME <$USER_EMAIL>"
export MAINTAINER="$USER_NAME <$USER_EMAIL>"

sudo tee < "/usr/share/zoneinfo/${TIMEZONE}" > /etc/localtime
cat > /etc/abuild.builder.conf <<EOF
PACKAGER="$USER_NAME <$USER_EMAIL>"
MAINTAINER="$USER_NAME <$USER_EMAIL>"
EOF

git config --global user.name "$USER_NAME"
git config --global user.email "$USER_EMAIL"

exec bash -l
