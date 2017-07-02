#!/usr/bin/env perl 

use strict;
use warnings;
use utf8;
use 5.010;
use aliased 'AI::XGBoost::DMatrix';
use AI::XGBoost qw(train);

# We are going to solve a binary classification problem:
#  Mushroom poisonous or not

my $train_data = DMatrix->FromFile(filename => 'agaricus.txt.train');
my $test_data = DMatrix->FromFile(filename => 'agaricus.txt.test');

# With XGBoost we can solve this problem using 'gbtree' booster
#  and as loss function a logistic regression 'binary:logistic'
#  (Gradient Boosting Regression Tree)
# XGBoost Tree Booster has some parameters that we can tune
# For this example we are going to use some "defaults"

say "Training...";
my $booster = train(data => $train_data, number_of_rounds => 10);

say "Predicting...";
my $predictions = $booster->predict(data => $test_data);

say join "\n", @$predictions[0 .. 10];






