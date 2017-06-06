package AI::XGBoost;
use strict;
use warnings;

# VERSION

# ABSTRACT: Perl wrapper for XGBoost library L<https://github.com/dmlc/xgboost>

=encoding utf-8

=head1 SYNOPSIS

# EXAMPLE: examples/capi.pl

=head1 DESCRIPTION

Perl wrapper for XGBoost library. This version only wraps part of the C API.

The documentation can be found in L<AI::XGBoost::CAPI>

Currently this module need the xgboost binary available in your system. 
I'm going to make an Alien module for xgboost but meanwhile you need to
compile yourself xgboost: L<https://github.com/dmlc/xgboost>

=head1 ROADMAP

The goal is to make a full wrapper for XGBoost.

=head2 VERSIONS

=over 4

=item 0.1 

Full raw C API available as AI::XGBoost::CAPI::Raw

=item 0.2 

Full C API "easy" to use, with PDL support as AI::XGBoost::CAPI

Easy means clients don't have to use FFI::Platypus or modules dealing
with C structures

=item 0.3

Object oriented API Moose based with DMatrix and Booster classes

=item 0.4

Complete object oriented API

=back

=cut

1;
