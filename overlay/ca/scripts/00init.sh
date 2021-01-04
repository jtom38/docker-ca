#!/bin/bash
DIR=$1

ROOT=${DIR}/root
mkdir ${DIR}/root
cd ${ROOT}
mkdir certs crl newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial

INT=${DIR}/intermediant
#mkdir ${INT}
cd ${INT}
mkdir certs crl csr newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial
echo 1000 > crlnumber

mkdir ${DIR}/export
