#!/bin/sh

# amixer options
mute_switch="Master" # For Asus EEE, this is iSpeaker
channel="Master" # usually Master. You can set this to PCM to keep headphone volume unchanged.
card=0;
VOL_STEP=2    # amount to increase / decrease volume
# osd_cat options
POS=bottom      # top, middle or bottom
ALIGN=center    # left, center or right
OFFSET=0        # offset from the top or bottom
COLOR=green     # white, blue, yellow, cyan, magenta, etc
MUTECOLOR=brown # color to use instead when muted
SHADOW=2        # offset of shadow, 0 for none
DELAY=3         # seconds to show the OSD
AGE=0           # seems broken :\
BARMODE=slider  # percentage or slider
FONT=-*-helvetica-medium-r-*-*-*-320-*-*-*-*-*-*

if [ "$1" = "mute" ]; then
    amixer -c $card set ${mute_switch} toggle
elif [ "$1" = "up" ]; then
    amixer -c $card set ${channel} $VOL_STEP+
elif [ "$1" = "down" ]; then
    amixer -c $card set ${channel} $VOL_STEP-
else
    echo "Usage: $0 up|down|mute"
    exit 1
fi

STATUS=$(amixer -c 0 sget ${mute_switch} | awk '$0 ~ "\\[off\\]" { print $NF; exit; }' )
VOLUME=$(amixer -c 0 sget ${channel}  | awk '$0 ~ "%" { vol=$(NF-2); gsub("\\[", "", vol); gsub("\\]", "",vol); print vol; exit; }' )
if [ "${STATUS}" = '[off]' ]; then
    STATUS=" (muted)"
    COLOR=$MUTECOLOR
else
    STATUS=""
fi

killall osd_cat

#osd_cat -w -p $POS -c $COLOR -s $SHADOW -a $AGE -d $DELAY -o $OFFSET -A $ALIGN \
#-b $BARMODE -P $VOLUME -f $FONT -l 1 -T "Volume: $VOLUME$STATUS"
