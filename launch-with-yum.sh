#!/bin/bash
set -e

cd $(dirname $0)

YASSG_PASSWORD="$1"
YASSG_PORT="$2"

function ensure_installed
{
	pkgName="$1"
	which $pkgName >/dev/null 2>&1
	if [ $? != 0 ]; then
		echo "Installing $pkgName ..."
		yum install -y $pkgName
		echo "Installing $pkgName ...Done"
	fi
}
ensure_installed wget
ensure_installed git
ensure_installed unzip
ensure_installed pkill


echo "Start downloading package..."
wget https://github.com/andwxh/tunnel-deploy/archive/master.zip
unzip master.zip
rm master.zip


echo "Installing service..."
echo "
[Unit]
Description=yassg
After=network.target
 
[Service]
Type=simple
ExecStart=/root/tunnel-deploy-master/yassg/yassg_linux_amd64 -p $YASSG_PASSWORD server -l 0.0.0.0:$YASSG_PORT start
ExecStop=$(which pkill) yassg
PrivateTmp=true
 
[Install]
WantedBy=multi-user.target
" >/usr/lib/systemd/system/yassg.service

systemctl daemon-reload
systemctl enable yassg
systemctl start yassg
