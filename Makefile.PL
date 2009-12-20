
use strict;
use warnings;



use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'MooseX-ABC',
  NAME      => 'MooseX::ABC',
  AUTHOR    => "Jesse\ Luehrs\ \<doy\ at\ tozt\ dot\ net\>",
  ABSTRACT  => "abstract\ base\ classes\ for\ Moose",
  VERSION   => '0.03',
  EXE_FILES => [ qw() ],
  (eval { ExtUtils::MakeMaker->VERSION(6.31) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "Test::Exception" => '0',
    "Moose" => '0.90',
  },
  test => {TESTS => 't/*.t'}
);

