#!/usr/bin/perl

# Serveur proxy, pour débugage
#
#
use strict;
use HTTP::Proxy qw(:log);
use FileHandle;

my $fh ;

if ($ARGV[0] =~ /^-+h(elp)*/){
  usage();
} elsif ($ARGV[0]) {
  $fh = new FileHandle;
  unless ($fh->open(">>". $ARGV[0])) {
	die "Impossible d'ouvrir $ARGV[0] : $!\n";
  }
} else {
  $fh = *STDERR;
}
# initialisation
my $proxy = HTTP::Proxy->new( port => 9100, logfh => $fh );

# Log tout
#$proxy->verbose(5);
$proxy->logmask(ALL);

# Fork au max 1 child 
$proxy->maxchild(3);

# Nb maximum de requete que l'on va servir : 100 par défaut, pour 
# minimiser les fois où on va oublier ce daemon
$proxy->maxconn(0);

# this is a MainLoop-like method
$proxy->start;
