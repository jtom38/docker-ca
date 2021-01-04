FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
      apt install \
      openssl -y

RUN mkdir /ca

COPY overlay /

RUN /ca/scripts/00init.sh /ca

