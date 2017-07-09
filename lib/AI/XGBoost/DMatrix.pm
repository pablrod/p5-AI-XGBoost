package AI::XGBoost::DMatrix;

use strict;
use warnings;
use utf8;

# VERSION

use Moose;
use AI::XGBoost::CAPI qw(:all);
use Carp;

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
    my $handle = XGDMatrixCreateFromFile(@args{qw(filename silent)});
    return __PACKAGE__->new(handle => $handle);
}

sub FromMat {
    my ($package, %args) = @_;
    my $handle = XGDMatrixCreateFromMat(@args{qw(matrix missing)});
    my $matrix = __PACKAGE__->new(handle => $handle);
    $matrix->set_label($args{label});
    return $matrix;
}

sub From {
    my ($package, %args) = @_;
    return __PACKAGE__->FromFile(filename => $args{file}, silent => $args{silent}) if (defined $args{file});
    return __PACKAGE__->FromMat(map {$_ => $args{$_} if defined $_} qw(matrix missing label)) if (defined $args{matrix});
    Carp::cluck("I don't know how to build a " . __PACKAGE__ . " with this data: " . join(", ", %args));
}

sub set_label {
    my $self = shift();
    my $label = shift();
    XGDMatrixSetFloatInfo($self->handle, 'label', $label);
    return $self;
}

sub get_label {
    my $self = shift();
    XGDMatrixGetFloatInfo($self->handle, 'label');
}

sub rows {
    my $self = shift();
    XGDMatrixNumRow($self->handle);
}

sub cols {
    my $self = shift();
    XGDMatrixNumCol($self->handle);
}

sub dims {
    my $self = shift();
    return ($self->rows(), $self->cols());
}

sub DEMOLISH {
    my $self = shift();
    XGDMatrixFree($self->handle);
}

1;
 

