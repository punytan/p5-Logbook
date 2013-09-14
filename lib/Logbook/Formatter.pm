package Logbook::Formatter;
use strict;
use warnings;
use Time::Piece;
use Time::HiRes;
use File::Basename ();
use Sys::Hostname  ();
use Data::Dumper   ();
use Logbook::Severity;

sub new {
    my ($class, %args) = @_;

    my $timestamp_format = $args{timestamp_format} // '%Y-%m-%dT%H:%M:%S';
    my $auto_newline     = $args{auto_newline}     // 1;
    my $caller_level     = $args{caller_level}     // 4;
    my $message_layout   = $args{message_layout}   // "%id, [%timestamp #%pid] %level_fixed -- %package: %message at %filename line %line";

    my $dumper = $args{dumper} // sub {
        my ($message, @args) = @_;

        local $Data::Dumper::Terse    = 1;
        local $Data::Dumper::Indent   = 0;
        local $Data::Dumper::SortKeys = 1;

        if (@args == 1) {
            if (ref $args[0]) {
                return join " ", $message, Data::Dumper::Dumper($args[0]);
            } else {
                return join " ", $message, $args[0] // '';
            }
        } elsif (@args > 1) {
            return join " ", $message, Data::Dumper::Dumper([ @args ]);
        } else {
            return join " ", $message;
        }
    };

    my $self = bless {
        dumper           => $dumper,
        timestamp_format => $timestamp_format,
        auto_newline     => $auto_newline,
        caller_level     => $caller_level,
        message_layout   => $message_layout,
    }, $class;

    $self->init(%args);

    $self;
}

sub dump {
    my ($self, @args) = @_;
    $self->{dumper}->(@args);
}

sub render_layout {
    my ($self, $level, $message) = @_;

    my $caller = $self->caller;
    my %map = (
        level_fixed => sub { sprintf "%5s", __PACKAGE__->level_name($level) },
        package  => sub { $caller->{package} },
        message  => sub { $message },
        filename => sub { $caller->{filename} },
        line     => sub { $caller->{line} },
    );

    my $layout = $self->{message_layout};
    $layout =~ s!
        \%(
             id
            |timestamp
            |level_fixed
            |level
            |pid
            |hostname
            |user
            |group
            |basename
            |package
            |message
            |filename
            |line
        )
    !
        $map{$1} ? $map{$1}->($level) : $self->$1($level)
    !gex;

    $layout;
}

sub timestamp {
    my $self = shift;
    my ($seconds, $microseconds) = Time::HiRes::gettimeofday;
    localtime( Time::Piece->strptime($seconds, "%s")->epoch )
        ->strftime($self->{timestamp_format});
}

sub level_name {
    my ($self, $level) = @_;
    $Logbook::Severity::NAME->{$level};
}

sub level    { $Logbook::Severity::NAME->{$_[0]} }
sub id       { substr(__PACKAGE__->level_name($_[1]), 0, 1) }
sub pid      { $$ }
sub hostname { Sys::Hostname::hostname() }
sub user     { scalar getpwuid($<) }
sub group    { scalar getgrgid($(+0) }
sub basename { File::Basename::basename($0) }
sub caller   {
    my ($package, $filename, $line);
    for (my $i = 0; ($package, $filename, $line) = caller $i; $i++) {
        last if $package !~ /^Logbook/;
    }
    return { package => $package, filename => $filename, line => $line };
}

1;
__END__

=head1 NAME

Logbook::Formatter - Base formatter class for Logbook

=head1 SEE ALSO

L<Logbook::Formatter::Default>
L<Logbook::Formatter::LTSV>

=head1 AUTHOR

punytan E<lt>punytan@gmail.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

