#!/usr/bin/env bash

# This script initializes the intermediate certificate authority.

function main() {
    # Create the cryfs encrypted directory.
    cryfs "$(pwd)/secure" "$(pwd)/ca"

    # Copy templates inside the decrypted directory and wait for them to be edited.
    cp templates/* ca/
    read -p 'Edit the json configuration files, then press return to continue. '

    # Generate the intermediate private key
    cfssl genkey \
        -initca \
        "$(pwd)/ca/csr.json" \
        | cfssljson -bare "$(pwd)/ca/ca"

    # The root certificate
    local root_ca
    read -p 'Root certificate to use for signing: ' root_ca
    printf "\n"
    # The root private key
    local root_ca_key
    read -p 'Root private key to use for signing: ' root_ca_key

    # Sign the intermediate using the root certificate
    cfssl sign \
        -ca "${root_ca}" \
        -ca-key "${root_ca_key}" \
        --config "$(pwd)/ca/config.json" \
        -profile "intermediate" \
        "$(pwd)/ca/ca.csr" \
        | cfssljson -bare "$(pwd)/ca/ca"

    printf "%s\n" "Done!"
}

main $@
