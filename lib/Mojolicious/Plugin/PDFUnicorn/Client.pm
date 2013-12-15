package Mojolicious::Plugin::PDFUnicorn::Client;
use Mojo::Base -base;

use Mojolicious::Plugin::PDFUnicorn::Client::Documents;
use Mojolicious::Plugin::PDFUnicorn::Client::Images;


has 'config';

sub documents{
    return Mojolicious::Plugin::PDFUnicorn::Client::Documents->new({
        config => shift->config
    })
}

sub images{
    return Mojolicious::Plugin::PDFUnicorn::Client::Images->new({
        config => shift->config
    })
}


1;
