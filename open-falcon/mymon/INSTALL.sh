#!/bin/bash
# Author:   zeping lai
# website:  https://www.linuxhub.org
# Description: open-falcon运维监控 mysql数据库监控

# 脚本自动安装 wget --no-check-certificate -q -O - https://raw.githubusercontent.com/linuxhub/tools/master/open-falcon/mymon/INSTALL.sh  | bash


if [ ! -f "/usr/local/falcon-agent/cfg.json" ];then
	echo "No Falcon-Agent"
    exit
fi

wget --no-check-certificate -O /tmp/mymon.tar.gz https://raw.githubusercontent.com/linuxhub/tools/master/open-falcon/mymon/mymon.tar.gz
tar -zxf /tmp/mymon.tar.gz -C /usr/local/
rm -rf /tmp/mymon.tar.gz

endpoint=`cat /usr/local/falcon-agent/cfg.json  | grep hostname | cut -d ":" -f2 |  sed 's/",*//g' | sed 's/^[ \t]*//g'`
sed -i "s/endpoint=/endpoint=$endpoint/g" /usr/local/mymon/etc/mon.cfg
echo "*/1 * * * * cd /usr/local/mymon && ./mymon -c etc/mon.cfg" >> /var/spool/cron/root

echo " -- mymon部署完成 --"
echo "配置连接数据帐号密码"
echo "配置文件: /usr/local/mymon/etc/mon.cfg"