#!/bin/bash
if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi
cp -f fancontrol.sh /usr/local/bin/. 
cat /etc/rc.local | grep fancontrol.sh
if [ $? -ne 0 ]
then 
  sed -e '$i \/usr/local/bin/fancontrol.sh &\n' /etc/rc.local > rc.local.new
  cp -f rc.local.new /etc/rc.local
  rm rc.local.new
fi
echo
echo "fancontrol.sh has been installed"
 
