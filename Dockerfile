ARG HELIUM_GA_RELEASE=2022.05.13.0_GA
ARG FIRMWARE_VERSION=2022.05.13.0_GA

ARG MINER_DIGEST=:latest
FROM jonzky/debug-helium-miner${MINER_DIGEST}

WORKDIR /opt/miner

ARG HELIUM_GA_RELEASE
ENV HELIUM_GA_RELEASE $HELIUM_GA_RELEASE
ENV FIRMWARE_VERSION $FIRMWARE_VERSION

COPY docker.config /opt/miner/releases/"$HELIUM_GA_RELEASE"/sys.config
COPY *.sh /opt/miner/

RUN echo "$HELIUM_GA_RELEASE" > /etc/lsb_release

ENTRYPOINT ["/opt/miner/start-miner.sh"]
