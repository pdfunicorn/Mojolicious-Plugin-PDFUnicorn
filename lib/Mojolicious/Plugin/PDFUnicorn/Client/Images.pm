package Mojolicious::Plugin::PDFUnicorn::Client::Images;
use Mojo::Base 'Mojolicious::Plugin::PDFUnicorn::Client::Base';

#---
# create (\%data, \%options)
#
# Args:
#   - name: ''
#     file: ''
#   - callback: sub{ my ($doc) = @_; ...  }
#
# Returns (or calls callback with):
#   image meta data

sub create{
    my ($self, $image, $options) = @_;
    
    $options ||= {};
    my $callback = $options->{callback};    
    
    my $ua = Mojo::UserAgent->new;
    my $url = $self->url_base.'/api/v1/images'. ($options->{binary} ? '.binary' : '');

    my $headers = { 'Authorization' => 'Basic '.$self->config->{api}{key} };
        
    if ($callback){
        $ua->post(
            $url,
            $headers,
            form => {
                image => { file => $image->{file} },
                name => $image->{name},
            },
            $self->callback($callback)
        );
        return 1;
    }

    my $tx = $ua->post(
        $url,
        $headers,
        form => {
            image => { file => $image->{file} },
            name => $image->{name},
        }
    );
    my $res = $tx->res;
        
    return $options->{binary} ? $res->body : $res->json->{data};

}

1;
