
#!/usr/bin/env perl
use strict;
use warnings;

# Disable IPv6, epoll and kqueue
BEGIN { $ENV{MOJO_NO_IPV6} = $ENV{MOJO_POLL} = 1 }

use Test::More;

use Try;

use Mojolicious::Plugin::PDFUnicorn;


my $client = Mojolicious::Plugin::PDFUnicorn::Client->new({
    config => {
        api => {
            url_scheme => 'http',
            key => 'testers-api-key',
            host => 'localhost:3000',
        }
    }
});

my $doc;


# try to create a doc without providing source

try{
    $doc = $client->documents->create({});
} catch {
    my $exception = $_;
    is($exception->{message}{errors}[0], 'Document - Missing required attribute value: "source"');
    warn Data::Dumper->Dumper($exception);
}


# create doc and get metadata

$doc = $client->documents->create({
    source => '<doc size="b5"><page>Hello World!</page></doc>'
});

is($doc->{source}, '<doc size="b5"><page>Hello World!</page></doc>', "source ok");
ok($doc->{owner}, "owner ok");
ok($doc->{_id}, "_id ok");
ok($doc->{uri}, "uri ok");
ok($doc->{modified}, "modified ok");
ok($doc->{created}, "created ok");
ok(!$doc->{file}, "file ok");


# fetch doc

my $doc3 = $client->documents->fetch($doc);
is($doc3->{source}, '<doc size="b5"><page>Hello World!</page></doc>', "source ok");
ok($doc3->{owner}, "owner ok");
ok($doc3->{_id}, "_id ok");
ok($doc3->{uri}, "uri ok");
ok($doc3->{modified}, "modified ok");
ok($doc3->{created}, "created ok");
ok(!$doc3->{file}, "file ok");


# fetch pdf

my $doc4 = $client->documents->fetch($doc, { binary => 1 });
ok($doc4 =~ /^%PDF/, 'doc is a PDF');


# create doc and get binary

my $doc2 = $client->documents->create({
    source => '<doc><page>Hello World!</page></doc>',
}, { binary => 1 });
ok($doc2 =~ /^%PDF/, 'doc is a PDF');


# create image and get image meta-data

my $img1 = $client->images->create({
    file => 't/unicorn_48.png',
    name => '/stock/logo.png',
});

is($img1->{name}, "stock/logo.png", "name ok");
ok($img1->{owner}, "owner ok");
ok($img1->{_id}, "_id ok");
ok($img1->{uri}, "uri ok");
ok($img1->{modified}, "modified ok");
ok($img1->{created}, "created ok");

my $img2 = $client->images->create({
    file => 't/unicorn_48.png',
    name => '/stock/logo.png',
}, { binary => 1 });

ok($img2 =~ /^.{1,3}PNG/, 'doc is an image');


Mojo::IOLoop->timer(2 => sub { Mojo::IOLoop->stop });
Mojo::IOLoop->start;

done_testing();


