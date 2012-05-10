#!/bin/bash

if [ -d /media/disk-1/backup/ ] ; then
    /usr/bin/rsnapshot -q -c /etc/rsnapshot.conf.hdusb weekly
    echo `date` > /media/disk-1/backup/lastbackup.weekly
fi
