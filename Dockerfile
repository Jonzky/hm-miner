ARG BUILD_ARCH=arm64
ARG HELIUM_GA_RELEASE=2022.01.29.0
ARG FIRMWARE_VERSION=2022.01.29.0

ARG MINER_DIGEST=latest
FROM docker.io/jonzky/debug-helium-miner:${MINER_DIGEST}

WORKDIR /opt/miner

ARG HELIUM_GA_RELEASE
ENV HELIUM_GA_RELEASE $HELIUM_GA_RELEASE
ENV FIRMWARE_VERSION ${FIRMWARE_VERSION}

COPY docker.config /opt/miner/releases/"$HELIUM_GA_RELEASE"/sys.config
COPY docker.config.rockpi /opt/miner/docker.config.rockpi
COPY docker.config.5g /opt/miner/docker.config.5g
COPY *.sh /opt/miner/

RUN echo "$HELIUM_GA_RELEASE" > /etc/lsb_release

ENTRYPOINT ["/opt/miner/start-miner.sh"]
