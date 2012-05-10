#!/usr/bin/python
# -*- coding: utf-8 -*-
# - * - coding: iso-8859-1 -*-

import sys
sys.path.append("/home/benoit/lib/python")

import string, random, word_wrap, re

# Le bout de signature toujours commun
if sys.argv[1] == 'notezbien':
  top = "Benoit Caron\n"
  top += "benoit@notezbien.net\n"
  top += "Mes déblatérations:\nhttp://www.notezbien.net/blabla/\n"
  top += "Mes photos: \nhttp://photos.notezbien.net/\nhttp://photos.notezbien.net/blog/\n"
  top += "http://www.flick.com/photos/benlegeek/\n"
else :
  top = "Benoit Caron\n"
  top += "Administrateur principal de système Unix\n"
  top += "Senior Unix systems administrator\n"
  top += "Canoe inc.\n"
  top += "benoit.caron@canoe.com - 514-504-2768\n"



# On lit le fichier de signature
sigs = open("/home/benoit/signatures.txt").read()
sigs = string.split( sigs, "\n\n" )
sigs = filter( None, map( string.strip, sigs ))
bar = random.choice(sigs)

# Nettoie "bar"
lbar = word_wrap.wrap_str(bar,80)


# réécrit ce qu'on a trouvé
if re.search("stdout.py$", sys.argv[0]):
	sys.stdout.write(top)
	sys.stdout.write("------\n")
	for s in lbar:
		sys.stdout.write(s)
		if s and s[-1] != '\n':
			sys.stdout.write("\n")
else :
	if  sys.argv[1] == 'notezbien':
	    sig = open('/home/benoit/.signature.notezbien','w')
	else:
	    sig = open('/home/benoit/.signature','w')

	sig.write(top)
	sig.write("----\n")
	for s in lbar:
		sig.write(s)
		if s and s[-1] != '\n':
			sig.write("\n")
	sig.close()

