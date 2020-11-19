#!/usr/bin/env bash

# This script starts a cfssl http server using the intermediate certificate authority.

# Unmount the intermediate ca secure directory.
function unmount_ca() {
    cryfs-unmount ca
}

function main() {
    # Mount the cryfs-encrypted intermediate ca.
    cryfs "$(pwd)/secure" "$(pwd)/ca"

    # The address on which cfssl should listen on.
    local address
    read -p 'Enter the address on which cfssl should listen on(leave empty for default - 127.0.0.1): ' address
    if [[ -z "${address}" ]]; then address="127.0.0.1"; fi

    # The port on which cfssl should listen on.
    local port
    read -p 'Enter the port on which cfssl should listen on(leave empty for default - 8888): ' port
    if [[ -z "${port}" ]]; then port="8888"; fi

    cfssl serve \
        -address "${address}" \
        -ca "$(pwd)/ca/ca.pem" \
        -ca-key "$(pwd)/ca/ca-key.pem" \
        -config "$(pwd)/cfssl_serve_config.json" \
        -port "${port}"
}

trap unmount_ca EXIT

main $@
