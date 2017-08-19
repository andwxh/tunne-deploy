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
printf "Initial building..."
go get github.com/xtaci/kcptun/client
go get github.com/xtaci/kcptun/server
echo "Done"


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
		go build github.com/xtaci/kcptun/client
		go build github.com/xtaci/kcptun/server
		if [ "$os" != "windows" ]; then
			mv client client_${os}_${arch}
			mv server server_${os}_${arch}
		fi
		echo "Done"
	done
done
