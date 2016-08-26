#!/bin/bash
set -e

# Set correct permissions for directory containing the csgoserver script
chown -R csgo:csgo $(dirname $CSGOSERVER_SCRIPT)

# Default values for csgoserver installation
: ${SERVER_NAME=Generic Docker CSGO Server}
: ${RCON_PASSWORD=genericRconPassword}
: ${GSLT_TOKEN=}

# Install CSGO on first execute
if [ ! -f /tmp/csgo-installed ]; then
	exec start-stop-daemon --start --chuid csgo:csgo --exec echo -e "y\ny\n$SERVER_NAME\n$RCON_PASSWORD\n$GSLT_TOKEN" | $CSGOSERVER_SCRIPT install
	touch /tmp/csgo-installed
fi

# Set correct ownership and start CS:GO server
chown -R csgo:csgo $CSGO_INSTALLDIR $CSGO_CONFIGFOLDER
exec start-stop-daemon --start --chuid csgo:csgo --exec $CSGOSERVER_SCRIPT start
