package AI::XGBoost::Booster;

use strict;
use warnings;
use utf8;

# VERSION

use Moose;
use AI::XGBoost::CAPI qw(:all);

has _handle => (
    is => 'rw',
    init_arg => undef,
);

sub BUILD {
    my $self = shift;
    my $args = shift;
    $self->_handle(XGBoosterCreate([map {$_->handle } @{$args->{'cache'}}]));
}

sub update {
    my $self = shift;
    my %args = @_;
    my ($iteration, $dtrain) = @args{qw(iteration dtrain)};
    XGBoosterUpdateOneIter($self->_handle, $iteration, $dtrain->handle);
}

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

sub set_param {
    my $self = shift;
    my ($name, $value) = @_;
    XGBoosterSetParam($self->_handle, $name, $value);
    return $self;
}

sub set_attr {
    my $self = shift;
    my ($name, $value) = @_;
    XGBoosterSetAttr($self->_handle, $name, $value);
    return $self;
}

sub get_attr {
    my $self = shift;
    my ($name) = @_;
    XGBoosterGetAttr($self->_handle, $name);
}

sub attributes {
    my $self = shift;
    return {map {$_ => $self->get_attr($_)} @{XGBoosterGetAttrNames($self->_handle)}};
}

sub TO_JSON {
    my $self = shift;
    my $trees = XGBoosterDumpModelEx($self->_handle, "", 1, "json");
    return "[" . join (',', @$trees) . "]";
}

sub DEMOLISH {
    my $self = shift();
    XGBoosterFree($self->_handle);
}

1;
 

