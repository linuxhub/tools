#!/bin/bash
#authot: www.linuxhub.org

MegaRpm=MegaCli-8.07.14-1.noarch.rpm
wget https://raw.githubusercontent.com/linuxhub/tools/master/ops/MegaCli/MegaCli-8.07.14-1.noarch.rpm -O $MegaRpm
rpm -ivh $MegaRpm


OSBIT=`/usr/bin/file /bin/ls | awk '{print $3}'`
if [ "$OSBIT" == "64-bit" ]
then
   MegaCommand='/opt/MegaRAID/MegaCli/MegaCli64'
elif [ "$OSBIT" == "32-bit" ]
then
   MegaCommand='/opt/MegaRAID/MegaCli/MegaCli'
else
   echo "This TTY script can not support your OS!!!"
fi

ln -s $MegaCommand /usr/local/bin/MegaCli
ln -s $MegaCommand /opt/MegaCli

rm -rf $MegaRpm
echo -e "\n$MegaCommand"
echo -e "MegaCli -help|-h|?\n"
MegaCli -v