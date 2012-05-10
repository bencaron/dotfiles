#!/usr/bin/perl
sub
sub { rand 39 / 999 }
sub O123 { printf "" . "\e[" . "%d" . ";%d" . "" . "H%s",@_ }
sub l234 { O123 $|=1,1, "\e[J" }
while (1) {
    $c or
	do {
	    l234;
	    $u=&sub;
	    $v=&sub;
	    $c=3999;
	    $b=qw/39 9 1/[int rand 3];
	};
    O123 11*sin($v*$c)+13, 39*cos($u*$c)+41, qw+J A P H+[$c%4];
    ($a++%$b) or $c--;
}
