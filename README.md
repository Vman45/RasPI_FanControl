# RasPI_FanControl
## Temperature controlled fan for the Raspberry PI
To install do the following as the pi user on your Raspberry Pi  
  
sudo apt update  
sudo apt install git  
git clone https://github.com/ZS6TVB/RasPI_FanControl  
cd RasPI_FanControl  
chmod +x install.sh  
sudo ./install.sh  
  
That should be it.  On reboot the fan should run for 30s if temperature is below the threshold or keep on running if above the threshold.  
Edit /usr/local/bin/fancontrol.sh to change fan temperature thresholds  
All fan fancontrol.sh on/off states are logged to /var/log/messages


