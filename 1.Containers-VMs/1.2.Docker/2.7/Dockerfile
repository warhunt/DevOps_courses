# syntax=docker/dockerfile:1
FROM ubuntu:20.04

WORKDIR /opt/ruby2.7.2

ENV DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/Mosco

RUN apt-get update

RUN apt-get -y install curl g++ gcc autoconf \
    automake bison libc6-dev libffi-dev libgdbm-dev \
    libncurses5-dev libsqlite3-dev libtool libyaml-dev \
    make pkg-config sqlite3 zlib1g-dev libgmp-dev libreadline-dev \
    libssl-dev

RUN curl -o /tmp/ruby-2.7.2.tar.gz https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.2.tar.gz

RUN tar -C /opt/ruby2.7.2/ -xvf /tmp/ruby-2.7.2.tar.gz --strip 1

RUN rm /tmp/ruby-2.7.2.tar.gz

RUN ./configure

RUN make

RUN make install

RUN rm -rf /opt/ruby2.7.2/
