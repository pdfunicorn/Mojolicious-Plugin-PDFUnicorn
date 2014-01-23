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
#     pdf: 1
#
# Returns (or calls callback with):
#   pdf is false: document meta data
#   pdf is true: a PDF document

sub create{
    my ($self, $doc_meta, $options) = @_;
    
    $options ||= {};
    my $callback = $options->{callback};

    my $ua = Mojo::UserAgent->new;
    my $url = $self->url_base.'/v1/documents'. ($options->{pdf} ? '.pdf' : '');
    
    if ($callback){
        $ua->post($url, json => $doc_meta, $self->callback($callback));
        return 1;
    }

    my $tx = $ua->post($url, json => $doc_meta);
    my $res = $tx->res;

    if ($res->code != 200){
        Mojolicious::Plugin::PDFUnicorn::Client::Exception->throw({
            errors => $res->json ? $res->json->{errors} : $res->{error},
        });
    }

    return $res->headers->content_type eq 'application/json' ? $res->json : $res->body;
}

#---
# fetch (\%query_meta, \%options)
#
# Args:
#   - id: ''
#     uri: ''
#   - callback: sub{ my ($doc) = @_ }
#     pdf: 1
#
# Returns (or calls callback with):
#   pdf is false: document meta data
#   pdf is true: a PDF document

sub fetch{
    my ($self, $query_meta, $options) = @_;
    
    die 'fetch needs an id or uri in the query_meta'
        unless $query_meta->{uri} || $query_meta->{id};
    
    $options ||= {};
    my $callback = $options->{callback};
    my $pdf = $options->{pdf};
        
    my $uri = $query_meta->{uri} || '/v1/documents/'.$query_meta->{id};
    
    my $ua = Mojo::UserAgent->new;
    my $url = $self->url_base . $uri. ($pdf ? '.pdf' : '');

    if ($callback){
        $ua->get($url, $self->callback($callback));        
        return 1;
    }

    my $tx = $ua->get($url);
    my $res = $tx->res;
        
    return $res->headers->content_type eq 'application/json' ? $res->json : $res->body;
}


1;
