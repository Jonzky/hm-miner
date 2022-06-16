#!/usr/bin/env sh

if [ "$(df -h /var/data/ | tail -1 | awk '{print $5}' | tr -d '%')" -ge 80 ]; then
    rm -rf /var/data/*
fi

# If a url has been set use it, otherwise use the default
if [[ -z "${OVERRIDE_CONFIG_URL}" ]]; then
  cp miner.config /opt/miner/releases/$HELIUM_GA_RELEASE/sys.config
else
  wget -O "/opt/miner/releases/$HELIUM_GA_RELEASE/sys.config" \
      "${OVERRIDE_CONFIG_URL}"
fi

/opt/miner/gen-region.sh &

/opt/miner/bin/miner foreground