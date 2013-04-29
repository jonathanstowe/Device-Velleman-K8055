package Device::Velleman::K8055::Native;

use 5.014004;
use strict;
use warnings;

use Moose;
use Moose::Util::TypeConstraints;

use Device::USB;

use Device::Velleman::K8055::Native::OutputData;

use Carp;

use constant {
   STR_BUFF               => 256,
   PACKET_LEN             => 8,
   K8055_IPID             => 0x5500,
   VELLEMAN_VENDOR_ID     => 0x10cf,
   K8055_MAX_DEV          => 4,
   USB_OUT_EP             => 0x01,
   USB_INP_EP             => 0x81,
   USB_TIMEOUT            => 20,
   DIGITAL_INP_OFFSET     => 0,
   DIGITAL_OUT_OFFSET     => 1,
   ANALOG_1_OFFSET        => 2,
   ANALOG_2_OFFSET        => 3,
   COUNTER_1_OFFSET       => 4,
   COUNTER_2_OFFSET       => 6,
   CMD_RESET              => 0x00,
   CMD_SET_DEBOUNCE_1     => 0x01,
   CMD_SET_DEBOUNCE_2     => 0x01,
   CMD_RESET_COUNTER_1    => 0x03,
   CMD_RESET_COUNTER_2    => 0x04,
   CMD_SET_ANALOG_DIGITAL => 0x05,
};

=head1 NAME

Device::Velleman::K8055::Native 

=head1 SYNOPSIS

  use Device::Velleman::K8055::Native;

  my $k8055 =  Device::Velleman::K8055::Native->new(address => 0);

  '#etc

=head1 DESCRIPTION

This provides an interface to the Velleman USB Experiment Board k8055,
providing a similar interface to the library supplied with that device
but made more perlish and using L<Device::USB> to perform the interface
rather than wrapping the library.

=head2 METHODS

=over 4

=item address

This is the device address of the device that we are interested in.
It is required by the constructor and can be 0-3

=cut

subtype  'DeviceAddress',
         as 'Int',
         where {  $_ >= 0 && $_ < K8055_MAX_DEV },
         message  { "address must be between 0 and " . ( K8055_MAX_DEV - 1 ) };

has address => (
                  is => 'rw',
                  isa   => 'DeviceAddress',
                  required => 1,
               );

=item device

This returns the L<Device::USB::Device> object representing the device
we are operating on.

The device is opened and claimed from the operating system, if either of
these operations fails then it will croak with the specific error.

=cut

class_type 'Device::USB::Device';

has device  =>  (
                  is => 'ro',
                  isa   => 'Device::USB::Device',
                  lazy  => 1,
                  builder  => '_get_device',
                );

sub _get_device
{
   my ($self) = @_;

   my $device;
   my $ipid = K8055_IPID + $self->address();
   if ( defined($device = $self->usb()->find_device( VELLEMAN_VENDOR_ID, $ipid ) ) )
   {

      if ( $device->open() )
      {
         if ( !$device->claim_interface(0) )
         {
            $device->reset();
            croak "Can't claim interface : $!\n";
         }
      }
      else
      {
         $device->reset();
         croak "Can't open device : $!\n";
      }
   }
   else
   {
       if ( $! )
       {
         croak $!;
       }
       else
       {
           croak "Specified device doesn't exist";
       }
   }

   return $device;
}

=item usb

This returns the L<Device::USB> object that we are using.

=cut

class_type  'Device::USB';

has usb  => (
               is => 'rw',
               isa   => 'Device::USB',
               default  => sub { Device::USB->new() },
            );

=item output

The L<Device::Velleman::K8055::Native::OutputData> that represents the output.

=cut

has output  => (
                  is => 'ro',
                  isa   => 'Device::Velleman::K8055::Native::OutputData',
                  default  => sub { return Device::Velleman::K8055::Native::OutputData->new() },
               handles  => {
                   '_command' => 'command',
                   '_bitmask' => 'bitmask',
               }
               );

sub write_k8055_data
{
    my ( $self, $cmd ) = @_;

    $self->_command($cmd);

    my $buff = $self->output()->as_bytes();
   my $rc = 0;
    for ( 0 .. 2 )
    {
        if ( $self->device()->interrupt_write(USB_OUT_EP, $buff, PACKET_LEN, USB_TIMEOUT) )
        {
            $rc   =  1;
            last;
        }
    }

   return $rc;
}

=item write_all_digital

Write the specified to the digital outputs

=cut

sub write_all_digital
{
    my ( $self, $bitmask ) = @_;

    $self->_bitmask($bitmask);
    return $self->write_k8055_data(CMD_SET_ANALOG_DIGITAL);
}


=back

=head1 SEE ALSO

There is a also a L<Device::Velleman::K8055::Fuse> that uses an alternative
method of access to the device.

Most of the hard work for this was done by the authors of the Linux version
of the Velleman library, http://libk8055.sourceforge.net/ though I haven't
used any of the code, the discovery of the interface details was crucial :)

=head1 AUTHOR

Jonathan Stowe, E<lt>jns@gellyfish.co.ukE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Jonathan Stowe

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.4 or,
at your option, any later version of Perl 5 you may have available.


=cut

1;

