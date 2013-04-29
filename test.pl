#!/usr/bin/perl 

use strict;
use warnings;

use lib qw(lib);

use Device::Velleman::K8055::Native;


my $dev = Device::Velleman::K8055::Native->new(address   => 0);

while(1)
{
for my $i ( 0 .. 255 )
{
    $dev->write_all_digital($i) || die "$!\n";
    print $dev->_bitmask(), "\n";
    sleep 10;
}
}
