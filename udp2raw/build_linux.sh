#!/bin/bash


cd $(dirname $0)
wdir=$PWD


# Preparing files
mkdir -p git
cd git
git clone https://github.com/andwxh/udp2raw-tunnel.git
cd udp2raw-tunnel
git checkout 2698ec93951258d33543816c0a54eab3d1515f49
tail -n +2 CMakeLists.txt >tmp
mv tmp CMakeLists.txt


# Build
cmake .
make


mv udp2raw $wdir/udp2raw_linux
cd $wdir
