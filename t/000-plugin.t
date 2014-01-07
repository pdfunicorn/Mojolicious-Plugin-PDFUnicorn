
#!/usr/bin/env perl
use strict;
use warnings;

# Disable IPv6, epoll and kqueue
BEGIN { $ENV{MOJO_NO_IPV6} = $ENV{MOJO_POLL} = 1 }

use Test::More;

#testing code starts here
use Mojolicious::Lite;
use Test::Mojo;

plugin PDFUnicorn => {};
plugin 'Config' => { file => 'app.conf' };

get '/' => sub {
    my $self = shift;
    my $doc = $self->pdfunicorn->documents->create({
        source => '<doc><page>Hello World!</page></doc>'
    });
	$self->render(json => $doc );    
};


my $t = Test::Mojo->new;

$t->get_ok('/')
    ->status_is(200)
    ->json_is( '/source' => "<doc><page>Hello World!</page></doc>", "correct source" )
    ->json_has( '/owner', "has owner" )
    ->json_has( '/id', "has id" )
    ->json_has( '/uri', "has uri" )
    ->json_has( '/modified', "has modified" )
    ->json_has( '/created', "has created" )
    ->json_is( '/file', undef, "file is undef" );
    

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

done_testing();

