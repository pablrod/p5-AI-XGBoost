package AI::XGBoost::Booster;

use strict;
use warnings;
use utf8;

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
    XGBoosterPredict($self->_handle, $data->handle);
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
 

