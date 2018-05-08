#!/bin/bash
# Author:   zeping lai
# website:  https://www.linuxhub.org
# Description: 监控falcon-agent进程异常自启动

# mkdir /data/app/
# chmod +x /data/app/check.falcon.agent.sh
# */5 * * * * /bin/bash /data/app/check.falcon.agent.sh


pid_file=/usr/local/falcon-agent/var/app.pid
p_stat=`ps -efl | grep -v grep | grep falcon-agent | wc -l`

if [ $p_stat -le 0 ];then
   if [ -f "$pid_file" ];then
        rm -rf $pid_file
   fi
   /usr/local/falcon-agent/control start > /dev/null
fi
