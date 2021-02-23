#!/bin/bash
export PACKAGER="$USER_NAME <$USER_EMAIL>"
export MAINTAINER="$USER_NAME <$USER_EMAIL>"

cyanmsg() {
    ansi_cyan="\e[1;36m"
    ansi_reset="\e[0m"
    printf "${ansi_cyan}$*${ansi_reset}\n"
}

cyanmsg "Setting timezone to $TIMEZONE..."
sudo tee < "/usr/share/zoneinfo/${TIMEZONE}" > /etc/localtime

cyanmsg "Setting packager and maintainer..."
cat > /etc/abuild.builder.conf <<EOF
PACKAGER="$USER_NAME <$USER_EMAIL>"
MAINTAINER="$USER_NAME <$USER_EMAIL>"
EOF
cat /etc/abuild.builder.conf

cyanmsg "Setting git configuration..."
git config --global user.name "$USER_NAME"
git config --global user.email "$USER_EMAIL"

if test -e "$HOME"/.abuild/*.pub; then
    for pubkey in "$HOME"/.abuild/*.pub; do
        cyanmsg "Copying public key $pubkey to /etc/apk/keys..."
        cp "$pubkey" /etc/apk/keys/
    done
else
    cyanmsg "No public keys to copy"
    cyanmsg "You must generate an abuild key and copy the pubkey to /etc/apk/keys yourself"
fi

cyanmsg "Starting shell..."
exec bash -l
