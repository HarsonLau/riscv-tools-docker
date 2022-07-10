FROM harsonlau/riscv-toolchain:latest as base
WORKDIR /root

ENV RISCV="/opt/riscv/toolchain"
ENV PATH="$RISCV/bin:$PATH"

RUN git clone --single-branch --depth=1 https://github.com/riscv-software-src/riscv-isa-sim&&\
                                      cd riscv-isa-sim &&\
                                      mkdir build &&\
                                      cd build &&\
                                      ../configure --prefix=$RISCV &&\
                                      make -j2 && make install && cd /root && rm -rf riscv-isa-sim/

RUN git clone --single-branch --depth=1 https://github.com/riscv-software-src/riscv-pk &&\
                                      cd riscv-pk &&\
                                      mkdir build &&\
                                      cd build &&\
                                      ../configure --prefix=$RISCV --host=riscv64-unknown-elf &&\
                                      make -j2 && make install && make clean &&\
                                      ../configure --prefix=$RISCV --host=riscv64-unknown-linux-gnu &&\
                                      make -j2 && make install && make clean &&\
                                      cd /root && rm -rf riscv-pk/
                                      
ENV LD_LIBRARY_PATH="$RISCV/lib:$LD_LIBRARY_PATH"
ENV LINUX_PK="/opt/riscv/toolchain/riscv64-unknown-linux-gnu/bin/pk"
ENV PK="/opt/riscv/toolchain/riscv64-unknown-elf/bin/pk"

RUN git clone --single-branch --depth=1 https://github.com/lshpku/rv8-riscv-ckpt.git&&\
                                    cd rv8-riscv-ckpt&&\
                                    git submodule update --init --recursive&&\
                                    make -j2 && make install

CMD ["/bin/sh"]
