#!/usr/bin/env bash

CERT_DIR="$(pwd)/ca/cert"

echo "Deleting generated certs..."
rm -rf "${CERT_DIR}"

echo "Removing Kubernetes Secret for certs..."
kubectl delete secret certs

echo "Removing Kubernetes Secret for gossip encryption key..."
kubectl delete secret consul-gossip-key

echo "Done."