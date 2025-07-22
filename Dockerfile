FROM ubuntu:24.04

ENV BUILD_DIR=/usr/local/src

ENV VIRTUAL_ENV=/opt/venv

ENV BARVINOK_VER=0.41.8
ENV NTL_VER=11.5.1

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata \
    && apt-get install -y --no-install-recommends \
                       locales \
                       curl \
                       git \
                       wget \
                       python3-dev \
                       python3-pip \
                       python3-venv \
                       scons \
                       make \
                       autotools-dev \
                       autoconf \
                       automake \
                       libtool \
                       g++ \
                       cmake \
                       graphviz

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
                       libconfig++-dev \
                       libyaml-cpp-dev \
                       libtinfo-dev \
                       libgpm-dev \
                       libgmp-dev

RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

WORKDIR $BUILD_DIR
RUN wget https://libntl.org/ntl-$NTL_VER.tar.gz \
    && tar -xvzf ntl-$NTL_VER.tar.gz \
    && cd ntl-$NTL_VER/src \
    && ./configure NTL_GMP_LIP=on SHARED=on NATIVE=off \
    && make \
    && make install

WORKDIR $BUILD_DIR
RUN wget https://barvinok.sourceforge.io/barvinok-$BARVINOK_VER.tar.gz \
    && tar -xvzf barvinok-$BARVINOK_VER.tar.gz \
    && cd barvinok-$BARVINOK_VER \
    && ./configure --enable-shared-barvinok \
    && make \
    && make install

WORKDIR $BUILD_DIR
RUN wget -O islpy-2024.2.tar.gz https://github.com/inducer/islpy/archive/refs/tags/v2024.2.tar.gz \
    && tar -xvzf islpy-2024.2.tar.gz \
    && cd islpy-2024.2 \
    && ./configure.py --no-use-shipped-isl --no-use-shipped-imath --isl-inc-dir=/usr/local/include --isl-lib-dir=/usr/local/lib --use-barvinok \
    && pip3 install .
