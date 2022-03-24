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

ENV RISCV="/root/riscv-tools-install"
ENV PATH="$RISCV/bin:$PATH"

#RUN git clone --single-branch --depth=1 https://github.com/riscv-collab/riscv-gnu-toolchain &&\
RUN wget https://github.com/riscv-collab/riscv-gnu-toolchain/archive/b9f21e709054d18b101ea464e3b2894d834d023d.zip &&\
            unzip *riscv-gnu-toolchain*.zip &&\
            mv riscv-gnu-toolchain-b9f21e709054d18b101ea464e3b2894d834d023d riscv-gnu-toolchain &&\
                                      cd riscv-gnu-toolchain &&\
                                      mkdir build &&\
                                      cd build &&\
                                      ../configure --prefix=$RISCV &&\
                                      make -j2 && make install 

RUN git clone --single-branch --depth=1 https://github.com/riscv-software-src/riscv-isa-sim&&\
                                      cd riscv-isa-sim &&\
                                      mkdir build &&\
                                      cd build &&\
                                      ../configure --prefix=$RISCV &&\
                                      make -j2 && make install 

RUN git clone --single-branch --depth=1 https://github.com/riscv-software-src/riscv-pk &&\
                                      cd riscv-pk &&\
                                      mkdir build &&\
                                      cd build &&\
                                      ../configure --prefix=$RISCV --host=riscv64-unknown-elf &&\
                                      make -j2 && make install 

ENV LD_LIBRARY_PATH="$RISCV/lib"


FROM ubuntu:20.04 as final
WORKDIR /root
COPY --from=base /root/riscv-tools-install/ ./riscv-tools-install/
ENV RISCV="/root/riscv-tools-install"
ENV PATH="$RISCV/bin:$PATH"
ENV LD_LIBRARY_PATH="$RISCV/lib"

RUN export TZ=Asia/Shanghai && export DEBIAN_FRONTEND=noninteractive && \
              apt-get update && apt-get install -y --no-install-recommends \
               curl \
               git \
               sudo \
               vim\
               ca-certificates \
               keyboard-configuration \
               console-setup \
               apt-utils\
               device-tree-compiler\
               build-essential autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev


CMD ["/bin/sh"]
