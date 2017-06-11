package AI::XGBoost::DMatrix;

use strict;
use warnings;
use utf8;

use Moose;
use AI::XGBoost::CAPI qw(:all);

has handler => (
    is => 'ro'
);

sub FromFile {
    my ($package, %args) = @_;
    my $matrix = XGDMatrixCreateFromFile(@args{qw(filename silent)});
    return __PACKAGE__->new(handler => $matrix);
}

1;
 

