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
    
    my class Device is repr('CPointer') {

    
        sub k8055_close_device(Device $device) is native(LIB)  { * }

        method close() {
            k8055_close_device(self);
        }
     
        sub k8055_set_all_digital(Device $device, int32 $bitmask) is native(LIB) returns int32 { * }

        method set-all-digital(Int $bitmask where * < 256) returns Bool {
            my $rc = k8055_set_all_digital(self, $bitmask);
            $rc == SUCCESS;
        }
    
        sub k8055_set_digital(Device $device, int32 $channel, bool  $value) is native(LIB) returns int32 { * }

        method set-digital(Int $channel where * < 8, Bool $v) returns Bool {
            my $rc = k8055_set_digital(self, $channel, $v.value);
            $rc == SUCCESS;
        }
    
        sub k8055_set_all_analog(Device $device, int32 $analog0, int32 $analog1) is native(LIB) returns int32 { * }

        subset AnalogValue of Int where * < 256;

        method set-all-analog(AnalogValue $analog0, AnalogValue $analog1) returns Bool {
            my $rc = k8055_set_all_analog(self, $analog0, $analog1);
            $rc == SUCCESS;
        }
    
        sub k8055_set_analog(Device $device, int32 $channel, int32 $value) is native(LIB) returns int32 { * }

        method set-analog(Int $channel where 2 > * > 0, AnalogValue $value) returns Bool {
            my $rc = k8055_set_analog(self, $channel, $value);
            $rc == SUCCESS;
        }
    
        sub k8055_reset_counter(Device $device, int32 $counter) is native(LIB) returns int32 { * }

        method reset-counter(Int $counter where 2 > * > 0) returns Bool {
            my $rc = k8055_reset_counter(self, $counter);
            $rc == SUCCESS;
        }
    
        sub k8055_set_debounce_time(Device $device, int32 $counter, int32 $debounce) is native(LIB) returns int32 { * }

        method set-debounce-time(Int $counter where 2 > * > 0, Int $debounce where * < 7450) returns Bool {
            my $rc = k8055_set_debounce_time(self, $counter, $debounce);
            $rc == SUCCESS;
        }
    
        sub k8055_get_all_input(Device $device,     int32 $digitalBitmask is rw, 
                                                    int32 $analog0 is rw, 
                                                    int32 $analog1 is rw, 
                                                    int32 $counter0  is rw, 
                                                    int32 $counter1 is rw, bool $quick) is native(LIB) returns int32 { * }

        method get-all-input(Bool :$quick = False) {
            my int32 $digitalBitmask;
            my int32 $analog0;
            my int32 $analog1;
            my int32 $counter0;
            my int32 $counter1;
            my $rc = k8055_get_all_input(self, $digitalBitmask, $analog0, $analog1, $counter0, $counter1, $quick.value);

            if $rc != SUCCESS {
                die "Failed to get inputs ({ Error($rc) })";
            }
            $digitalBitmask, $analog0, $analog1, $counter0, $counter1;
        }
    
        sub k8055_get_all_output(Device $device,    int32 $digitalBitmask is rw,
                                                    int32 $analog0 is rw,
                                                    int32 $analog1 is rw,
                                                    int32 $debounce0 is rw,
                                                    int32 $debounce1 is rw) is native(LIB)  { * }
        method get-all-output() {
            my int32 $digitalBitmask;
            my int32 $analog0;
            my int32 $analog1;
            my int32 $debounce0;
            my int32 $debounce1;
            my $rc = k8055_get_all_output(self, $digitalBitmask, $analog0, $analog1, $debounce0, $debounce1);

            if $rc != SUCCESS {
                die "Failed to get inputs ({ Error($rc) })";
            }
            $digitalBitmask, $analog0, $analog1, $debounce0, $debounce1;
        }

        method reset() {
            self.set-all-digital(0) && self.set-all-analog(0,0);
        }
    }
    
    sub k8055_open_device(int32 $port, Pointer $device is rw) is native(LIB) returns int32 { * }

    method !open-device(Int :$port where { 0 <= $_ < 4 } = 0) returns Device {
        my $p = Pointer[Device].new;
        my $rc = k8055_open_device($port, $p);
            
        if $rc != SUCCESS {
                die "Cannot open device";
        }
        $p.deref;
    }

    method close(Bool :$reset = False) {
        if $reset {
            self.reset;
        }
        $!device.close;
    }
    
    sub k8055_debug(bool $value) is native(LIB)  { * }

    has Device $!device handles <set-all-digital set-digital set-all-analog set-analog reset-counter set-debounce-time get-all-input get-all-output reset>;

    submethod BUILD(Int :$!address where 0 <= * < 4 = 0, Bool :$debug) {
        $!device = self!open-device(:$!address);
        if $debug {
            k8055_debug(1);
        }
    }
    
}

# vim: expandtab shiftwidth=4 ft=perl6
