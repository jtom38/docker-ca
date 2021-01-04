#!/bin/bash

DIR=/ca/
ROOT=/ca/root
CONFIG=${DIR}/openssl.cnf
PRIVATE=${ROOT}/private/ca.key.pem
CERT=${ROOT}/certs/ca.cert.pem

# Clear the screen
#clear

echo "> making the root key"
openssl genrsa -aes256 -out ${PRIVATE} 4096
chmod 400 ${PRIVATE}

echo ""
echo "> making the root cert"
echo "Note: You will need to define the following at minimum:"
echo "* countryName"
echo "* stateOrProvinceName"
echo "* organizationName"

openssl req -config ${CONFIG} \
      -key ${PRIVATE} \
      -new -x509 -days 7300 -sha256 -extensions v3_ca \
      -out ${CERT}
chmod 444 ${CERT}

echo ""
echo "> Verify the root cert"
openssl x509 -noout -text -in ${CERT}
