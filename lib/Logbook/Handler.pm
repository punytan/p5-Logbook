package Logbook::Handler;
use strict;
use warnings;
use Logbook::Util;

sub new {
    my ($class, %args) = @_;

    my ($pkg, $opts) = %{$args{formatter}};
    $pkg = Logbook::Util::load_class($pkg, "Logbook::Formatter");

    my $self = bless {
        formatter       => $pkg->new(%$opts),
        level_condition => $args{level_condition} || sub { 1 },
    }, $class;

    $self->init(%args);

    $self;
}

sub init { }

sub formatter  { $_[0]->{formatter} }
sub should_log { $_[0]->{level_condition}->($_[1]) }

sub write { }

1;
__END__

=head1 NAME

Logbook::Handler - Base output handler class for Logbook

=head1 METHODS

=head2 C<formatter>

Accessor to the formatter instance.

=head2 C<write($level, @args)>

If the log level condition is sufficient, logger calls C<write> method with formatted log message.

=head1 AUTHOR

punytan E<lt>punytan@gmail.comE<gt>

=head1 SEE ALSO

L<Logbook::Handler::Screen>
L<Logbook::Handler::File>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

