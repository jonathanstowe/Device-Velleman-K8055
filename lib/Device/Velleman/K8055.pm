use v6.c;

=begin pod

=head1 NAME

Device::Velleman::K8055::Native 

=head1 SYNOPSIS

=begin code

  use Device::Velleman::K8055;

  my $k8055 =  Device::Velleman::K8055.new(address => 0);

  #etc
  
=end code

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

=end pod

use NativeCall;

class Device::Velleman::K8055 {

    constant LIB = %?RESOURCES<libraries/k8055>.Str;

    has Int $.address;
    
    enum Error (
                   SUCCESS => 0,
                   ERROR => -1,
                   INIT_LIBUSB => -2,
                   NO_DEVICES => -3,
                   NO_K8055 => -4,
                   ACCESS => -6,
                   OPEN => -7,
                   CLOSED => -8,
                   WRITE => -9,
                   READ => -10,
                   INDEX => -11,
                   MEM => -12
                );
    
    class Device is repr('CStruct') {
    }
    
    
    sub k8055_debug(bool $value) is native(LIB)  { * }
    
    sub k8055_open_device(int32 $port, Pointer[Device] $device) is native(LIB) returns int32 { * }
    
    sub k8055_close_device(Device $device) is native(LIB)  { * }
    
    sub k8055_set_all_digital(Device $device, int32 $bitmask) is native(LIB) returns int32 { * }
    
    sub k8055_set_digital(Device $device, int32 $channel, bool  $value) is native(LIB) returns int32 { * }
    
    sub k8055_set_all_analog(Device $device, int32 $analog0, int32 $analog1) is native(LIB) returns int32 { * }
    
    sub k8055_set_analog(Device $device, int32 $channel, int32 $value) is native(LIB) returns int32 { * }
    
    sub k8055_reset_counter(Device $device, int32 $counter) is native(LIB) returns int32 { * }
    
    sub k8055_set_debounce_time(Device $device, int32 $counter, int32 $debounce) is native(LIB) returns int32 { * }
    
    sub k8055_get_all_input(Device $device,     Pointer[int32] $digitalBitmask, 
                                                Pointer[int32] $analog0, 
                                                Pointer[int32] $analog1, 
                                                Pointer[int32] $counter0, 
                                                Pointer[int32] $counter1, bool $quick) is native(LIB) returns int32 { * }
    
    sub k8055_get_all_output(Device $device,    Pointer[int32] $digitalBitmask,
                                                Pointer[int32] $analog0,
                                                Pointer[int32] $analog1,
                                                Pointer[int32] $debounce0,
                                                Pointer[int32] $debounce1) is native(LIB)  { * }
    

}

# vim: expandtab shiftwidth=4 ft=perl6
