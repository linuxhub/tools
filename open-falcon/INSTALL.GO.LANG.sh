#!/bin/bash
#author: zepinglai
#安装GO语言环境
#脚本自动安装 wget -q -O - https://raw.githubusercontent.com/linuxhub/tools/master/open-falcon/INSTALL.GO.LANG | bash

mkdir -p /data/down
mkdir -p /data/app/golang

wget -O /data/down/go1.10.2.linux-amd64.tar.gz https://dl.google.com/go/go1.10.2.linux-amd64.tar.gz
tar -C /usr/local -xzf /data/down/go1.10.2.linux-amd64.tar.gz

echo "export GOROOT=/usr/local/go" >> /etc/profile
echo "export GOBIN=\$GOROOT/bin" >> /etc/profile
echo "export PATH=\$PATH:\$GOBIN" >> /etc/profile
echo "export GOPATH=/data/app/golang" >> /etc/profile
source /etc/profile

go version



