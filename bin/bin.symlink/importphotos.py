#!/usr/bin/python
# -*- coding: iso-8859-1 -*-

import sys, os, datetime, re, shutil

# Variables

# Moment de l'import
#DATE_IMPORT=`date +%F-%R:%S`
date_import = datetime.datetime.today().strftime("%F-%R:%S")

# Source des photos : FIXME: recu par l'exterieur?
if len(sys.argv) > 1:
    PathSRC = sys.argv[1] 
else:
    PathSRC = '/media/disk'

# Ou vont les photos
PathPhotos = os.getenv('HOME') + os.sep + 'photos'
PathFilms = "%s/films/%s" % (PathPhotos, datetime.datetime.today().strftime("%Y/%m"))
PathTMP = "%s/tmp/%s" %(PathPhotos, date_import)

print "date, pathsrc, pathphotos: %s, %s, %s" % (date_import, PathSRC, PathPhotos)

###########################
# L'action
##########

# on boucle pour prendre les photos trouvés sur SRC et les copiés local dans $PHOTO/tmp/[date]
os.makedirs(PathTMP)
#os.copytree(PathSRC, PathTMP)
findcmd = "find %s -type f -exec cp {} %s \; " % (PathSRC, PathTMP)
#findcmd = "find %s -type f -exec rsync -a {} %s \; -print " % (PathSRC, PathTMP)
print findcmd
os.popen(findcmd).readlines()

# Rouler exiv2 pour classer selon la date dans PathPhotos
#exiv2 mv -r "%Y%m%d_%H%M%S-:basename:"
for foto in os.listdir(PathTMP):
    # traite filmsa
    if re.search(r'\.AVI$', foto):
        shutil.move("%s/%s" % (PathTMP, foto),  PathFilms)
    else:
        # photos
        os.popen('exiv2 mv -r "' + r"%Y%m%d_%H%M%S-:basename:" + '" %s/%s' % (PathTMP, foto))
        #print 'echo exiv2 mv -r \"' + r"%Y%m%d_%H%M%S-:basename:" + "\" %s/%s" % (PathTMP, foto)

# Copier dans une hiéarchie qui correspond au nom du fichier
# et symlinker vers dir d'importation en passant
PathImport = "%s/%s/importation/%s" %(PathPhotos, datetime.datetime.today().strftime("%Y"), date_import)
os.makedirs(PathImport)
# preparation pour symlinker
os.chdir(PathImport)

pattern = re.compile("(\d{4})(\d{2})(\d{2})")
for foto in os.listdir(PathTMP):
    m = pattern.search(foto)
    path = "%s/%s/%s" % ( m.group(1), m.group(2), m.group(3))
    if not os.path.isdir("%s/%s" % ( PathPhotos, path)):
        os.makedirs("%s/%s" % ( PathPhotos, path) )
    shutil.move("%s/%s" % (PathTMP, foto), "%s/%s" % (PathPhotos, path))
    # Symlinker vers PathPhotos/nouveaux/DATE_IMPORT pour importation par iPhotos et cie.
    # FIXME ; faire un symlink
    os.symlink("../%s/%s" %(path, foto), foto )

# Faire une copie vers BackupDest

# Supprimer les photos de la source

