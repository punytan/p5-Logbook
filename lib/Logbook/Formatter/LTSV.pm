package Logbook::Formatter::LTSV;
use strict;
use warnings;
use parent 'Logbook::Formatter';
use Hash::Flatten ();

sub init {
    my ($self, %args) = @_;

    $self->{sort_keys}  = $args{sort_keys}   // 1;
    $self->{serializer} = $args{serializer} // sub {
        my @args = @_;

        if (@args == 0) {
            return "";

        } elsif (@args == 1) {
            if (defined $args[0] && ref $args[0]) {
                return Hash::Flatten::flatten(
                    { message => $args[0] },
                    {
                        HashDelimiter  => '.',
                        ArrayDelimiter => ':',
                    }
                );
            } else {
                return $args[0];
            }

        } else {
            return Hash::Flatten::flatten(
                [ @args ],
                {
                    HashDelimiter  => '.',
                    ArrayDelimiter => ':',
                }
            );
        }
    };

    $self;
}

sub serialize {
    my $self = shift;
    $self->{serializer} ? $self->{serializer}->(@_) : @_;
}

sub format {
    my ($self, $level, @args) = @_;
    my $log = $self->serialize(@args);

    my %log_hash = (
        level => $self->level_name($level),
        ref $log eq 'HASH' ? %$log : (message => $log),
    );

    my @keys = ($self->{sort_keys} ? sort keys %log_hash : keys %log_hash);

    return join "\t", (map { "$_:$log_hash{$_}" =~ s/\t/\\t/gr } @keys);
}

1;
__END__

