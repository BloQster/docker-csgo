FROM debian:jessie
MAINTAINER Philipp Holler <philipp.holler93@googlemail.com>

# Set environment variables for build and entrypoint
ENV CSGO_INSTALLDIR="/opt/serverfiles" \
    CSGOSERVER_DOWNLOADLINK="https://gameservermanagers.com/dl/csgoserver" \
    CSGOSERVER_SCRIPT="/opt/csgoserver" \
    DEBIAN_FRONTEND="noninteractive"

# Add user and group for the service to run under
RUN groupadd -r csgo \
 && useradd -r -g csgo csgo

RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install -y mailutils postfix curl wget file gzip bzip2 bsdmainutils python util-linux tmux lib32gcc1 libstdc++6 libstdc++6:i386 \
 && rm -r /var/lib/apt/lists/* \
 && wget ${CSGOSERVER_DOWNLOADLINK} -O ${CSGOSERVER_SCRIPT} \
 && chmod +x ${CSGOSERVER_SCRIPT}

# Volume for persistent data and configuration files
VOLUME ${CSGO_INSTALLDIR}

# Expose the default CS:GO server port 27015
EXPOSE 27015

# Add entrypoint script and set its permissions
ADD /csgo_entrypoint.sh /
RUN chmod +x /csgo_entrypoint.sh
ENTRYPOINT ["/csgo_entrypoint.sh"]