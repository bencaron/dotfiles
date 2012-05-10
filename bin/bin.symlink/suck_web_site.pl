#!/usr/bin/perl -w
#===================================================================================
#
#         FILE:  suck_web_site.pl
#
#        USAGE:  ./suck_web_site.pl 
#
#     SYNOPSIS:  suck_web_site.pl http//une.adresse.com/
#
#  DESCRIPTION:  Sauvegarde l'URL et toutes les pages du même domaine
#                
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Benoit Caron (Bc), benoit.caron@netgraphe.com
#      COMPANY:  Netgraphe
#      VERSION:  1.0
#      CREATED:  2004-08-11 08:00:01 EDT
#     REVISION:  ---
#===================================================================================

use strict;

use LWP::Simple;
use HTML::LinkExtor;

my $base = $ARGV[0];
die "Vous devez fournir un URL!\n" unless $base;

# Sauvegarde l'URL de base
getstore($base, "index.html");

