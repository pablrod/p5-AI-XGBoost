package AI::XGBoost;
use strict;
use warnings;

use AI::XGBoost::Booster;
use Exporter::Easy ( OK => ['train'] );

# VERSION

# ABSTRACT: Perl wrapper for XGBoost library L<https://github.com/dmlc/xgboost>

=encoding utf-8

=head1 SYNOPSIS

# EXAMPLE: examples/basic.pl

# EXAMPLE: examples/iris.pl

=head1 DESCRIPTION

Perl wrapper for XGBoost library. 

The easiest way to use the wrapper is using C<train>, but beforehand 
you need the data to be used contained in a C<DMatrix> object

This is a work in progress, feedback, comments, issues, suggestion and
pull requests are welcome!!

Currently this module need the xgboost binary available in your system. 
I'm going to make an Alien module for xgboost but meanwhile you need to
compile yourself xgboost: L<https://github.com/dmlc/xgboost>

=head1 FUNCTIONS

=cut

=head2 train

Performs gradient boosting using the data and parameters passed

Returns a trained AI::XGBoost::Booster used

=head3 Parameters

=over 4

=item params

Parameters for the booster object. 

Full list available: https://github.com/dmlc/xgboost/blob/master/doc/parameter.md 

=item data

AI::XGBoost::DMatrix object used for training

=item number_of_rounds

Number of boosting iterations

=back

=cut

sub train {
    my %args = @_;
    my ( $params, $data, $number_of_rounds ) = @args{qw(params data number_of_rounds)};

    my $booster = AI::XGBoost::Booster->new( cache => [$data] );
    if ( defined $params ) {
        while ( my ( $name, $value ) = each %$params ) {
            $booster->set_param( $name, $value );
        }
    }
    for my $iteration ( 0 .. $number_of_rounds - 1 ) {
        $booster->update( dtrain => $data, iteration => $iteration );
    }
    return $booster;
}

=head1 ROADMAP

The goal is to make a full wrapper for XGBoost.

=head2 VERSIONS

=over 4

=item 0.2 

Full C API "easy" to use, with PDL support as L<AI::XGBoost::CAPI>

Easy means clients don't have to use L<FFI::Platypus> or modules dealing
with C structures

=item 0.25

Alien package for libxgboost.so/xgboost.dll

=item 0.3

Object oriented API Moose based with DMatrix and Booster classes

=item 0.4

Complete object oriented API

=item 0.5

Use perl signatures (L<https://metacpan.org/pod/distribution/perl/pod/perlexperiment.pod#Subroutine-signatures>)

=back

=head1 SEE ALSO

=over 4

=item L<AI::MXNet>

=item L<FFI::Platypus>

=item L<NativeCall>

=back

=cut

1;
