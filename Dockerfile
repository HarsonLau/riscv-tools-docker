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
                                      make -j2 && make install && cd /root && rm -rf riscv-pk/
                                      
ENV LD_LIBRARY_PATH="$RISCV/lib:$LD_LIBRARY_PATH"

RUN git clone --single-branch --depth=1 https://github.com/lshpku/rv8-riscv-ckpt.git&&\
                                    cd rv8-riscv-ckpt&&\
                                    git submodule update --init --recursive&&\
                                    make -j2 && make install && cd /root && rm -rf rv8-riscv-ckpt/

CMD ["/bin/sh"]
