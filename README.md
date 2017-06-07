# NAME

AI::XGBoost - Perl wrapper for XGBoost library [https://github.com/dmlc/xgboost](https://github.com/dmlc/xgboost)

# VERSION

version 0.004

# SYNOPSIS

```perl
use 5.010;
use AI::XGBoost::CAPI::RAW;
use FFI::Platypus;

my $silent = 0;
my ($dtrain, $dtest) = (0, 0);

AI::XGBoost::CAPI::RAW::XGDMatrixCreateFromFile('agaricus.txt.test', $silent, \$dtest);
AI::XGBoost::CAPI::RAW::XGDMatrixCreateFromFile('agaricus.txt.train', $silent, \$dtrain);

my ($rows, $cols) = (0, 0);
AI::XGBoost::CAPI::RAW::XGDMatrixNumRow($dtrain, \$rows);
AI::XGBoost::CAPI::RAW::XGDMatrixNumCol($dtrain, \$cols);
say "Dimensions: $rows, $cols";

my $booster = 0;

AI::XGBoost::CAPI::RAW::XGBoosterCreate( [$dtrain] , 1, \$booster);

for my $iter (0 .. 10) {
    AI::XGBoost::CAPI::RAW::XGBoosterUpdateOneIter($booster, $iter, $dtrain);
}

my $out_len = 0;
my $out_result = 0;

AI::XGBoost::CAPI::RAW::XGBoosterPredict($booster, $dtest, 0, 0, \$out_len, \$out_result);
my $ffi = FFI::Platypus->new();
my $predictions = $ffi->cast(opaque => "float[$out_len]", $out_result);

#say join "\n", @$predictions;

AI::XGBoost::CAPI::RAW::XGBoosterFree($booster);
```

# DESCRIPTION

Perl wrapper for XGBoost library. This version only wraps part of the C API.

The documentation can be found in [AI::XGBoost::CAPI::RAW](https://metacpan.org/pod/AI::XGBoost::CAPI::RAW)

Currently this module need the xgboost binary available in your system. 
I'm going to make an Alien module for xgboost but meanwhile you need to
compile yourself xgboost: [https://github.com/dmlc/xgboost](https://github.com/dmlc/xgboost)

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
