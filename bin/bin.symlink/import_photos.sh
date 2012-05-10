#!/bin/bash

###########################
# Variables
############
# Moment de l'import
DATE_IMPORT=`date +%F-%R:%S`
# Source des photos : FIXME: recu par l'exterieur?
SRC=/media/disk
# Ou sont les photos
PHOTO=$HOME/photos
PHOTO_TMP=$PHOTO/tmp/$DATE_IMPORT
PHOTO_NEW=$PHOTO/nouveau/$DATE_IMPORT

# Preparation...

cd $PHOTO
mkdir -p $PHOTO_TMP
mkdir -p $PHOTO_NEW


###########################
# L'action
##########

# on prend les photos trouvés sur SRC et les copiés local dans $PHOTO/tmp
cp $SRC $PHOTO_TMP

# Rouler exiftool pour classer selon la date dans PathPhotos
/usr/bin/exiftool -r -d %Y/%m/%d/%Y%m%d_%H%M%S-%%f.%%e "-filename<DateTimeOriginal" $PHOTO_TMP

# Symlinker vers PathPhotos/nouveaux/DATE_IMPORT pour importation par iPhotos et cie.
find 

# Faire une copie vers BackupDest

# Supprimer les photos de la source



############
# Cleanup
