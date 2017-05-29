package AI::XGBoost::CAPI;
use strict;
use warnings;

use parent 'NativeCall';

# VERSION

# ABSTRACT: Perl wrapper for XGBoost C API https://github.com/dmlc/xgboost

=encoding utf-8

=head1 SYNOPSIS

# EXAMPLE: examples/capi.pl

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

1;
