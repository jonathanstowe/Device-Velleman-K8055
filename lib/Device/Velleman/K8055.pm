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

    sub OpenDevice(long $address) is native(LIB) returns int32 { * }

    sub CloseDevice() is native(LIB) returns int32 { * }

    sub ReadAnalogChannel(long $channel) is native(LIB) returns long { * }

    sub ReadAllAnalog(Pointer[long] $data1, Pointer[long] $data2) is native(LIB) returns int32 { * }

    sub OutputAnalogChannel(long $channel, long  $data) is native(LIB) returns int32 { * }

    sub OutputAllAnalog(long $data1, long  $data2) is native(LIB) returns int32 { * }

    sub ClearAllAnalog() is native(LIB) returns int32 { * }

    sub ClearAnalogChannel(long $channel) is native(LIB) returns int32 { * }

    sub SetAnalogChannel(long $channel) is native(LIB) returns int32 { * }

    sub SetAllAnalog() is native(LIB) returns int32 { * }

    sub WriteAllDigital(long $data) is native(LIB) returns int32 { * }

    sub ClearDigitalChannel(long $channel) is native(LIB) returns int32 { * }

    sub ClearAllDigital() is native(LIB) returns int32 { * }

    sub SetDigitalChannel(long $channel) is native(LIB) returns int32 { * }

    sub SetAllDigital() is native(LIB) returns int32 { * }

    sub ReadDigitalChannel(long $channel) is native(LIB) returns int32 { * }

    sub ReadAllDigital() is native(LIB) returns long { * }

    sub ResetCounter(long $counter) is native(LIB) returns int32 { * }

    sub ReadCounter(long $counter) is native(LIB) returns long { * }

    sub SetCounterDebounceTime(long $counter, long $debouncetime) is native(LIB) returns int32 { * }

    sub ReadAllValues(Pointer[long] $data1, Pointer[long] $data2, Pointer[long] $data3, Pointer[long] $data4, Pointer[long] $data5) is native(LIB) returns int32 { * }

    sub SetAllValues(int32 $digitaldata, int32 $addata1, int32  $addata2) is native(LIB) returns int32 { * }

    sub SetCurrentDevice(long $device) is native(LIB) returns long { * }

    sub SearchDevices() is native(LIB) returns long { * }

    sub Version() is native(LIB) returns Str { * }

}

# vim: expandtab shiftwidth=4 ft=perl6
