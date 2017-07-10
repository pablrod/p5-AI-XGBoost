package AI::XGBoost::DMatrix;

use strict;
use warnings;
use utf8;

# VERSION

# ABSTRACT: XGBoost class for data

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

=head2 From

Construct a DMatrix from diferent sources. Based on parameters
dispatch to the correct From* method

Refer to From* to see what can be done.

=cut

sub From {
    my ($package, %args) = @_;
    return __PACKAGE__->FromFile(filename => $args{file}, silent => $args{silent}) if (defined $args{file});
    return __PACKAGE__->FromMat(map {$_ => $args{$_} if defined $_} qw(matrix missing label)) if (defined $args{matrix});
    Carp::cluck("I don't know how to build a " . __PACKAGE__ . " with this data: " . join(", ", %args));
}

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

=head2 FromMat

Construct a DMatrix from a bidimensional array

=head3 Parameters

=over 4

=item matrix

Bidimensional array

=item label

Array with the labels of the rows of matrix. Optional

=item missing

Value to identify missing values. Optional, default `NaN`

=back

=cut

sub FromMat {
    my ($package, %args) = @_;
    my $handle = XGDMatrixCreateFromMat(@args{qw(matrix missing)});
    my $matrix = __PACKAGE__->new(handle => $handle);
    if (defined $args{label}) {
        $matrix->set_label($args{label});
    }
    return $matrix;
}

=head2 set_float_info

Set float type property

=head3 Parameters

=over 4

=item field

Field name of the information

=item info

array with the information

=back

=cut

sub set_float_info {
    my $self = shift();
    my ($field, $info) = @_;
    XGDMatrixSetFloatInfo($self->handle, $field, $info);
    return $self;
}

=head2 get_float_info

Get float type property

=head3 Parameters

=over 4

=item field

Field name of the information

=back

=cut

sub get_float_info {
    my $self = shift();
    my $field = shift();
    XGDMatrixGetFloatInfo($self->handle, $field);
}

=head2 set_label

Set label of DMatrix. This label is the "classes" in classification problems

=head3 Parameters

=over 4

=item data

Array with the labels

=back

=cut

sub set_label {
    my $self = shift();
    my $label = shift();
    $self->set_float_info('label', $label);
}

=head2 get_label

Get label of DMatrix. This label is the "classes" in classification problems

=cut

sub get_label {
    my $self = shift();
    $self->get_float_info('label');
}

=head2 set_weight

Set weight of each instance

=head3 Parameters

=over 4

=item weight

Array with the weights

=back 

=cut

sub set_weight {
    my $self = shift();
    my $weight = shift();
    $self->set_float_info('weight', $weight);
    return $self;
}

=head2 get_weight

Get the weight of each instance

=cut

sub get_weight {
    my $self = shift();
    $self->get_float_info('weight');
}

=head2 num_row

Number of rows

=cut

sub num_row {
    my $self = shift();
    XGDMatrixNumRow($self->handle);
}

=head2 num_col

Number of columns

=cut

sub num_col {
    my $self = shift();
    XGDMatrixNumCol($self->handle);
}

=head2 dims

Dimensions of the matrix. That is: rows, columns

=cut

sub dims {
    my $self = shift();
    return ($self->rows(), $self->cols());
}

=head2 DEMOLISH

Free the

=cut

sub DEMOLISH {
    my $self = shift();
    XGDMatrixFree($self->handle);
}

1;
 

