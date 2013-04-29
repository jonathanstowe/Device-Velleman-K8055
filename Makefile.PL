use 5.014004;
use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'Device::Velleman::K8055::Native',
    VERSION_FROM      => 'lib/Device/Velleman/K8055/Native.pm', 
    PREREQ_PM         => {
                           'Moose' => '2.0402',
                           'Device::USB' => '0.35',
                         },
    ABSTRACT_FROM  => 'lib/Device/Velleman/K8055/Native.pm', 
    AUTHOR         => 'Jonathan Stowe <jns@gellyfish.co.uk>'
);
