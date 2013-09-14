use strict;
use warnings;
use Test::More;
use Logbook::Handler;

my $handler = Logbook::Handler->new(
    formatter => {
        Default => {}
    }
);

is ref $handler, 'Logbook::Handler';

done_testing;
