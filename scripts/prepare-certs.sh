#!/usr/bin/env bash

CONFIG_DIR="$(pwd)/ca/config"
CERT_DIR="$(pwd)/ca/cert"

mkdir -p "${CERT_DIR}"
cd "${CONFIG_DIR}"

echo "Generating CA..."

cfssl gencert -initca ca-csr.json | cfssljson -bare "${CERT_DIR}"/ca

echo "Generating certs..."

cfssl gencert \
    -ca=../cert/ca.pem \
    -ca-key=../cert/ca-key.pem \
    -config=ca-config.json \
    -profile=default \
    root-csr.json | cfssljson -bare "${CERT_DIR}"/root


echo "Creating Kubernetes Secret for certs..."

cd "${CERT_DIR}"

kubectl create secret generic certs \
  --from-file="ca.pem=ca.pem" \
  --from-file="ca-key.pem=ca-key.pem" \
  --from-file="root.pem=root.pem" \
  --from-file="root-key.pem=root-key.pem"

echo "Creating Kubernetes Secret for gossip encryption key..."

GOSSIP_ENCRYPTION_KEY="$(consul keygen)"
kubectl create secret generic consul-gossip-key \
  --from-literal="key=${GOSSIP_ENCRYPTION_KEY}"

echo "Done."