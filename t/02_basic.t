use strict;
use warnings;
use utf8;
use lib 'lib';
use Mojolicious::Lite;
use Test::Mojo;

plugin TemplateNameRule => {cb => sub {
	my $template    = shift;
	my $format      = shift;
	my $handler     = shift;
	return "$template.$format.$handler";
}};

my $t = Test::Mojo->new;
$t->get_ok('/dir1')->status_is(200);
