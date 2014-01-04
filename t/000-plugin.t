
#!/usr/bin/env perl
use strict;
use warnings;

# Disable IPv6, epoll and kqueue
BEGIN { $ENV{MOJO_NO_IPV6} = $ENV{MOJO_POLL} = 1 }

use Test::More;
plan tests => 10;


#testing code starts here
use Mojolicious::Lite;
use Test::Mojo;

plugin PDFUnicorn => {};
plugin 'Config' => { file => 'app.conf' };

get '/' => sub {
    my $self = shift;
    my $doc = $self->pdfunicorn->documents->create({
        id => "mycustomid",
        source => '<doc><page>Hello World!</page></doc>'
    });
	$self->render(json => { status => 'ok', data => $doc });    
};


my $t = Test::Mojo->new;

$t->get_ok('/')
    ->status_is(200)
    ->json_is( '/data/source' => "<doc><page>Hello World!</page></doc>", "correct source" )
    ->json_has( '/data/owner', "has owner" )
    ->json_has( '/data/_id', "has _id" )
    ->json_is( '/data/id' => "mycustomid", "correct id" )
    ->json_has( '/data/uri', "has uri" )
    ->json_has( '/data/modified', "has modified" )
    ->json_has( '/data/created', "has created" )
    ->json_is( '/data/file', undef, "file is undef" );
    

#$t->get_ok('/')
#    ->status_is(200)
#    ->json_is(
#        {
#            "status" => "invalid_request",
#            "data" => {
#                "errors" => [
#                    "Document - Missing required attribute value: \"source\""
#                ]
#            }
#        }
#    );
