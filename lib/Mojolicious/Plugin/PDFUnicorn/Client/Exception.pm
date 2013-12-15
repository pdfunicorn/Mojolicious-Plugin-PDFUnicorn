package Mojolicious::Plugin::PDFUnicorn::Client::Exception;
use Mojo::Base 'Mojo::Exception';

sub to_string {
    my $self = shift;
 
    my $str = (ref $self->message) ? Data::Dumper->Dumper($self->message) : $self->message;
    return $str  unless $self->verbose;

    $str .= "\n";
 
    # Before
    $str .= $_->[0] . ': ' . $_->[1] . "\n" for @{$self->lines_before};
 
    # Line
    $str .= ($self->line->[0] . ': ' . $self->line->[1] . "\n")
        if $self->line->[0];
 
    # After
    $str .= $_->[0] . ': ' . $_->[1] . "\n" for @{$self->lines_after};
 
    return $str;
}


1;
