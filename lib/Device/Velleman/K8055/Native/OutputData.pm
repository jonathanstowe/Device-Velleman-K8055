package Device::Velleman::K8055::Native::OutputData;

use strict;
use warnings;
 
use Moose;
use Moose::Util::TypeConstraints;

enum  'K8055Command'   => [0, 1, 2, 3, 4, 5];

has command => (
                  is => 'rw',
                  isa   => 'K8055Command',
                  predicate   => 'has_command',
               );

subtype  'K8055Byte', 
         as 'Int',
         where { $_ >= 0 && $_ <= 255 };

has bitmask => (
                  is => 'rw',
                  isa   => 'K8055Byte',
                  default  => 0,
               );
has analogue_1 => (
                  is => 'rw',
                  isa   => 'K8055Byte',
                  default  => 0,
               );
has analogue_2 => (
                  is => 'rw',
                  isa   => 'K8055Byte',
                  default  => 0,
               );
has reset_counter_1 => (
                  is => 'rw',
                  isa   => 'K8055Byte',
                  default  => 0,
               );
has reset_counter_2 => (
                  is => 'rw',
                  isa   => 'K8055Byte',
                  default  => 0,
               );
has debounce_1 => (
                  is => 'rw',
                  isa   => 'K8055Byte',
                  default  => 0,
               );
has debounce_2 => (
                  is => 'rw',
                  isa   => 'K8055Byte',
                  default  => 0,
               );

sub as_bytes
{
    my ( $self ) = @_;
   return join '', map { chr($_) } $self->_bytes();
}

sub _bytes
{
    my ( $self ) = @_;

    return ( $self->command(),
             $self->bitmask(),
             $self->analogue_1(),
             $self->analogue_2(),
             $self->reset_counter_1(),
             $self->reset_counter_2(),
             $self->debounce_1(),
             $self->debounce_2(), );
}

1;
