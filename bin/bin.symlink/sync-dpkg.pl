#!/usr/bin/perl

use Data::Dumper;

$sshconnect = " ssh benoit\@192.168.1.101 ";

$cmdlist = " dpkg --get-selections ";

$localname = `hostname`;
$sourcename = `$sshconnect hostname`;
$local = lstsel(qx($cmdlist));
$source = lstsel(qx($sshconnect $cmdlist));


print "Scan ce qui est sur $sourcename et pas sur $localname\n";
foreach my $p ( sort keys %{$source}){
    unless (exists $local->{$p}){
        print "$p n'est pas installé sur $localname. Install? [Y/n]\n";
        my $r = <STDIN>;
        if ($r =~ /y/i) {
            "Installation de $p\n";
            install($p);
        }
    }
}

print "Scan ce qui est sur $localname et pas sur $sourcename\n";
foreach my $p ( sort keys %{$local}){
    unless (exists $source->{$p}){
        print "$p est installé sur $localname, mais n'etait pas sur $sourcename. DEsinstalle? [Y/n]\n";
        my $r = <STDIN>;
        if ($r =~ /y/i) {
            "Installation de $p\n";
            uninstall($p);
        }
    }
}



sub lstsel {
    #my $lst = shift;
    #print "On liste : $lst\n";
    #my @pkg = split(/\n/, $lst);
    my @pkg = @_;
    my %list;
    foreach my $deb (@pkg){
        my @i = split( /\s+/, $deb);
        $list{$i[0]} = 1;
    }
    return \%list;
}

sub install {
    my $pkg = shift;
    my $cmd = "apt-get install $pkg";
    print "Exec: $cmd ...";
    system($cmd);
    print "done $pkg\n";
}
sub uninstall {
    my $pkg = shift;
    my $cmd = "apt-get remove $pkg";
    print "Exec: $cmd ...";
    system($cmd);
    print "done $pkg\n";
}
