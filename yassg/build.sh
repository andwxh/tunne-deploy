#!/bin/bash

set -e
cd $(dirname $0)

# Create & set the temporary GOPATH
mkdir -p goPath
cd goPath


# Build files
echo "Initialize files..."
git clone https://github.com/andwxh/yassg.git
cd yassg
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
		go build
		if [ "$os" != "windows" ]; then
			mv yassg ../../yassg_${os}_${arch}
		else
			mv yassg.exe ../../yassg.exe
		fi
		echo "Done"
	done
done


# Clean-up
cd ../..
rm -rf goPath
