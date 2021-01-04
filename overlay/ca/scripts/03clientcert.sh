#!/bin/bash

# This defines the hostname for the cert
HOST=${1}

# This defines if the cert is for user or server
# 'server_cert'
# 'usr_cert'
TYPE=${2}

INT=/ca/intermediate
INTPRIVATE=${INT}/private
INTCSR=${INT}/csr
INTPCERTS=${INT}/certs
KEY=${HOST}.key.pem
CSR=${HOST}.csr.pem
CERT=${HOST}.cert.pem

EXPORTDIR=/ca/export

echo "\r\nHost=${HOST}\r\nType=${TYPE}"
echo "\r\nGenerating '${HOST}' key file"
cd /ca
openssl genrsa -aes256 -out ${PRIVATE}/${KEY} 2048

# 400 sets it a read only to the user and no one else
echo "\r\nSetting '${KEY}' as read only."
chmod 400 ${PRIVATE}/${KEY}


echo "\r\nGenerate CSR"
openssl req -config /ca/intermediate/openssl.cnf \
      -key ${PRIVATE}/${KEY} \
      -new -sha256 -out ${INTCSR}/${CSR}

echo "\r\nGenerating cert"
openssl ca -config ${INT}/openssl.cnf \
      -extensions ${TYPE} -days 375 -notext -md sha256 \
      -in ${INTCSR}/${CSR} \
      -out ${INTCERTS}/${CERT}

# Sets the cert file to read for everyone
chmod 444 ${INTCERTS}/${CERT}

echo "\r\n Checking if the cert was added to the index."
tail ${INT}/index.txt

echo "\r\nChecking the cert"
openssl x509 -noout -text -in ${INTCERTS}/${CERT}

echo "\r\nChecking the cert against the chain"
openssl verify -CAfile ${INTCERTS}/ca-chain.cert.pem \
      ${INTCERTS}/${CERT}

cp ${INTPRIVATE}/${KEY} ${EXPORTDIR}
cp ${INTCERTS}/${CERT} ${EXPORTDIR}

echo "\r\nIf everything is good, deploy the following files to a server."
echo " * ${INTPRIVATE}/${KEY}"
echo " * ${INTCERTS}/${KEY}"

