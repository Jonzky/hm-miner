#!/usr/bin/env sh

. ./dbus-wait.sh

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

# If a url has been set use it, otherwise use the default
if [[ -z "${OVERRIDE_CONFIG_URL_TEST}" ]]; then
  echo "No override provided for miner config"
else
  wget -O "/opt/miner/config/sys.config" \
      "${OVERRIDE_CONFIG_URL_TEST}"
fi

# Wait for the diagnostics app to be loaded
until wget -q -T 10 -O - http://diagnostics:5000/initFile.txt > /dev/null 2>&1
do
    echo "Diagnostics container not ready. Going to sleep."
    sleep 10
done

/opt/miner/gen-region.sh &

wait_for_dbus \
    && /opt/miner/bin/miner foreground