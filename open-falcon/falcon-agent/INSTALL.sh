#!/bin/bash
# Author:   zeping lai
# website:  https://www.linuxhub.org
# Description: open-falcon运维监控Agent客户端

# wget https://raw.githubusercontent.com/linuxhub/tools/master/open-falcon/falcon-agent/INSTALL.sh
# vim INSTALL.sh
# bash INSTALL.sh


#自定义主机名
host_name=""

#服务端配置
falcon_hbs_ip=""
falcon_transfer_ip=""


<<<<<<< HEAD

# 1.Agent自动部署
wget -O /tmp/falcon-agent-5.1.1.tar.gz https://raw.githubusercontent.com/linuxhub/tools/master/open-falcon/falcon-agent/falcon-agent-5.1.1.tar.gz
tar -zxf /tmp/falcon-agent-5.1.1.tar.gz -C /usr/local/
mv /usr/local/falcon-agent-5.1.1 /usr/local/falcon-agent
rm /tmp/falcon-agent-5.1.1.tar.gz
=======
wget -O /tmp/falcon-agent-5.1.1.tar.gz https://raw.githubusercontent.com/linuxhub/tools/master/open-falcon/falcon-agent/falcon-agent-5.1.1.tar.gz
tar -zxf /tmp/falcon-agent-5.1.0.tar.gz -C /usr/local/
mv /usr/local/falcon-agent-5.1.0 /usr/local/falcon-agent
rm /tmp/falcon-agent-5.1.0.tar.gz
>>>>>>> e7ee905b285896c642d5c501118c3792a045d157
wget -O /usr/local/falcon-agent/cfg.json https://raw.githubusercontent.com/linuxhub/tools/master/open-falcon/falcon-agent/cfg.json


if [ "$host_name" == "" ];then
   sed -i "s/GZ-V-L-ZEZE-10/$HOSTNAME/g" /usr/local/falcon-agent/cfg.json
else
   sed -i "s/GZ-V-L-ZEZE-10/$host_name/g" /usr/local/falcon-agent/cfg.json
fi

if [ "$falcon_hbs_ip" != "" ];then
	sed -i "s/127.0.0.1:6030/$falcon_hbs_ip:6030/g" /usr/local/falcon-agent/cfg.json
fi

if [ "$falcon_transfer_ip" != "" ];then
	sed -i "s/127.0.0.1:8433/$falcon_transfer_ip:8433/g" /usr/local/falcon-agent/cfg.json
fi


chmod +x /usr/local/falcon-agent/cfg.json
/usr/local/falcon-agent/control start
echo "/usr/local/falcon-agent/control start" >> /etc/rc.local

<<<<<<< HEAD


# 2.Agent程序异常自愈恢复脚本
is_crond=`rpm -qa | grep crontabs | wc -l`
if [ $is_crond == 0 ];then
        yum -y install crontabs
        service crond start
        chkconfig crond on
else
        service crond start
        chkconfig crond on
if

cron_file="/var/spool/cron/root"
if [ ! -f "$cron_file" ];then
        touch $cron_file
fi

mkdir -p /data/app
wget -O /data/app/check.falcon.agent.sh https://raw.githubusercontent.com/linuxhub/tools/master/open-falcon/falcon-agent/check.falcon.agent.sh
chmod +x /data/app/check.falcon.agent.sh
echo "*/5 * * * * /bin/bash /data/app/check.falcon.agent.sh" >> $cron_file 
=======
#监控脚本部分
mkdir -p /data/app

is_crond=`rpm -qa | grep crontabs | wc -l`
if [ $is_crond == 0 ];then
	yum -y install crontabs
if
service crond start
chkconfig crond on

wget -O /data/app/check.falcon.agent.sh https://raw.githubusercontent.com/linuxhub/tools/master/open-falcon/falcon-agent/check.falcon.agent.sh
chmod +x /data/app/check.falcon.agent.sh
echo "*/5 * * * * /bin/bash /data/app/check.falcon.agent.sh" >> /var/spool/cron/root 




>>>>>>> e7ee905b285896c642d5c501118c3792a045d157
