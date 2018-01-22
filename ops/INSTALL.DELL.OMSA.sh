#!/bin/bash
#author: www.linuxhub.org
#安装路径：/opt/dell/srvadmin/
#启动OMSA: /opt/dell/srvadmin/sbin/srvadmin-services.sh start
#服务端口：https://localhost:1311

yum install -y net-snmp net-snmp-devel net-snmp-utils wget perl OpenIPMI
wget -q -O - http://linux.dell.com/repo/hardware/latest/bootstrap.cgi | bash
yum  -y install srvadmin-all                        
/opt/dell/srvadmin/sbin/srvadmin-services.sh start
ln -s /opt/dell/srvadmin/bin/omreport /usr/local/bin/