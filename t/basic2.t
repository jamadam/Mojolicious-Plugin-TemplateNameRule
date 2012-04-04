use strict;
use warnings;
use utf8;
use lib 'lib';
use Mojolicious::Lite;
use Test::Mojo;
use Test::More tests => 3;

app->renderer->paths(['t/templates2']);

get '/index' => 'index3';

plugin TemplateNameRule => {pattern => '%template.%format'};

my $t = Test::Mojo->new;
$t->get_ok('/index')
	->status_is(200)
	->content_is("index3.html\n");
