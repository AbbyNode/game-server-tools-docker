#!/bin/bash

# Create config options file
if [ ! -f /config/mcaselector-options.yaml ]; then
    cp /templates/mcaselector-options.yaml /config/mcaselector-options.yaml
fi

exec /mcaselector/delete-chunks.sh
