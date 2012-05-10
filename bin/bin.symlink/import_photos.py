#!/usr/bin/python
# -*- coding: iso-8859-1 -*-

import sys, os, datetime

# Variables

# Moment de l'import
#DATE_IMPORT=`date +%F-%R:%S`
date_import = datetime.datetime.today().strftime("%F-%R:%S")

# Source des photos : FIXME: recu par l'exterieur?
PathSRC= sys.argv[1] or '/media/disk'

# Ou vont les photos
PathPhotos = os.getenv('HOME') + os.sep + 'photos'


print "date, pathsrc, pathphotos: %s, %s, %s" % (date_import, PathSRC, PathPhotos)

###########################
# L'action
##########

# on boucle pour prendre les photos trouvés sur SRC et les copiés local dans $PHOTO/tmp

# Rouler exiftool pour classer selon la date dans PathPhotos

# Symlinker vers PathPhotos/nouveaux/DATE_IMPORT pour importation par iPhotos et cie.

# Faire une copie vers BackupDest

# Supprimer les photos de la source

