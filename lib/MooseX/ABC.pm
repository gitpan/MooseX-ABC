package MooseX::ABC;
BEGIN {
  $MooseX::ABC::VERSION = '0.05';
}
use Moose ();
use Moose::Exporter;
# ABSTRACT: abstract base classes for Moose



sub requires {
    shift->add_required_method(@_);
}

my ($import, $unimport, $init_meta) = Moose::Exporter->build_import_methods(
    with_meta        => [qw(requires)],
    install          => [qw(import unimport)],
    class_metaroles  => {
        class        => ['MooseX::ABC::Trait::Class'],
    },
    base_class_roles => ['MooseX::ABC::Role::Object'],
);

sub init_meta {
    my ($package, %options) = @_;
    Carp::confess("Can't make a role into an abstract base class")
        if Class::MOP::class_of($options{for_class})->isa('Moose::Meta::Role');
    my $ret = $init_meta->(@_);
    Class::MOP::class_of($options{for_class})->is_abstract(1);
    return $ret;
}


1;

__END__
=pod

=head1 NAME

MooseX::ABC - abstract base classes for Moose

=head1 VERSION

version 0.05

=head1 SYNOPSIS

  package Shape;
  use Moose;
  use MooseX::ABC;

  requires 'draw';

  package Circle;
  use Moose;
  extends 'Shape';

  sub draw {
      # stuff
  }

  my $shape = Shape->new; # dies
  my $circle = Circle->new; # succeeds

  package Square;
  use Moose;
  extends 'Shape'; # dies, since draw is unimplemented

=head1 DESCRIPTION

This module adds basic abstract base class functionality to Moose. Doing C<use
MooseX::ABC> turns the using class into an abstract class - it cannot be
instantiated. It also allows you to mark certain methods in the class as
L</required>, meaning that if a class inherits from this class without
implementing that method, it will die at compile time. Abstract subclasses are
exempt from this, however - if you extend a class with another class which uses
C<MooseX::ABC>, it will not be required to implement every required method (and
it can also add more required methods of its own). Only concrete classes
(classes which do not use C<MooseX::ABC>) are required to implement all of
their ancestors' required methods.

=head1 FUNCTIONS

=head2 requires METHOD_NAMES

Takes a list of methods that classes inheriting from this one must implement.
If a class inherits from this class without implementing each method listed
here, an error will be thrown when compiling the class.

=for Pod::Coverage   init_meta

=head1 BUGS

No known bugs.

Please report any bugs through RT: email
C<bug-moosex-abc at rt.cpan.org>, or browse to
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-ABC>.

=head1 SEE ALSO

=over 4

=item *

L<Moose>

=item *

L<Moose::Role>

=back

=head1 SUPPORT

You can find this documentation for this module with the perldoc command.

    perldoc MooseX::ABC

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooseX-ABC>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooseX-ABC>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooseX-ABC>

=item * Search CPAN

L<http://search.cpan.org/dist/MooseX-ABC>

=back

=head1 AUTHOR

Jesse Luehrs <doy at tozt dot net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Jesse Luehrs.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

