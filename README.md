# NAME

AI::XGBoost - Perl wrapper for XGBoost library [https://github.com/dmlc/xgboost](https://github.com/dmlc/xgboost)

# VERSION

version 0.11

# SYNOPSIS

```perl
use 5.010;
use aliased 'AI::XGBoost::DMatrix';
use AI::XGBoost qw(train);

# We are going to solve a binary classification problem:
#  Mushroom poisonous or not

my $train_data = DMatrix->From(file => 'agaricus.txt.train');
my $test_data = DMatrix->From(file => 'agaricus.txt.test');

# With XGBoost we can solve this problem using 'gbtree' booster
#  and as loss function a logistic regression 'binary:logistic'
#  (Gradient Boosting Regression Tree)
# XGBoost Tree Booster has a lot of parameters that we can tune
# (https://github.com/dmlc/xgboost/blob/master/doc/parameter.md)

my $booster = train(data => $train_data, number_of_rounds => 10, params => {
        objective => 'binary:logistic',
        eta => 1.0,
        max_depth => 2,
        silent => 1
    });

# For binay classification predictions are probability confidence scores in [0, 1]
#  indicating that the label is positive (1 in the first column of agaricus.txt.test)
my $predictions = $booster->predict(data => $test_data);

say join "\n", @$predictions[0 .. 10];

use aliased 'AI::XGBoost::DMatrix';
use AI::XGBoost qw(train);
use Data::Dataset::Classic::Iris;

# We are going to solve a multiple classification problem:
#  determining plant species using a set of flower's measures 

# XGBoost uses number for "class" so we are going to codify classes
my %class = (
    setosa => 0,
    versicolor => 1,
    virginica => 2
);

my $iris = Data::Dataset::Classic::Iris::get();

# Split train and test, label and features
my $train_dataset = [map {$iris->{$_}} grep {$_ ne 'species'} keys %$iris];
my $test_dataset = [map {$iris->{$_}} grep {$_ ne 'species'} keys %$iris];

sub transpose {
# Transposing without using PDL, Data::Table, Data::Frame or other modules
# to keep minimal dependencies
    my $array = shift;
    my @aux = ();
    for my $row (@$array) {
        for my $column (0 .. scalar @$row - 1) {
            push @{$aux[$column]}, $row->[$column];
        }
    }
    return \@aux;
}

$train_dataset = transpose($train_dataset);
$test_dataset = transpose($test_dataset);

my $train_label = [map {$class{$_}} @{$iris->{'species'}}];
my $test_label = [map {$class{$_}} @{$iris->{'species'}}];

my $train_data = DMatrix->From(matrix => $train_dataset, label => $train_label);
my $test_data = DMatrix->From(matrix => $test_dataset, label => $test_label);

# Multiclass problems need a diferent objective function and the number
#  of classes, in this case we are using 'multi:softprob' and
#  num_class => 3
my $booster = train(data => $train_data, number_of_rounds => 20, params => {
        max_depth => 3,
        eta => 0.3,
        silent => 1,
        objective => 'multi:softprob',
        num_class => 3
    });

my $predictions = $booster->predict(data => $test_data);
```

# DESCRIPTION

Perl wrapper for XGBoost library. 

The easiest way to use the wrapper is using `train`, but beforehand 
you need the data to be used contained in a `DMatrix` object

This is a work in progress, feedback, comments, issues, suggestion and
pull requests are welcome!!

XGBoost library is used via [Alien::XGBoost](https://metacpan.org/pod/Alien::XGBoost). That means downloading,
compiling and installing if it's not available in your system.

# FUNCTIONS

## train

Performs gradient boosting using the data and parameters passed

Returns a trained AI::XGBoost::Booster used

### Parameters

- params

    Parameters for the booster object. 

    Full list available: https://github.com/dmlc/xgboost/blob/master/doc/parameter.md 

- data

    AI::XGBoost::DMatrix object used for training

- number\_of\_rounds

    Number of boosting iterations

# ROADMAP

The goal is to make a full wrapper for XGBoost.

## VERSIONS

- 0.2 

    Full C API "easy" to use, with PDL support as [AI::XGBoost::CAPI](https://metacpan.org/pod/AI::XGBoost::CAPI)

    Easy means clients don't have to use [FFI::Platypus](https://metacpan.org/pod/FFI::Platypus) or modules dealing
    with C structures

- 0.25

    Alien package for libxgboost.so/xgboost.dll

- 0.3

    Object oriented API Moose based with DMatrix and Booster classes

- 0.4

    Complete object oriented API

- 0.5

    Use perl signatures ([https://metacpan.org/pod/distribution/perl/pod/perlexperiment.pod#Subroutine-signatures](https://metacpan.org/pod/distribution/perl/pod/perlexperiment.pod#Subroutine-signatures))

# SEE ALSO

- [AI::MXNet](https://metacpan.org/pod/AI::MXNet)
- [FFI::Platypus](https://metacpan.org/pod/FFI::Platypus)
- [NativeCall](https://metacpan.org/pod/NativeCall)

# AUTHOR

Pablo Rodríguez González <pablo.rodriguez.gonzalez@gmail.com>

# COPYRIGHT AND LICENSE

Copyright (c) 2017 by Pablo Rodríguez González.

This is free software, licensed under:

```
The Apache License, Version 2.0, January 2004
```

# CONTRIBUTOR

Ruben <me@ruben.tech>
