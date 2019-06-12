#!/bin/bash
set -e

rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install kernel-ml -y
grub2-set-default 0
echo
echo
echo
echo "========================DONE========================"
egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \' |head -1
