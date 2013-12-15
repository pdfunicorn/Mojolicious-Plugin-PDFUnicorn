package Mojolicious::Plugin::PDFUnicorn;
use Mojo::Base 'Mojolicious::Plugin';

# ABSTRACT: API client for pdfunicorn.com

use strict;
use warnings;
use Mojo::UserAgent;
use Data::Dumper;

use Mojolicious::Plugin::PDFUnicorn::Client;


sub register {
    my ($self, $app, $conf) = @_;
        
    $app->helper(
        pdfunicorn => sub {
            my $self = shift;
            return $self->stash->{pdfunicorn} ||= Mojolicious::Plugin::PDFUnicorn::Client->new({ config => $app->config->{pdfunicorn} });
        }
    );
    
}


1;
