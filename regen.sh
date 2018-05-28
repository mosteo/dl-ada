#/usr/bin/env bash

cd gen &&
rm -f * &&
g++ -fdump-ada-spec -C /usr/include/dlfcn.h
