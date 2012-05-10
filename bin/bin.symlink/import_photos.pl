#!/usr/bin/perl
#
# Importation de photos facon Benoit
use File::Find;
use Image::ExifTool;
use Date::Parse;
use Cwd qw(realpath);
use strict;

use Data::Dumper;

our $DEBUG = 1;

# Variables
#$FileExt{
our %FileExt = ( 'JPEG' => 'jpg', 'NEF' => 'nef', 'PNG' => 'png');


# Moment de l'import
our $DATE_IMPORT = qx(date +%F_%R);
chomp($DATE_IMPORT);
$DATE_IMPORT =~ s/:/h/; # 
#date_import = datetime.datetime.today().strftime("%F-%R:%S")

# Source des photos : FIXME: recu par l'exterieur?
unless(@ARGV) {
    die "SVP donner le path de source";
}

our $PHOTO_SRC = realpath($ARGV[0]);
#$PHOTO_SRC= '/media/disk'

# Ou vont les photos
#$PathPhotos =  os.getenv('HOME') + os.sep + 'photos'
our $PHOTO = qq($ENV{'HOME'}/photos);
our $PHOTO_NEW = qq($PHOTO/nouveau/$DATE_IMPORT);

# Preparation...
chdir $PHOTO;
qx(mkdir -p $PHOTO_NEW);

my $exifTool = new Image::ExifTool;

###########################
# L'action
##########

# FIXME: que les jpegs pour là...
my @files;
find( sub { push @files, $File::Find::name if -f && /\.jpg$/i }, $PHOTO_SRC);

# on boucle pour prendre les photos trouvés sur SRC et les copiés local dans $PHOTO/tmp

foreach my $f (@files){
    # utiliser exiftool pour classer selon la date dans PathPhotos
    my $info = $exifTool->ImageInfo($f);
    print "Dumper de $f: \n"  if $DEBUG;#. Dumper($info);
    foreach my $k (sort keys %{$info}){
        print "$k = $info->{$k}\n";
    }
    # generer un path avec la date et cie
    #
    my @d = strptime($info->{'DateTimeOriginal'});
    # fix dates
    $d[5] += 1900;
    $d[4] += 1;
    $d[4] = '0'.$d[4] if $d[4] < 10;
    $d[3] = '0'.$d[3] if $d[3] < 10;
    
    # 0  , 1 , 2 , 3  , 4    , 5    , 6
    #($ss,$mm,$hh,$day,$month,$year,$zone) = strptime($date);
    my $path = join("/", 
            $d[5], $d[4], $d[3], );
    my $filename = join('_', "$d[5]$d[4]$d[3]", "$d[2]$d[1]$d[0]", $info->{'FileNumber'}."." . $FileExt{$info->{'FileType'}});
    my $fullpath = qq($PHOTO/$path/$filename);
    print "path = $path\n" if $DEBUG;
    qx(mkdir -p $PHOTO/$path);
    print "fullpath = $fullpath\n" if $DEBUG;
    # copier la photo
    print "Copie ...\n" if $DEBUG;
    if (-e $fullpath){
        warn "$f existe deja comme $fullpath, skip\n";
    }
    print qq( cp  $f $fullpath ) if $DEBUG;
    qx( cp  $f $fullpath );
    print "symlink ...\n" if $DEBUG;
    print qq( ln -s $fullpath $PHOTO_NEW/$filename ) if $DEBUG;;
    qx( ln -s $fullpath $PHOTO_NEW/$filename );

    # Symlinker vers PathPhotos/nouveaux/DATE_IMPORT pour importation par iPhotos et cie.
    die "done" if $DEBUG;
}

# Faire une copie vers BackupDest
warn "\n*******\n\nATTENTION!\nAucun backup n'a été fait. Votre copie est UNIQUE: protégez-la!\n\n";

# Supprimer les photos de la source

