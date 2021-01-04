#! /bin/bash
INT=/ca/intermediant
CONFIG=${INT}/openssl.cnf
PRIVATE=${INT}/private/int.key.pem
CSR=${INT}/csr/int.csr.pem
CERT=${INT}/certs/int.cert.pem
CHAIN=${INT}/certs/ca-chain.cert.pem

ROOTCERT=/ca/root/certs/ca.cert.pem
#clear

echo "Generating Intermediant Key"
cd /ca/
openssl genrsa -aes256 -out ${PRIVATE} 4096
chmod 400 ${PRIVATE}

echo ""
echo "Generating Intermediant CSR"
echo "The following are required at a minimum:"
echo "* countryName"
echo "* statOrProvinceName"
echo "* organizationName"
echo "* organizationUnitName"
echo "* commonName"

openssl req -config ${INT}/openssl.cnf -new -sha256 \
  -key ${PRIVATE} \
  -out ${CSR}

echo ""
echo "Generate Intermediant Cert"

cd /ca/
openssl ca -config openssl.cnf \
  -extensions v3_intermediate_ca \
  -days 3650 -notext -md sha256 \
  -in ${CSR} \
  -out ${CERT}

echo ""
echo "Setting '${CERT}' to Read only."
chmod 444 ${CERT}

openssl x509 -noout -text \
      -in ${CERT}

echo ""
echo "Confirming that the local db updated."
echo "(tail /ca/index.txt)"
tail /ca/index.txt

echo ""
echo "Verify the int cert againt our root cert."
openssl verify -CAfile ${ROOTCERT} ${CERT}

echo "\r\nGenerating the Certificate Chain"
cat ${CERT} ${ROOTCERT} > ${CHAIN}

echo "Setting chain server to read only."
chmod 444 ${CHAIN}
