package Logbook::Severity;
use strict;
use warnings;
use Constant::Exporter (
    EXPORT_TAGS => {
        level => {
        LOG_LEVEL_DEBUG   => 1,
        LOG_LEVEL_INFO    => 1 << 1,
        LOG_LEVEL_WARN    => 1 << 2,
        LOG_LEVEL_ERROR   => 1 << 3,
        LOG_LEVEL_FATAL   => 1 << 4,
        LOG_LEVEL_UNKNOWN => 1 << 5,
        }
    },
);

our $NAME = {
    LOG_LEVEL_DEBUG,   'DEBUG',
    LOG_LEVEL_INFO,    'INFO',
    LOG_LEVEL_WARN,    'WARN',
    LOG_LEVEL_ERROR,   'ERROR',
    LOG_LEVEL_FATAL,   'FATAL',
    LOG_LEVEL_UNKNOWN, 'ANY',
};

our $MAP = { reverse %$NAME };

1;
__END__

