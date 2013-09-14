use strict;
use warnings;
use Test::More;
use Logbook::Handler;

is ref Logbook::Handler->new, 'Logbook::Handler';

done_testing;
