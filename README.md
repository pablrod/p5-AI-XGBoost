# NAME

AI::XGBoost - Perl wrapper for XGBoost library https://github.com/dmlc/xgboost

# VERSION

version 0.001

# SYNOPSIS

```perl
use 5.010;
use AI::XGBoost::CAPI;
use FFI::Platypus;

my $silent = 0;
my ($dtrain, $dtest) = (0, 0);

AI::XGBoost::CAPI::XGDMatrixCreateFromFile('agaricus.txt.test', $silent, \$dtest);
AI::XGBoost::CAPI::XGDMatrixCreateFromFile('agaricus.txt.train', $silent, \$dtrain);

my ($rows, $cols) = (0, 0);
AI::XGBoost::CAPI::XGDMatrixNumRow($dtrain, \$rows);
AI::XGBoost::CAPI::XGDMatrixNumCol($dtrain, \$cols);
say "Dimensions: $rows, $cols";

my $booster = 0;

AI::XGBoost::CAPI::XGBoosterCreate( [$dtrain] , 1, \$booster);

for my $iter (0 .. 10) {
    AI::XGBoost::CAPI::XGBoosterUpdateOneIter($booster, $iter, $dtrain);
}

my $out_len = 0;
my $out_result = 0;

AI::XGBoost::CAPI::XGBoosterPredict($booster, $dtest, 0, 0, \$out_len, \$out_result);
my $ffi = FFI::Platypus->new();
my $predictions = $ffi->cast(opaque => "float[$out_len]", $out_result);

#say join "\n", @$predictions;

AI::XGBoost::CAPI::XGBoosterFree($booster);
```

# DESCRIPTION

Perl wrapper for XGBoost library. This version only wraps the C API.

The documentation can be found in [AI::XGBoost::CAPI](https://metacpan.org/pod/AI::XGBoost::CAPI)

# AUTHOR

Pablo Rodríguez González <pablo.rodriguez.gonzalez@gmail.com>

# COPYRIGHT AND LICENSE

Copyright (c) 2017 by Pablo Rodríguez González.

This is free software, licensed under:

```
The Apache License, Version 2.0, January 2004
```
