# tunnel-deploy

Deploy yassg (Yet Another ShadowSocks in Golang) on systems that has yum.

Support auto run on startup by using upstart or systemd.

Usage:
```bash
curl https://raw.githubusercontent.com/andwxh/tunnel-deploy/master/install-with-yum.sh |sudo -i bash -s <password> <port>

curl https://raw.githubusercontent.com/andwxh/tunnel-deploy/master/install-new-kernel-centos7.sh |sudo bash -s

curl https://raw.githubusercontent.com/andwxh/tunnel-deploy/master/enable-bbr.sh |sudo bash -s
```

Note that encryption algorithm will be set to aes-256-cfb.
