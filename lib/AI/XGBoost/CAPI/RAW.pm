package AI::XGBoost::CAPI::RAW;
use strict;
use warnings;

use Alien::XGBoost;
use FFI::Platypus;

my $ffi = FFI::Platypus->new;
$ffi->lib(Alien::XGBoost->dynamic_libs);

# VERSION

# ABSTRACT: Perl wrapper for XGBoost C API https://github.com/dmlc/xgboost

=encoding utf-8

=head1 SYNOPSIS

# EXAMPLE: examples/capi_raw.pl

=head1 DESCRIPTION

Wrapper for the C API.

The doc for the methods is extracted from doxygen comments: https://github.com/dmlc/xgboost/blob/master/include/xgboost/c_api.h

=head1 FUNCTIONS

=cut

=head2 XGBGetLastError

Get string message of the last error

All functions in this file will return 0 when success
and -1 when an error occurred,
XGBGetLastError can be called to retrieve the error
 
This function is thread safe and can be called by different thread

Returns string error information

=cut

$ffi->attach(XGBGetLastError => [] => 'string');

=head2 XGDMatrixCreateFromFile

Load a data matrix

Parameters:

=over 4

=item filename

the name of the file

=item silent 

whether print messages during loading

=item out 

a loaded data matrix

=back

=cut 

$ffi->attach(XGDMatrixCreateFromFile => [qw(string int opaque*)] => 'int');

=head2 XGDMatrixCreateFromCSREx

Create a matrix content from CSR fromat

Parameters:

=over 4

=item indptr

pointer to row headers

=item indices

findex

=item data

fvalue

=item nindptr

number of rows in the matrix + 1

=item nelem

number of nonzero elements in the matrix

=item num_col

number of columns; when it's set to 0, then guess from data

=item out

created dmatrix

=back

=cut

$ffi->attach(XGDMatrixCreateFromCSREx => [qw(size_t[] uint[] float[] size_t size_t size_t opaque*)] => 'int');

=head2 XGDMatrixCreateFromCSCEx

Create a matrix content from CSC format

Parameters:

=over 4

=item col_ptr

pointer to col headers

=item indices

findex

=item data

fvalue

=item nindptr

number of rows in the matrix + 1

=item nelem

number of nonzero elements in the matrix

=item num_row

number of rows; when it's set to 0, then guess from data

=back

=cut

$ffi->attach(XGDMatrixCreateFromCSCEx => [qw(size_t[] uint[] float[] size_t size_t size_t opaque*)] => 'int');

=head2 XGDMatrixCreateFromMat

Create matrix content from dense matrix

Parameters:

=over 4

=item data 

pointer to the data space

=item nrow

number of rows

=item ncol

number columns

=item missing

which value to represent missing value

=item out

created dmatrix

=back

=cut

$ffi->attach(XGDMatrixCreateFromMat => [qw(float[] uint64 uint64 float opaque*)] => 'int');

=head2 XGDMatrixCreateFromMat_omp

Create matrix content from dense matrix

Parameters:

=over 4

=item data 

pointer to the data space

=item nrow

number of rows

=item ncol

number columns

=item missing

which value to represent missing value

=item out

created dmatrix

=item nthread

number of threads (up to maximum cores available, if <=0 use all cores)

=back

=cut

$ffi->attach(XGDMatrixCreateFromMat_omp => [qw(float[] uint64 uint64 float opaque* int)] => 'int');

=head2 XGDMatrixSliceDMatrix

Create a new dmatrix from sliced content of existing matrix

Parameters:

=over 4

=item handle

instance of data matrix to be sliced

=item idxset

index set

=item len

length of index set

=item out

a sliced new matrix

=back

=cut

$ffi->attach(XGDMatrixSliceDMatrix => [qw(opaque int[] uint64 opaque*)] => 'int');

=head2 XGDMatrixNumRow

Get number of rows.

Parameters:

=over 4

=item handle 

the handle to the DMatrix

=item out 

The address to hold number of rows.

=back

=cut

$ffi->attach(XGDMatrixNumRow => [qw(opaque uint64*)] => 'int');

=head2 XGDMatrixNumCol

Get number of cols.

Parameters:

=over 4

=item handle 

the handle to the DMatrix

=item out 

The address to hold number of cols.

=back

=cut

$ffi->attach(XGDMatrixNumCol => [qw(opaque uint64*)] => 'int');

=head2 XGDMatrixSaveBinary

load a data matrix into binary file

Parameters:

=over 4

=item handle

a instance of data matrix

=item fname

file name

=item silent

print statistics when saving

=back

=cut

$ffi->attach(XGDMatrixSaveBinary => [qw(opaque string int)] => 'int');

=head2 XGDMatrixSetFloatInfo

Set float vector to a content in info

Parameters:

=over 4

=item handle

a instance of data matrix

=item field

field name, can be label, weight

=item array

pointer to float vector

=item len

length of array

=back

=cut

$ffi->attach(XGDMatrixSetFloatInfo => [qw(opaque string float[] uint64)] => 'int');

=head2 XGDMatrixSetUIntInfo

Set uint32 vector to a content in info

Parameters:

=over 4

=item handle

a instance of data matrix

=item field

field name, can be label, weight

=item array

pointer to unsigned int vector

=item len

length of array

=back

=cut

$ffi->attach(XGDMatrixSetUIntInfo => [qw(opaque string uint32* uint64)] => 'int');

=head2 XGDMatrixSetGroup

Set label of the training matrix

Parameters:

=over 4

=item handle

a instance of data matrix

=item group

pointer to group size

=item len

length of the array

