#/usr/bin/env bash

cd gen &&
rm -f * &&
g++ -fada-spec-parent=dlx -fdump-ada-spec -C /usr/include/dlfcn.h
