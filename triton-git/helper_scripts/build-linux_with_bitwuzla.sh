#!/usr/bin/env bash

mkdir build-linux-with-bitwuzla ; cd build-linux-with-bitwuzla

cmake .. \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DLLVM_INTERFACE=ON \
    -DCMAKE_PREFIX_PATH=$(llvm-config-14 --prefix) \
    -DBITWUZLA_INTERFACE=ON
    #-DPYTHON_EXECUTABLE=/home/$USER/.pyenv/versions/3.11.10/bin/python \
    #-DPYTHON_LIBRARIES=/home/$USER/.pyenv/versions/3.11.10/lib/libpython3.11.so \
    #-DPYTHON_INCLUDE_DIRS=/home/$USER/.pyenv/versions/3.11.10/include/python3.11 \
    #-DBITWUZLA_INCLUDE_DIRS=/usr/include/bitwuzla/

make -j3
