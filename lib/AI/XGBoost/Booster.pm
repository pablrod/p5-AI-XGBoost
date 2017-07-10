package AI::XGBoost::Booster;

use strict;
use warnings;
use utf8;

# VERSION

# ABSTRACT: XGBoost main class for training, prediction and evaluation

use Moose;
use AI::XGBoost::CAPI qw(:all);

=encoding utf-8

=head1 SYNOPSIS

# EXAMPLE: examples/basic.pl

=head1 DESCRIPTION

Booster objects control training, prediction and evaluation

Work In Progress, the API may change. Comments and suggestions are welcome!

=head1 METHODS

=cut

has _handle => (
    is => 'rw',
    init_arg => undef,
);

=head2 update

Update one iteration

=head3 Parameters

=over 4

=item iteration

Current iteration number

=item dtrain

Training data (AI::XGBoost::DMatrix)

=back

=cut

sub update {
    my $self = shift;
    my %args = @_;
    my ($iteration, $dtrain) = @args{qw(iteration dtrain)};
    XGBoosterUpdateOneIter($self->_handle, $iteration, $dtrain->handle);
    return $self;
}

=head2 boost

Boost one iteration using your own gradient

=head3 Parameters

=over 4

=item dtrain

Training data (AI::XGBoost::DMatrix)

=item grad

Gradient of your objective function (Reference to an array)

=item hess

Hessian of your objective function, that is, second order gradient (Reference to an array)

=back

=cut

sub boost {
    my $self = shift;
    my %args = @_;
    my ($dtrain, $grad, $hess) = @args{qw(dtrain grad hess)};
    XGBoosterBoostOneIter($self->_handle, $dtrain, $grad, $hess);
    return $self;
}

=head2 predict

Predict data using the trained model

=head3 Parameters

=over 4

=item data

Data to predict

=back

=cut

sub predict {
    my $self = shift;
    my %args = @_;
    my $data = $args{'data'};
    my $result = XGBoosterPredict($self->_handle, $data->handle);
    my $result_size = scalar @$result;
    my $matrix_rows = $data->rows;
    if ($result_size != $matrix_rows && $result_size % $matrix_rows == 0) {
        my $col_size = $result_size / $matrix_rows;
        return [map {[@$result[$_ * $col_size .. $_ * $col_size + $col_size - 1]]} 0 .. $matrix_rows - 1];
    }
    return $result;
}

=head2 set_param

Set booster parameter

=head3 Example

    $booster->set_param('objective', 'binary:logistic');

=cut

sub set_param {
    my $self = shift;
    my ($name, $value) = @_;
    XGBoosterSetParam($self->_handle, $name, $value);
    return $self;
}

=head2 set_attr

Set a string attribute

=cut

sub set_attr {
    my $self = shift;
    my ($name, $value) = @_;
    XGBoosterSetAttr($self->_handle, $name, $value);
    return $self;
}

=head2 get_attr

Get a string attribute

=cut

sub get_attr {
    my $self = shift;
    my ($name) = @_;
    XGBoosterGetAttr($self->_handle, $name);
}

=head2 attributes

Returns all attributes of the booster as a HASHREF

=cut

sub attributes {
    my $self = shift;
    return {map {$_ => $self->get_attr($_)} @{XGBoosterGetAttrNames($self->_handle)}};
}

=head2 TO_JSON

Serialize the booster to JSON.

This method is to be used with the option C<convert_blessed> from L<JSON>.
(See L<https://metacpan.org/pod/JSON#OBJECT-SERIALISATION>)

Warning: this API is subject to changes

=cut

sub TO_JSON {
    my $self = shift;
    my $trees = XGBoosterDumpModelEx($self->_handle, "", 1, "json");
    return "[" . join (',', @$trees) . "]";
}

=head2 BUILD

Use new, this method is just an internal helper

=cut

sub BUILD {
    my $self = shift;
    my $args = shift;
    $self->_handle(XGBoosterCreate([map {$_->handle } @{$args->{'cache'}}]));
}

=head2 DEMOLISH

Internal destructor. This method is called automatically

=cut

sub DEMOLISH {
    my $self = shift();
    XGBoosterFree($self->_handle);
}

1;
 