=back

=cut

$ffi->attach(XGDMatrixSetGroup => [qw(opaque uint32* uint64)] => 'int');

=head2 XGDMatrixGetFloatInfo

Get float info vector from matrix

Parameters:

=over 4

=item handle

a instance of data matrix

=item field

field name

=item out_len

used to set result length

=item out_dptr

pointer to the result

=back

=cut

$ffi->attach(XGDMatrixGetFloatInfo => [qw(opaque string uint64* opaque*)] => 'int');

=head2 XGDMatrixGetUIntInfo

Get uint32 info vector from matrix

Parameters:

=over 4

=item handle

a instance of data matrix

=item field

field name

=item out_len

The length of the field

=item out_dptr

pointer to the result

=back

=cut

$ffi->attach(XGDMatrixGetUIntInfo => [qw(opaque string uint64* opaque*)] => 'int');

=head2 XGDMatrixFree

Free space in data matrix

=cut

$ffi->attach(XGDMatrixFree => [qw(opaque)] => 'int');

=head2 XGBoosterCreate

Create xgboost learner

Parameters:

=over 4

=item dmats 

matrices that are set to be cached

=item len 

length of dmats

=item out 

handle to the result booster

=back

=cut

$ffi->attach(XGBoosterCreate => [qw(opaque[] uint64 opaque*)] => 'int');

=head2 XGBoosterFree

Free obj in handle

Parameters:

=over 4

=item handle 

handle to be freed

=back

=cut

$ffi->attach(XGBoosterFree => [qw(opaque)] => 'int');

=head2 XGBoosterSetParam

Update the model in one round using dtrain

Parameters:

=over 4

=item handle

handle

=item name

parameter name

=item value

value of parameter

=back

=cut

$ffi->attach(XGBoosterSetParam => [qw(opaque string string)] => 'int');

=head2 XGBoosterBoostOneIter

Update the modelo, by directly specify grandient and second order gradient,
this can be used to replace UpdateOneIter, to support customized loss function

Parameters:

=over 4

=item handle

handle

=item dtrain

training data

=item grad

gradient statistics

=item hess

second order gradinet statistics

=item len

length of grad/hess array

=back

=cut

$ffi->attach(XGBoosterBoostOneIter => [qw(opaque opaque float[] float[] uint64)] => 'int');

=head2 XGBoosterUpdateOneIter

Update the model in one round using dtrain

Parameters:

=over 4

=item handle 

handle

=item iter

current iteration rounds

=item dtrain

training data

=back

=cut

$ffi->attach(XGBoosterUpdateOneIter => [qw(opaque int opaque)] => 'int');

=head2 XGBoosterEvalOneIter

=cut

$ffi->attach(XGBoosterEvalOneIter => [qw(opaque int opaque[] opaque[] uint64 opaque*)] => 'int');

=head2 XGBoosterPredict

Make prediction based on dmat

Parameters:

=over 4

=item handle 

handle

=item dmat 

data matrix

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

=item out_len 

used to store length of returning result

=item out_result 

used to set a pointer to array

=back

=cut

$ffi->attach(XGBoosterPredict => [qw(opaque opaque int uint uint64* opaque*)] => 'int');

=head2 XGBoosterLoadModel

Load model form existing file

Parameters:

=over 4

=item handle

handle

=item fname

file name

=back

=cut

$ffi->attach(XGBoosterLoadModel => [qw(opaque string)] => 'int');

=head2 XGBoosterSaveModel

Save model into existing file

Parameters:

=over 4

=item handle

handle

=item fname

file name

=back


=cut

$ffi->attach(XGBoosterSaveModel => [qw(opaque string)] => 'int');

=head2 XGBoosterLoadModelFromBuffer

=cut

$ffi->attach(XGBoosterLoadModelFromBuffer => [qw(opaque opaque uint64)] => 'int');

=head2 XGBoosterGetModelRaw

=cut

$ffi->attach(XGBoosterGetModelRaw => [qw(opaque uint64* opaque*)] => 'int');

=head2 XGBoosterDumpModel

=cut

$ffi->attach(XGBoosterDumpModel => [qw(opaque string int uint64* opaque*)] => 'int');

=head2 XGBoosterDumpModelEx

=cut

$ffi->attach(XGBoosterDumpModelEx => [qw(opaque string int string uint64* opaque*)] => 'int');

=head2 XGBoosterDumpModelWithFeatures

=cut

$ffi->attach(XGBoosterDumpModelWithFeatures => [qw(opaque int opaque[] opaque[] int uint64* opaque*)] => 'int');

=head2 XGBoosterDumpModelExWithFeatures

=cut

$ffi->attach(XGBoosterDumpModelExWithFeatures => [qw(opaque int opaque[] opaque[] int string uint64* opaque*)] => 'int');

=head2 XGBoosterSetAttr

=cut

$ffi->attach(XGBoosterSetAttr => [qw(opaque string string)] => 'int');

=head2 XGBoosterGetAttr

=cut

$ffi->attach(XGBoosterGetAttr => [qw(opaque string opaque* int*)] => 'int');

=head2 XGBoosterGetAttrNames

=cut

$ffi->attach(XGBoosterGetAttrNames => [qw(opaque uint64* opaque*)] => 'int');

=head2 XGBoosterLoadRabitCheckpoint

=cut

$ffi->attach(XGBoosterLoadRabitCheckpoint => [qw(opaque int)] => 'int');

=head2 XGBoosterSaveRabitCheckpoint

=cut

$ffi->attach(XGBoosterSaveRabitCheckpoint => [qw(opaque)] => 'int');

1;
