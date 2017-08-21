#!/bin/bash
set -e

cd $(dirname $0)


if [ "$#" != "2" ]; then
	echo "Argument number wrong."
	exit 1
fi
YASSG_PASSWORD="$1"
YASSG_PORT="$2"


function ensure_installed
{
	pkgName="$1"
	echo "Checking package: $pkgName"
	if [ "$(which $pkgName >/dev/null 2>&1; echo $?)" != 0 ]; then
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


function init_systemd
{
	echo "Initializing systemd..."
	echo "
[Unit]
Description=yassg
After=network.target
 
[Service]
Type=simple
ExecStart=/root/tunnel-deploy-master/yassg/yassg_linux_amd64 -p $YASSG_PASSWORD server -l 0.0.0.0:$YASSG_PORT
ExecStop=$(which pkill) yassg
PrivateTmp=true
 
[Install]
WantedBy=multi-user.target
" >/usr/lib/systemd/system/yassg.service

	systemctl daemon-reload
	systemctl enable yassg
	systemctl start yassg
}

function init_upstart
{
	echo "Initializing upstart..."
	echo "
#!/bin/bash
#
# yassg
#
# chkconfig: 2345 85 15
# description: yassg

start(){
	nohup /root/tunnel-deploy-master/yassg/yassg_linux_amd64 -p $YASSG_PASSWORD server -l 0.0.0.0:$YASSG_PORT >/var/log/yassg.log 2>&1 &
}
stop(){
        pkill yassg
}

case \"\$1\" in
start)
        start
        ;;
stop)
        stop
        ;;
restart)
	stop
	start
        ;;
*)
        echo \"Usage: \$0 {start|restart|stop}\"
        exit 1
        ;;
esac
" >/etc/init.d/yassg
	chmod +x /etc/init.d/yassg

	service yassg start 
	chkconfig yassg on
}

if [ "$(rpm -q systemd >/dev/null; echo $?)" == "0" ]; then
	init_systemd
elif [ "$(rpm -q upstart >/dev/null; echo $?)" == "0" ]; then
	init_upstart
else
	echo "Error: upstart / systemd not found!"
	exit 1
fi
