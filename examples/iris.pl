use aliased 'AI::XGBoost::DMatrix';
use AI::XGBoost qw(train);
use Data::Dataset::Classic::Iris;

my %class = (
    setosa => 0,
    versicolor => 1,
    virginica => 2
);

my $iris = Data::Dataset::Classic::Iris::get();

my $train_dataset = [map {$iris->{$_}} grep {$_ ne 'species'} keys %$iris];
my $test_dataset = [map {$iris->{$_}} grep {$_ ne 'species'} keys %$iris];
my $train_label = [map {$class{$_}} @{$iris->{'species'}}];
my $test_label = [map {$class{$_}} @{$iris->{'species'}}];

my $train_data = DMatrix->From(matrix => $train_dataset, label => $train_label);
my $test_data = DMatrix->From(matrix => $test_dataset, label => $test_label);

my $booster = train(data => $train_data, number_of_rounds => 20, params => {
        max_depth => 3,
        eta => 0.3,
        silent => 1,
        objective => 'multi:softprob',
        num_class => 3
    });

my $predictions = $booster->predict(data => $test_data);



