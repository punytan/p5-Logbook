package Logbook::Handler::Screen;
use strict;
use warnings;
use parent 'Logbook::Handler';

sub init {
    my ($self, %args) = @_;

    $self->{layer}  = $args{layer}  // ':encoding(UTF-8)';
    $self->{log_to} = $args{log_to} // *STDERR;

    $self;
}

sub write {
    my ($self, $message) = @_;

    binmode $self->{log_to}, $self->{layer};
    print { $self->{log_to} } $message;
    binmode $self->{log_to}, ':pop';
}

1;
__END__
