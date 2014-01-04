package Mojolicious::Plugin::PDFUnicorn::Client::Documents;
use Mojo::Base 'Mojolicious::Plugin::PDFUnicorn::Client::Base';

#---
# create (\%data, \%options)
#
# Args:
#   - source: ''
#     template: ''
#     data: ''
#   - callback: sub{ my ($doc) = @_; ... }
#     binary: 1
#
# Returns (or calls callback with):
#   meta is true: document meta data
#   meta is false: a PDF document as binary data

sub create{
    my ($self, $doc_meta, $options) = @_;
    
    $options ||= {};
    my $callback = $options->{callback};

    my $ua = Mojo::UserAgent->new;
    my $url = $self->url_base.'/api/v1/documents'. ($options->{binary} ? '.binary' : '');
    
    if ($callback){
        $ua->post($url, json => $doc_meta, $self->callback($callback));
        return 1;
    }

    my $tx = $ua->post($url, json => $doc_meta);
    my $res = $tx->res;

    if ($res->code != 200){
        Mojolicious::Plugin::PDFUnicorn::Client::Exception->throw({
            errors => $res->json->{data}{errors},
        });
    }

    if ($res->headers->content_type eq 'application/json'){
        return $res->json->{data};
    } else {
        return $res->body;
    }

}

#---
# fetch (\%query_meta, \%options)
#
# Args:
#   - id: ''
#     uri: ''
#   - callback: sub{ my ($doc) = @_ }
#     meta: 1
#
# Returns (or calls callback with):
#   meta is true: document meta data
#   meta is false: a PDF document as binary data

sub fetch{
    my ($self, $query_meta, $options) = @_;
    
    die 'fetch needs an id or uri in the query_meta'
        unless $query_meta->{uri} || $query_meta->{id};
    
    $options ||= {};
    my $callback = $options->{callback};
    my $binary = $options->{binary};
        
    my $uri = $query_meta->{uri} || '/api/v1/documents/'.$query_meta->{id};
    
    my $ua = Mojo::UserAgent->new;
    my $url = $self->url_base . $uri. ($binary ? '.binary' : '');

    if ($callback){
        $ua->get($url, $self->callback($callback));        
        return 1;
    }

    my $tx = $ua->get($url);
    my $res = $tx->res;
        
    if ($res->headers->content_type eq 'application/json'){
        return $res->json->{data};
    } else {
        return $res->body;
    }

}


1;
