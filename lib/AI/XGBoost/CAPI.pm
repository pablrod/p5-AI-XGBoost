package AI::XGBoost::CAPI;
use strict;
use warnings;

use Exporter::Easy (
        TAGS => [
            all => [qw(
                XGDMatrixCreateFromFile
                XGDMatrixNumRow
                XGDMatrixNumCol
                XGDMatrixFree
                XGBoosterCreate
                XGBoosterUpdateOneIter
                XGBoosterPredict
                XGBoosterFree
                )]
        ]
    );
use AI::XGBoost::CAPI::RAW;
use FFI::Platypus;

# VERSION

# ABSTRACT: Perl wrapper for XGBoost C API https://github.com/dmlc/xgboost

=encoding utf-8

=head1 SYNOPSIS

# EXAMPLE: examples/capi.pl

=head1 DESCRIPTION

Perlified wrapper for the C API

=head2 Error handling

XGBoost c api functions returns some int to signal the presence/absence of error.
In this module that is achieved using Exceptions from L<Exception::Class>

=head1 FUNCTIONS

=cut

=head2 XGDMatrixCreateFromFile

Load a data matrix

Parameters:

=over 4

=item filename

the name of the file

=item silent 

whether print messages during loading

=back

Returns a loaded data matrix

=cut 

sub XGDMatrixCreateFromFile {
    my ($filename, $silent) = @_;
    $silent //= 1;
    my $matrix = 0;
    my $error = AI::XGBoost::CAPI::RAW::XGDMatrixCreateFromFile($filename, $silent, \$matrix);
    _CheckCall($error);
    return $matrix;
}

=head2 XGDMatrixNumRow

Get number of rows

Parameters:

=over 4

=item matrix

DMatrix

=back

=cut

sub XGDMatrixNumRow {
    my ($matrix) = @_;
    my $rows = 0;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGDMatrixNumRow($matrix, \$rows) );
    return $rows;
}

=head2 XGDMatrixNumCol

Get number of cols

Parameters:

=over 4

=item matrix

DMatrix

=back

=cut

sub XGDMatrixNumCol {
    my ($matrix) = @_;
    my $cols = 0;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGDMatrixNumCol($matrix, \$cols) );
    return $cols;
}

=head2 XGDMatrixFree

=cut

sub XGDMatrixFree {
    my ($matrix) = @_;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGDMatrixFree($matrix) );
    return (); 
}

=head2 XGBoosterCreate

=cut

sub XGBoosterCreate {
    my ($matrices) = @_;
    my $booster = 0;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGBoosterCreate($matrices, scalar @$matrices, \$booster) );
    return $booster;
}

=head2 XGBoosterUpdateOneIter

=cut

sub XGBoosterUpdateOneIter {
    my ($booster, $iter, $train_matrix) = @_;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGBoosterUpdateOneIter($booster, $iter, $train_matrix) );
    return ();
}

=head2 XGBoosterPredict

=cut 

sub XGBoosterPredict {
    my ($booster, $data_matrix, $option_mask, $ntree_limit) = @_;
    my $out_len = 0;
    my $out_result = 0;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGBoosterPredict($booster, $data_matrix, $option_mask, $ntree_limit, \$out_len, \$out_result) );
    my $ffi = FFI::Platypus->new();
    return $ffi->cast(opaque => "float[$out_len]", $out_result);
}

=head2 XGBoosterFree

=cut

sub XGBoosterFree {
    my ($booster) = @_;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGBoosterFree($booster) );
    return ();
}

sub _CheckCall {
    my ($return_code) = @_;
    if ($return_code) {
        my $error_message = AI::XGBoost::CAPI::RAW::XGBGetLastError();
        die $error_message;
    }
}

1;
