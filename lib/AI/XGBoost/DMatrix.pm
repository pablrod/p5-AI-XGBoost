package AI::XGBoost::DMatrix;

use strict;
use warnings;
use utf8;

# VERSION

# ABSTRACT: XGBoost class for data

use Moose;
use AI::XGBoost::CAPI qw(:all);
use Carp;
use namespace::autoclean;

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

=head2 set_float_info_pdl

Set float type property

=head3 Parameters

=over 4

=item field

Field name of the information

=item info

Piddle with the information

=back

=cut

sub set_float_info_pdl {
    my $self = shift();
    my ($field, $info) = @_;
    XGDMatrixSetFloatInfo($self->handle, $field, $info->flat()->unpdl());
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

=head2 set_uint_info

Set uint type property

=head3 Parameters

=over 4

=item field

Field name of the information

=item info

array with the information

=back

=cut

sub set_uint_info {
    my $self = shift();
    my ($field, $info) = @_;
    XGDMatrixSetUintInfo($self->handle, $field, $info);
    return $self;
}

=head2 get_uint_info

Get uint type property

=head3 Parameters

=over 4

=item field

Field name of the information

=back

=cut

sub get_uint_info {
    my $self = shift();
    my $field = shift();
    XGDMatrixGetUintInfo($self->handle, $field);
}

=head2 save_binary

Save DMatrix object as a binary file.

This file should be used with L<FromFile>

=head3 Parameters

=over 4

=item filename

Filename and path

=item silent

Don't show information messages, optional, default 1

=back

=cut

sub save_binary {
    my $self = shift();
    my ($filename, $silent) = @_;
    $silent //= 1;
    XGDMatrixSaveBinary($self->handle, $filename, $silent);
    return $self;
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

=head2 set_label_pdl

Set label of DMatrix. This label is the "classes" in classification problems

=head3 Parameters

=over 4

=item data

Piddle with the labels

=back

=cut

sub set_label_pdl {
    my $self = shift();
    my $label = shift();
    $self->set_float_info_pdl('label', $label->flat()->unpdl());
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

=head2 set_weight_pdl

Set weight of each instance

=head3 Parameters

=over 4

=item weight

pdl with the weights

=back 

=cut

sub set_weight_pdl {
    my $self = shift();
    my $weight = shift();
    $self->set_float_info('weight', $weight->flat()->unpdl());
    return $self;
}


=head2 get_weight

Get the weight of each instance

=cut

sub get_weight {
    my $self = shift();
    $self->get_float_info('weight');
}

=head2 set_base_margin

Set base margin of booster to start from

=head3 Parameters

=over 4

=item margin

Array with the margins

=back 

=cut

sub set_base_margin {
    my $self = shift();
    my $margin = shift();
    $self->set_float_info('base_margin', $margin);
    return $self;
}

=head2 get_base_margin

Get the base margin

=cut

sub get_base_margin {
    my $self = shift();
    $self->get_float_info('base_margin');
}

=head2 set_group

Set group size

=head3 Parameters

=over 4

=item group

Array with the size of each group

=back

=cut

sub set_group {
    my $self = shift();
    my $group = shift();
    XGDMatrixSetGroup($self->handle, $group);
    return $self;
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
    return ($self->num_row(), $self->num_col());
}

=head2 slice

Slice the DMatrix and return a new DMatrix tha only contains
the list of indices

=head3 Parameters

=over 4

=item list_of_indices

Reference to an array of indices

=back

=cut

sub slice {
    my $self = shift;
    my ($list_of_indices) = @_;
    my $handle = XGDMatrixSliceDMatrix($self->handle(), $list_of_indices);
    return __PACKAGE__->new(handle => $handle);
}

=head2 DEMOLISH

Free the DMatrix

This method gets called automatically

=cut

sub DEMOLISH {
    my $self = shift();
    XGDMatrixFree($self->handle);
}

__PACKAGE__->meta->make_immutable();

1;
 

