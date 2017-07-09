package AI::XGBoost::CAPI;
use strict;
use warnings;

use Exporter::Easy (
        TAGS => [
            all => [qw(
                XGDMatrixCreateFromFile
                XGDMatrixCreateFromMat
                XGDMatrixNumRow
                XGDMatrixNumCol
                XGDMatrixSetFloatInfo
                XGDMatrixGetFloatInfo
                XGDMatrixFree
                XGBoosterCreate
                XGBoosterSetParam
                XGBoosterSetAttr
                XGBoosterGetAttr
                XGBoosterGetAttrNames
                XGBoosterUpdateOneIter
                XGBoosterBoostOneIter
                XGBoosterPredict
                XGBoosterFree
                XGBoosterDumpModel
                XGBoosterDumpModelEx
                XGBoosterDumpModelWithFeatures
                XGBoosterDumpModelExWithFeatures
                )]
        ]
    );
use AI::XGBoost::CAPI::RAW;
use FFI::Platypus;
use Exception::Class (
    'XGBoostException'
);

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

=head2 XGDMatrixCreateFromMat

Create from dense matrix

Parameters:

=over 4

=item matrix

matrix data

=item missing

value indicating missing data (optional)

=back

Returns a loaded data matrix

=cut 

sub XGDMatrixCreateFromMat {
    my ($data, $missing) = @_;
    $missing //= "NaN";
    # TODO Support simple arrays
    # TODO Support PDL
    # TODO ¿Adapters?
    my $data_adapter = [ map {@$_} @$data ];
    my $ncols = scalar @$data;
    my $nrows = scalar @{$data->[0]};
    my $matrix = 0;
    my $error = AI::XGBoost::CAPI::RAW::XGDMatrixCreateFromMat($data_adapter, $nrows, $ncols, $missing, \$matrix);
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

=head2 XGDMatrixSetFloatInfo 

=cut

sub XGDMatrixSetFloatInfo {
    my ($matrix, $info, $data) = @_;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGDMatrixSetFloatInfo($matrix, $info, $data, scalar @$data) );
}

=head2 XGDMatrixGetFloatInfo 

=cut

sub XGDMatrixGetFloatInfo {
    my ($matrix, $info) = @_;
    my $out_len = 0;
    my $out_result = 0;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGDMatrixGetFloatInfo($matrix, $info, \$out_len, \$out_result) );
    my $ffi = FFI::Platypus->new();
    return $ffi->cast(opaque => "float[$out_len]", $out_result);
}

=head2 XGDMatrixFree

Free space in data matrix

Parameters:

=over 4

=item matrix

DMatrix to be freed

=back

=cut

sub XGDMatrixFree {
    my ($matrix) = @_;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGDMatrixFree($matrix) );
    return (); 
}

=head2 XGBoosterCreate

Create XGBoost learner

Parameters:

=over 4

=item matrices

matrices that are set to be cached

=back

=cut

sub XGBoosterCreate {
    my ($matrices) = @_;
    my $booster = 0;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGBoosterCreate($matrices, scalar @$matrices, \$booster) );
    return $booster;
}

=head2 XGBoosterSetParam

=cut

sub XGBoosterSetParam {
    my ($booster, $name, $value) = @_;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGBoosterSetParam($booster, $name, $value) );
}

=head2 XGBoosterSetAttr

=cut

sub XGBoosterSetAttr {
    my ($booster, $name, $value) = @_;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGBoosterSetAttr($booster, $name, $value) );
}

=head2 XGBoosterGetAttr

=cut

sub XGBoosterGetAttr {
    my ($booster, $name) = @_;
    my $value = 0;
    my $success = -1;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGBoosterGetAttr($booster, $name, \$value, \$success) );
    if ($success) {
        my $ffi = FFI::Platypus->new();
        return $ffi->cast(opaque => "string", $value); 
    }
    return ();
}

=head2 XGBoosterGetAttrNames

=cut

sub XGBoosterGetAttrNames {
    my ($booster) = @_;
    my $out_len = 0;
    my $out_result = 0;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGBoosterGetAttrNames($booster, \$out_len, \$out_result) );
    my $ffi = FFI::Platypus->new();
    $out_result = $ffi->cast(opaque => "opaque[$out_len]", $out_result);
    return [map {$ffi->cast(opaque => "string", $_)} @$out_result ];
}

=head2 XGBoosterUpdateOneIter

Update the model in one round using train matrix

Parameters:

=over 4

=item booster

XGBoost learner to train

=item iter

current iteration rounds

=item train_matrix

training data

=back

=cut

sub XGBoosterUpdateOneIter {
    my ($booster, $iter, $train_matrix) = @_;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGBoosterUpdateOneIter($booster, $iter, $train_matrix) );
    return ();
}

=head2 XGBoosterBoostOneIter

=cut

sub XGBoosterBoostOneIter {
    my ($booster, $train_matrix, $gradient, $hessian) = @_;
    my $out_result = 0;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGBoosterBoostOneIter($booster, $train_matrix, $gradient, $hessian, scalar (@$gradient)));
    return ();
}

=head2 XGBoosterEvalOneIter

=cut

