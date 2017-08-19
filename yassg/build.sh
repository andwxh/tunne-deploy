#!/bin/bash

set -e
cd $(dirname $0)

# Create & set the temporary GOPATH
mkdir -p goPath
cd goPath
export GOPATH=$PWD
echo "GOPATH: $GOPATH"
cd ..


# Build files
echo "Initialize files..."
git clone https://github.com/andwxh/yassg.git
mv yassg/* goPath/
rm -rf yassg
go get github.com/urfave/cli
echo "Initialize files...Done"


# Cross-compile
target_os="
darwin
linux
windows
"
target_arch="
amd64
"
for os in $target_os; do
	for arch in $target_arch; do
		printf "Building ${os}_${arch}..."
		export GOOS=$os
		export GOARCH=$arch
		go build goPath/src/main.go
		if [ "$os" != "windows" ]; then
			mv main yassg_${os}_${arch}
		else
			mv main.exe yassg.exe
		fi
		echo "Done"
	done
done
