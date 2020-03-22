#!/bin/sh

# ON and OFF states in degrees Celcius.  
# Ensure ON temperature is higher than off temperature

GPIOPIN=21 	#The GPIO pin used to control the fan.  GPIO21 = pin 40 on the header
TON=50 		#Temperature at which to switch fan on
TOFF=40 	#Temperature at which to switch fan off
PSTATE=0 	#The initial state of the fan is set to OFF State (0)
STARTRUN=1	#Run the fan on startup 0=off 1=on
STARTTIME=30	#Time in seconds to run the fan at startup if STARTRUN is set to 1 (enabled)

SCRIPTNAME=`basename "$0"`

log()
{
	logger $1 
}

# Init fan control on $GPIOPIN
if [ ! -f /sys/class/gpio/gpio$GPIOPIN/value ]
then
  echo $GPIOPIN > /sys/class/gpio/export
fi
# define GPIO pin as output
echo out > /sys/class/gpio/gpio$GPIOPIN/direction
# set pin value to OFF (0) for starters
echo 0 > /sys/class/gpio/gpio$GPIOPIN/value

echo "$SCRIPTNAME - Startup --- Logging to /var/log/syslog"
log "$SCRIPTNAME - Startup"

if [ $STARTRUN -eq 1 ]
then
	log "$SCRIPTNAME - Starting fan for the set $STARTTIME second period"
	echo 1 > /sys/class/gpio/gpio$GPIOPIN/value
	sleep $STARTTIME
	DT=`date +%H:%M` # Get timestamp
	log "$SCRIPTNAME - Fan startup run complete. Reverting to temperature control."
	PSTATE=1
fi

while [ 1 ]
do
        DT=`date +%H:%M` # Get timestamp
        T=`cat /sys/class/thermal/thermal_zone0/temp` # Get the temperature
        TT=$(( $T/1000 )) # Remove extra 3 decimals from temperature reading
        if [ $TT -ge $TON ]
        then
                if [ $PSTATE -ne 1 ]
                then
                        log "$SCRIPTNAME - CPU Temperature $TT Degrees C, Fan ON"
                        PSTATE=1
                        echo 1 > /sys/class/gpio/gpio$GPIOPIN/value
                fi
        fi
        if [ $TT -le $TOFF ]
        then
                if [ $PSTATE -ne 0 ]
                then
                        log "$SCRIPTNAME - CPU Temperature $TT Degrees C, Fan OFF"
                        PSTATE=0
                        echo 0 > /sys/class/gpio/gpio$GPIOPIN/value
                fi
        fi
        sleep 5
done
