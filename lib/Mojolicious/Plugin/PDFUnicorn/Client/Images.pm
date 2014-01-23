package Mojolicious::Plugin::PDFUnicorn::Client::Images;
use Mojo::Base 'Mojolicious::Plugin::PDFUnicorn::Client::Base';

#---
# create (\%data, \%options)
#
# Args:
#   - src: ''
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
    my $url = $self->url_base.'/v1/images'. ($options->{img} ? '.img' : '');

    if ($callback){
        $ua->post(
            $url,
            form => {
                image => { file => $image->{file} },
                src => $image->{src},
            },
            $self->callback($callback)
        );
        return 1;
    }

    my $tx = $ua->post(
        $url,
        form => {
            image => { file => $image->{file} },
            src => $image->{src},
        }
    );
    my $res = $tx->res;
        
    return $options->{img} ? $res->body : $res->json;

}

1;
