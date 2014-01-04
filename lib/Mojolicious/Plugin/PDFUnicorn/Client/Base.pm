package Mojolicious::Plugin::PDFUnicorn::Client::Base;
use Mojo::Base -base;

use Mojolicious::Plugin::PDFUnicorn::Client::Exception;

has 'config';

sub url_base{
    my ($self) = @_;
    return join('',
        $self->config->{api}{url_scheme},
        '://',
        $self->config->{api}{key},
        ':@',
        $self->config->{api}{host},
    );
}

sub callback{
    my ($self, $subordinate) = @_;
    return sub{
        my ($ua, $tx) = @_;
        my $res = $tx->res;
        if ($res->status != 200){
            Mojo::Exception->throw({
                
            });
        }
        if ($res->headers->content_type eq 'application/json'){
            $subordinate->($res->json->{data});
        } else {
            $subordinate->($res->body);
        }
    };
}

1;
