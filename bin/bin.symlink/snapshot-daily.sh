#!/bin/bash

if [ -d /media/disk-1/backup/ ] ; then
    /usr/bin/rsnapshot -q -c /etc/rsnapshot.conf.hdusb daily
    echo `date` > /media/disk-1/backup/lastbackup.daily
fi
