package Logbook::Formatter::Default;
use strict;
use warnings;
use parent 'Logbook::Formatter';

sub init {
    my ($self, %args) = @_;

    if ($args{enable_color}) {
        require Term::ANSIColor;
        $self->{enable_color} = $args{enable_color} // 0;
        $self->{color} = $args{color} // {
            DEBUG => [ qw/ red   on_white  / ],
            INFO  => [ qw/ green           / ],
            WARN  => [ qw/ black on_yellow / ],
            ERROR => [ qw/ red   on_black  / ],
            FATAL => [ qw/ black on_red    / ],
            ANY   => [ qw/ red   on_black  / ],
        };
    }

    $self;
}

sub format {
    my ($self, $level, @args) = @_;
    my $level_name = $self->level_name($level);

    my $line = $self->{dumper} ? $self->dump(@args) : @args;
    my $message = $self->{enable_color}
        ? Term::ANSIColor::colored($self->{color}{$level_name},$line)
        : "$line";

    my $x = $self->render_layout($level, $message);
    return $x;
}

1;
__END__

