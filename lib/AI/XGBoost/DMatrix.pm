package AI::XGBoost::DMatrix;

use strict;
use warnings;
use utf8;

use Moose;
use AI::XGBoost::CAPI qw(:all);

=encoding utf-8

=head1 SYNOPSIS

    use aliased 'AI::XGBoost::DMatrix';
    my $train_data = DMatrix->FromFile(filename => 'agaricus.txt.train');

=head1 DESCRIPTION

XGBoost DMatrix perl model

Work In Progress, the API may change. Comments and suggestions are welcome!

=head1 METHODS

=cut

has handle => (
    is => 'ro',
);

=head2 FromFile

Construct a DMatrix from a file

=head3 Parameters

=over 4

=item filename

File to read

=item silent

Supress messages

=back

=cut

sub FromFile {
    my ($package, %args) = @_;
    my $matrix = XGDMatrixCreateFromFile(@args{qw(filename silent)});
    return __PACKAGE__->new(handle => $matrix);
}

sub DEMOLISH {
    my $self = shift();
    XGDMatrixFree($self->handle);
}

1;
 

