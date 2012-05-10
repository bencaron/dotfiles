#!/bin/bash

if [ -d /media/disk-1/backup/ ] ; then
    /usr/bin/rsnapshot -q -c /etc/rsnapshot.conf.hdusb hourly
    echo `date` > /media/disk-1/backup/lastbackup
fi
