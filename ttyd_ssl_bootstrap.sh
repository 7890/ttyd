#!/bin/bash

OUTDIR="${HOME}/ttyd_ssl_cert"

#this script will create the following files in $OUTDIR:

#ca.crt
#ca.key
#ca.srl
#client.crt
#client.csr
#client.key
#client.p12
#client.pem
#server.crt
#server.csr
#server.key

#(to be used with ttyd --ssl options)

which openssl >/dev/null
if [ $? -ne 0 ]; then echo "command 'openssl' not found."; exit 1; fi

cur=`pwd`
mkdir -p "$OUTDIR"
cd "$OUTDIR"

# CA certificate (FQDN must be different from server/client)
openssl genrsa -out ca.key 2048
openssl req -new -x509 -days 365 -key ca.key -subj "/C=CN/ST=GD/L=SZ/O=Acme, Inc./CN=Acme Root CA" -out ca.crt

# server certificate (for multiple domains, change subjectAltName to: DNS:example.com,DNS:www.example.com)
openssl req -newkey rsa:2048 -nodes -keyout server.key -subj "/C=CN/ST=GD/L=SZ/O=Acme, Inc./CN=localhost" -out server.csr
openssl x509 -req -extfile <(printf "subjectAltName=DNS:localhost") -days 365 -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt

# client certificate (the p12/pem format may be useful for some clients)
openssl req -newkey rsa:2048 -nodes -keyout client.key -subj "/C=CN/ST=GD/L=SZ/O=Acme, Inc./CN=client" -out client.csr
openssl x509 -req -days 365 -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt
openssl pkcs12 -export -clcerts -in client.crt -inkey client.key -out client.p12
openssl pkcs12 -in client.p12 -out client.pem -clcerts

ls -ltr
cd "$cur"
echo "done"

#EOF
