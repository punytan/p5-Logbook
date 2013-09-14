package Logbook;
use strict;
use warnings;
use Logbook::Util;
use Logbook::Severity;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my @args  = @_ ? @_ : ( Screen => {} );

    my @handlers;
    while (my ($handler_class, $opts) = splice @args, 0, 2) {

        my $pkg = Logbook::Util::load_class($handler_class, "Logbook::Handler");
        $opts->{formatter} ||= {
            Default => {
                enable_color     => ($pkg eq 'Logbook::Handler::Screen' ? 1 : 0),
                timestamp_format => undef,
            }
        };

        my $handler = $pkg->new(%$opts);
        push @handlers, $handler;
    }

    return bless {
        handlers => [ @handlers ],
    }, $class;
}

sub debug   { shift->log(LOG_LEVEL_DEBUG,   @_) }
sub error   { shift->log(LOG_LEVEL_ERROR,   @_) }
sub warn    { shift->log(LOG_LEVEL_WARN,    @_) }
sub info    { shift->log(LOG_LEVEL_INFO,    @_) }
sub fatal   { shift->log(LOG_LEVEL_FATAL,   @_) }
sub unknown { shift->log(LOG_LEVEL_UNKNOWN, @_) }

sub log {
    my ($self, $level, @args) = @_;

    for my $handler (@{ $self->{handlers} }) {
        next unless $handler->should_log($level);

        my $message = $handler->formatter->format($level, @args);
        if ($handler->formatter->{auto_newline}) {
            chomp $message;
            $message = "$message\n";
        }

        $handler->write($message);
    }
}

1;
__END__

=head1 NAME

Logbook - Lightweight logging library

=head1 SYNOPSIS

  use Logbook;

=head1 DESCRIPTION

Logbook is

=head1 AUTHOR

punytan E<lt>punytan@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