sub XGBoosterEvalOneIter {
    my ($booster, $iter, $matrices, $matrices_names) = @_;
    my $out_result = 0;
    my $number_of_matrices = scalar @$matrices;
    my $ffi = FFI::Platypus->new();
    my $array_of_opaque_matrices_names = [map {$ffi->cast(string => "opaque", $_)} @$matrices_names];
    _CheckCall( AI::XGBoost::CAPI::RAW::XGBoosterEvalOneIter($booster, $iter, $matrices, $array_of_opaque_matrices_names, $number_of_matrices, \$out_result));
    $out_result = $ffi->cast(opaque => "opaque[$number_of_matrices]", $out_result);
    return [map {$ffi->cast(opaque => "string", $_)} @$out_result ];
}

=head2 XGBoosterPredict

Make prediction based on train matrix

Parameters:

=over 4

=item booster

XGBoost learner 

=item data_matrix

Data matrix with the elements to predict

=item option_mask

bit-mask of options taken in prediction, possible values

=over 4

=item 

0: normal prediction

=item

1: output margin instead of transformed value

=item

2: output leaf index of trees instead of leaf value, note leaf index is unique per tree

=item 

4: output feature contributions to individual predictions

=back


=item ntree_limit

limit number of trees used for prediction, this is only valid for boosted trees
when the parameter is set to 0, we will use all the trees

=back

Returns an arrayref with the predictions corresponding to the rows of data matrix

=cut 

sub XGBoosterPredict {
    my ($booster, $data_matrix, $option_mask, $ntree_limit) = @_;
    $option_mask //= 0;
    $ntree_limit //= 0;
    my $out_len = 0;
    my $out_result = 0;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGBoosterPredict($booster, $data_matrix, $option_mask, $ntree_limit, \$out_len, \$out_result) );
    my $ffi = FFI::Platypus->new();
    return $ffi->cast(opaque => "float[$out_len]", $out_result);
}


=head2 XGBoosterDumpModel

=cut

sub XGBoosterDumpModel {
    my ($booster, $feature_map, $with_stats) = @_;
    $feature_map //= "";
    $with_stats //= 1;
    my $out_len = 0;
    my $out_result = 0;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGBoosterDumpModel($booster, $feature_map, $with_stats, \$out_len, \$out_result) );
    my $ffi = FFI::Platypus->new();
    $out_result = $ffi->cast(opaque => "opaque[$out_len]", $out_result);
    return [map {$ffi->cast(opaque => "string", $_)} @$out_result ];
}

=head2 XGBoosterDumpModelEx

=cut

sub XGBoosterDumpModelEx {
    my ($booster, $feature_map, $with_stats, $format) = @_;
    $feature_map //= "";
    $with_stats //= 1;
    my $out_len = 0;
    my $out_result = 0;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGBoosterDumpModelEx($booster, $feature_map, $with_stats, $format, \$out_len, \$out_result) );
    my $ffi = FFI::Platypus->new();
    $out_result = $ffi->cast(opaque => "opaque[$out_len]", $out_result);
    return [map {$ffi->cast(opaque => "string", $_)} @$out_result ];
}

=head2 XGBoosterDumpModelWithFeatures

=cut

sub XGBoosterDumpModelWithFeatures {
    my ($booster, $feature_names, $feature_types, $with_stats) = @_;
    $with_stats //= 1;
    my $out_len = 0;
    my $out_result = 0;
    my $ffi = FFI::Platypus->new();
    my $number_of_features = scalar @$feature_names;
    my $array_of_opaque_feature_names = [map {$ffi->cast(string => "opaque", $_)} @$feature_names];
    my $array_of_opaque_feature_types = [map {$ffi->cast(string => "opaque", $_)} @$feature_types];
    _CheckCall( AI::XGBoost::CAPI::RAW::XGBoosterDumpModelWithFeatures($booster, $number_of_features, $array_of_opaque_feature_names, $array_of_opaque_feature_types, $with_stats, \$out_len, \$out_result) );
    $out_result = $ffi->cast(opaque => "opaque[$out_len]", $out_result);
    return [map {$ffi->cast(opaque => "string", $_)} @$out_result ];
}

=head2 XGBoosterDumpModelExWithFeatures

=cut

sub XGBoosterDumpModelExWithFeatures {
    my ($booster, $feature_names, $feature_types, $with_stats, $format) = @_;
    my $out_len = 0;
    my $out_result = 0;
    my $ffi = FFI::Platypus->new();
    my $number_of_features = scalar @$feature_names;
    my $array_of_opaque_feature_names = [map {$ffi->cast(string => "opaque", $_)} @$feature_names];
    my $array_of_opaque_feature_types = [map {$ffi->cast(string => "opaque", $_)} @$feature_types];
    _CheckCall( AI::XGBoost::CAPI::RAW::XGBoosterDumpModelExWithFeatures($booster, $number_of_features, $array_of_opaque_feature_names, $array_of_opaque_feature_types, $with_stats, $format, \$out_len, \$out_result) );
    $out_result = $ffi->cast(opaque => "opaque[$out_len]", $out_result);
    return [map {$ffi->cast(opaque => "string", $_)} @$out_result ];
}

=head2 XGBoosterFree

Free booster object

Parameters:

=over 4

=item booster

booster to be freed

=back

=cut

sub XGBoosterFree {
    my ($booster) = @_;
    _CheckCall( AI::XGBoost::CAPI::RAW::XGBoosterFree($booster) );
    return ();
}

# _CheckCall
# 
#  Check return code and if necesary, launch an exception
#
sub _CheckCall {
    my ($return_code) = @_;
    if ($return_code) {
        my $error_message = AI::XGBoost::CAPI::RAW::XGBGetLastError();
        XGBoostException->throw(error => $error_message);
    }
}

1;
