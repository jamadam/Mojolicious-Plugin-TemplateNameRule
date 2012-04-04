use strict;
use warnings;
use utf8;
use lib 'lib';
use Mojolicious::Lite;
use Test::Mojo;
use Test::More tests => 12;

app->renderer->paths(['t/templates2']);

get '/manual' => sub {
	my $c = shift;
	$c->render('index');
};
get '/manual2' => sub {
	my $c = shift;
	$c->render(template => 'index', handler => 'ep', format => 'html');
};
get '/manual3' => sub {
	my $c = shift;
	$c->render(template => 'index', handler => 'ep', format => 'json');
};
get '/manual4' => sub {
	my $c = shift;
	$c->render(template => 'index', handler => 'epl', format => 'json');
};
get '/dir/index' => 'dir/index';
get '/index2' => 'index2';
get '/index' => 'index';

plugin TemplateNameRule => {pattern => '%template.%handler.%format'};

my $t = Test::Mojo->new;
$t->get_ok('/index')
	->status_is(200)
	->content_is("index.ep.html\n");
$t->get_ok('/index2')
	->status_is(200)
	->content_is("index2.epl.html\n");
$t->get_ok('/dir/index')
	->status_is(200)
	->content_is("dir/index.ep.html\n");
$t->get_ok('/manual2')
	->status_is(200)
	->content_is("index.ep.html\n");
