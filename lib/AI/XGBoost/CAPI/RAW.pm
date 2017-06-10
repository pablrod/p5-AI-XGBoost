package AI::XGBoost::CAPI::RAW;
use strict;
use warnings;

use parent 'NativeCall';

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

sub XGBGetLastError :Args() :Native(xgboost) :Returns(string) {}

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

sub XGDMatrixCreateFromFile :Args(string, int, opaque*) :Native(xgboost) :Returns(int) {}

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

sub XGDMatrixCreateFromCSREx :Args(size_t*, uint*, float*, size_t, size_t, size_t, opaque*) :Native(xgboost) :Returns(int) {}

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

sub XGDMatrixCreateFromCSCEx :Args(size_t*, uint*, float*, size_t, size_t, size_t, opaque*) :Native(xgboost) :Returns(int) {}

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

sub XGDMatrixCreateFromMat :Args(float *, uint64, uint64, float, opaque*) :Native(xgboost) :Returns(int) {}

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

sub XGDMatrixSliceDMatrix :Args(opaque, int *, uint64, opaque*) :Native(xgboost) :Returns(int) {}

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

sub XGDMatrixNumRow :Args(opaque, uint64*) :Native(xgboost) :Returns(int) {}

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

sub XGDMatrixNumCol :Args(opaque, uint64*) :Native(xgboost) :Returns(int) {}

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

sub XGDMatrixSaveBinary :Args(opaque, string, int) :Native(xgboost) :Returns(int) {}

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

sub XGDMatrixSetFloatInfo :Args(opaque, string, float *, uint64) :Native(xgboost) :Returns(int) {}

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

sub XGDMatrixSetUIntInfo :Args(opaque, string, uint32 *, uint64) :Native(xgboost) :Returns(int) {}

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

sub XGDMatrixSetGroup :Args(opaque, uint32 *, uint64) :Native(xgboost) :Returns(int) {}

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

sub XGDMatrixGetFloatInfo :Args(opaque, string, uint64 *, opaque *) :Native(xgboost) :Returns(int) {}

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

sub XGDMatrixGetUIntInfo :Args(opaque, string, uint64 *, opaque *) :Native(xgboost) :Returns(int) {}

=head2 XGDMatrixFree

Free space in data matrix

=cut

sub XGDMatrixFree :Args(opaque) :Native(xgboost) :Returns(int) {} 

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

sub XGBoosterCreate :Args(opaque[], uint64, opaque*) :Native(xgboost) :Returns(int) {}

=head2 XGBoosterFree

Free obj in handle

Parameters:

=over 4

=item handle 

handle to be freed

=back

=cut

sub XGBoosterFree :Args(opaque) :Native(xgboost) :Returns(int) {}

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

sub XGBoosterSetParam :Args(opaque, string, string) :Native(xgboost) :Returns(int) {}

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

sub XGBoosterBoostOneIter :Args(opaque, opaque, float*, float*, uint64) :Native(xgboost) :Returns(int) {}

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

sub XGBoosterUpdateOneIter :Args(opaque, int, opaque) :Native(xgboost) :Returns(int) {}

sub XGBoosterEvalOneIter :Args(opaque, int, opaque[], opaque*, uint64, opaque*) :Native(xgboost) :Returns(int) {}

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

sub XGBoosterPredict :Args(opaque, opaque, int, uint, uint64*, opaque*) :Native(xgboost) :Returns(int) {}

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

sub XGBoosterLoadModel :Args(opaque, string) :Native(xgboost) :Returns(int) {}

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

sub XGBoosterSaveModel :Args(opaque, string) :Native(xgboost) :Returns(int) {}


sub XGBoosterLoadModelFromBuffer :Args(opaque, opaque, uint64) :Native(xgboost) :Returns(int) {} 

sub XGBoosterGetModelRaw :Args(opaque, uint64*, opaque*) :Native(xgboost) :Returns(int) {}

sub XGBoosterDumpModel :Args(opaque, string, int, uint64*, opaque*) :Native(xgboost) :Returns(int) {}

sub XGBoosterDumpModelEx :Args(opaque, string, int, string, uint64*, opaque*) :Native(xgboost) :Returns(int) {}

sub XGBoosterDumpModelWithFeatures :Args(opaque, int, opaque[], opaque[], int, uint64*, opaque*) Native(xgboost) :Returns(int) {}

sub XGBoosterDumpModelExWithFeatures :Args(opaque, int, opaque[], opaque[], int, string, uint64*, opaque*) Native(xgboost) :Returns(int) {}


=head2 XGBoosterSetAttr

=cut

sub XGBoosterSetAttr :Args(opaque, string, string) :Native(xgboost) :Returns(int) {}

=head2 XGBoosterGetAttr

=cut

sub XGBoosterGetAttr :Args(opaque, string, opaque*, int*) :Native(xgboost) :Returns(int) {}

=head2 XGBoosterGetAttrNames

=cut

sub XGBoosterGetAttrNames :Args(opaque, uint64*, opaque*) :Native(xgboost) :Returns(int) {}

1;
