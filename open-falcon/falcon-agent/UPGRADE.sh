#!/bin/bash
# Author:   zeping lai
# website:  https://www.linuxhub.org
# Description: 更新open-falcon运维监控Agent客户端 upgrade

# 自动执行： wget --no-check-certificate -q -O -https://raw.githubusercontent.com/linuxhub/tools/master/open-falcon/falcon-agent/UPGRADE.sh | bash

if [ ! -f "/usr/local/falcon-agent/cfg.json" ];then
	echo "No Falcon-Agent"
    exit
fi

wget --no-check-certificate -O /tmp/falcon-agent-5.1.1.tar.gz https://raw.githubusercontent.com/linuxhub/tools/master/open-falcon/falcon-agent/falcon-agent-5.1.1.tar.gz
tar -zxf /tmp/falcon-agent-5.1.1.tar.gz -C /usr/local/

mv /usr/local/falcon-agent /tmp/falcon-agent 

mv /usr/local/falcon-agent-5.1.1 /usr/local/falcon-agent
cp /tmp/falcon-agent/cfg.json  /usr/local/falcon-agent/cfg.json

if [ "$version" == "5.1.1" ];then
	echo "版本升级成功: falcon-agent 5.1.1"
	rm -rf /tmp/falcon-agent-5.1.1.tar.gz
	rm -rf /tmp/falcon-agent
else
	echo "版本升级失败"
	rm -rf /usr/local/falcon-agent
	mv /tmp/falcon-agent /usr/local/falcon-agent
fi

