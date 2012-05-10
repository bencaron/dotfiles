#!/bin/bash
# ----------------------------------------------------------------------
# mikes handy rotating-filesystem-snapshot utility
# ----------------------------------------------------------------------
# this needs to be a lot more general, but the basic idea is it makes
# rotating backup-snapshots of /home whenever called
# ----------------------------------------------------------------------
# CETTE VERSION
# avec mes adaptations personnelles.


unset PATH	# suggestion from H. Milz: avoid accidental use of $PATH

# ------------- system commands used by this script --------------------
ID=/usr/bin/id;
ECHO=/bin/echo;

#MOUNT=/bin/mount;
RM=/bin/rm;
MV=/bin/mv;
CP=/bin/cp;
TOUCH=/bin/touch;

RSYNC=/usr/bin/rsync;


# ------------- file locations -----------------------------------------

#MOUNT_DEVICE=/dev/hdb1;
SNAPSHOT_RW=/media/disk/backup;
EXCLUDES=/home/benoit/excludes-from-backup.txt;


# ------------- the script itself --------------------------------------

# make sure we're running as root
if (( `$ID -u` != 0 )); then { $ECHO "Sorry, must be root.  Exiting..."; exit; } fi


# rotating snapshots of /home (fixme: this should be more general)

# step 1: delete the oldest snapshot, if it exists:
if [ -d $SNAPSHOT_RW/home/hourly.4 ] ; then			\
$RM -rf $SNAPSHOT_RW/home/hourly.4 ;				\
fi ;

# step 2: shift the middle snapshots(s) back by one, if they exist
if [ -d $SNAPSHOT_RW/home/hourly.3 ] ; then			\
$MV $SNAPSHOT_RW/home/hourly.3 $SNAPSHOT_RW/home/hourly.4 ;	\
fi;
if [ -d $SNAPSHOT_RW/home/hourly.2 ] ; then			\
$MV $SNAPSHOT_RW/home/hourly.2 $SNAPSHOT_RW/home/hourly.3 ;	\
fi;
if [ -d $SNAPSHOT_RW/home/hourly.1 ] ; then			\
$MV $SNAPSHOT_RW/home/hourly.1 $SNAPSHOT_RW/home/hourly.2 ;	\
fi;

# step 3: make a hard-link-only (except for dirs) copy of the latest snapshot,
# if that exists
if [ -d $SNAPSHOT_RW/home/hourly.0 ] ; then			\
$CP -al $SNAPSHOT_RW/home/hourly.0 $SNAPSHOT_RW/home/hourly.1 ;	\
fi;

# step 4: rsync from the system into the latest snapshot (notice that
# rsync behaves like cp --remove-destination by default, so the destination
# is unlinked first.  If it were not so, this would copy over the other
# snapshot(s) too!
# AJOUT: --sparse
$RSYNC								\
	-va --delete --sparse --delete-excluded				\
	--exclude-from="$EXCLUDES"				\
	/home/ $SNAPSHOT_RW/home/hourly.0 ;

# step 5: update the mtime of hourly.0 to reflect the snapshot time
$TOUCH $SNAPSHOT_RW/home/hourly.0 ;

# and thats it for home.

# now remount the RW snapshot mountpoint as readonly
# REMOVED

