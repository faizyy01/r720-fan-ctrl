#!/bin/bash

function discord() {
        /mnt/cache/appdata/discord.sh-1.4/discord.sh --webhook-url="webhook url here" --text "$@"
}

function discordwarn() {
        /mnt/cache/appdata/discord.sh-1.4/discord.sh --webhook-url="webhook url here" --text "$@"
}

IPMIHOST=idracip
IPMIUSER=username
IPMIPW=password
IPMIEK=0000000000000000000000000000000000000000
FANSPEEDHEX="0x10"

MAXTEMP=50

TEMP=$(ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW -y $IPMIEK sdr type temperature | grep -vi inlet | grep -vi exhaust | grep -Po '\d{2,3}' | tail -1)


if [[ $TEMP > $MAXTEMP ]];
  then
  	
    
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW -y $IPMIEK raw 0x30 0x30 0x01 0x01
    echo "Warning: Temperature is too high! Activating dynamic fan control! ($TEMP C)"
    discordwarn "WARNING - Temperature is too high! - "$TEMP" C"
  else
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW -y $IPMIEK raw 0x30 0x30 0x01 0x00
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW -y $IPMIEK raw 0x30 0x30 0x02 0xff "$FANSPEEDHEX"
    discord "3000 RPM - Temp is OK - "$TEMP" C"
    echo "Activating manual fan speeds! (3000 RPM) Temperature is OK ($TEMP C)"
fi
