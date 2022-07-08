FROM ubuntu:20.04 as base

RUN export TZ=Asia/Shanghai && export DEBIAN_FRONTEND=noninteractive && \
              apt-get update && apt-get install -y --no-install-recommends \
               curl \
               git \
               sudo \
               ca-certificates \
               keyboard-configuration \
               console-setup \
               apt-utils\
               device-tree-compiler\
               build-essential autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev wget unzip
WORKDIR /root

ENV RISCV="/opt/riscv/toolchain"
ENV PATH="$RISCV/bin:$PATH"

FROM base as mid1

RUN git clone --single-branch  https://github.com/riscv-collab/riscv-gnu-toolchain &&\
                                      cd riscv-gnu-toolchain &&\
                                      git checkout b9f21e709054d18b101ea464e3b2894d834d023d &&\
                                      mkdir build &&\
                                      cd build &&\
                                      ../configure --prefix=$RISCV &&\
                                      make 

FROM base as mid2
COPY --from=mid1 /opt/riscv/toolchain /opt/riscv/toolchain
RUN git clone --single-branch  https://github.com/riscv-collab/riscv-gnu-toolchain &&\
                                      cd riscv-gnu-toolchain &&\
                                      git checkout b9f21e709054d18b101ea464e3b2894d834d023d &&\
                                      mkdir build &&\
                                      cd build &&\
                                      ../configure --prefix=$RISCV &&\
                                      make linux

CMD ["/bin/sh"]
