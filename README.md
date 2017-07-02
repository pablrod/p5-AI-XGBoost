# NAME

AI::XGBoost - Perl wrapper for XGBoost library [https://github.com/dmlc/xgboost](https://github.com/dmlc/xgboost)

# VERSION

version 0.005

# SYNOPSIS

```perl
use 5.010;
use AI::XGBoost::CAPI qw(:all);

my $dtrain = XGDMatrixCreateFromFile('agaricus.txt.train');
my $dtest = XGDMatrixCreateFromFile('agaricus.txt.test');

my ($rows, $cols) = (XGDMatrixNumRow($dtrain), XGDMatrixNumCol($dtrain));
say "Train dimensions: $rows, $cols";

my $booster = XGBoosterCreate([$dtrain]);

for my $iter (0 .. 10) {
    XGBoosterUpdateOneIter($booster, $iter, $dtrain);
}

my $predictions = XGBoosterPredict($booster, $dtest);
# say join "\n", @$predictions;

XGBoosterFree($booster);
XGDMatrixFree($dtrain);
XGDMatrixFree($dtest);
```

# DESCRIPTION

Perl wrapper for XGBoost library. This version only wraps part of the C API.

The documentation can be found in [AI::XGBoost::CAPI::RAW](https://metacpan.org/pod/AI::XGBoost::CAPI::RAW)

Currently this module need the xgboost binary available in your system. 
I'm going to make an Alien module for xgboost but meanwhile you need to
compile yourself xgboost: [https://github.com/dmlc/xgboost](https://github.com/dmlc/xgboost)

# FUNCTIONS

## train

# ROADMAP

The goal is to make a full wrapper for XGBoost.

## VERSIONS

- 0.1 

    Full raw C API available as [AI::XGBoost::CAPI::RAW](https://metacpan.org/pod/AI::XGBoost::CAPI::RAW)

- 0.2 

    Full C API "easy" to use, with PDL support as [AI::XGBoost::CAPI](https://metacpan.org/pod/AI::XGBoost::CAPI)

    Easy means clients don't have to use [FFI::Platypus](https://metacpan.org/pod/FFI::Platypus) or modules dealing
    with C structures

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

This software is Copyright (c) 2017 by Pablo Rodríguez González.

This is free software, licensed under:

```
The Apache License, Version 2.0, January 2004
```
