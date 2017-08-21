# tunnel-deploy

Deploy yassg (Yet Another ShadowSocks in Golang) on systems has yum.
Support autorun when system boot on both upstart & systemd.

Usage:
```bash
curl https://raw.githubusercontent.com/andwxh/tunnel-deploy/master/install-with-yum.sh |bash -s <password> <port>
```

Note that encryption algorithm will be set to aes-256-cfb.
