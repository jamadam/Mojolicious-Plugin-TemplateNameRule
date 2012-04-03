package Mojolicious::Plugin::TemplateNameRule;
use strict;
use warnings;
use Mojo::Base 'Mojolicious::Plugin';
our $VERSION = '0.01';
    
    __PACKAGE__->attr('template_name');
    ### ---
    ### register
    ### ---
    sub register {
        my ($self, $app, $options) = @_;
        
        no warnings 'redefine';
        
        $self->template_name($options->{cb});
        
        *Mojolicious::Renderer::template_name = sub {
            my ($renderer, $options) = @_;
            my $template    = $options->{template};
            my $format      = $options->{format};
            my $handler     = $options->{handler};
            return $self->template_name->($template, $format, $handler);
        };
    }

1;

__END__

=head1 NAME

Mojolicious::Plugin::TemplateNameRule - Customize template naming rule

=head1 SYNOPSIS
  
=head1 DESCRIPTION

=head2 OPTIONS

=head1 METHODS

=head2 register

$plugin->register;

Register plugin hooks in L<Mojolicious> application.

=head2 psgi_env_to_mojo_req

This is a utility method. This is for internal use.

    my $mojo_req = psgi_env_to_mojo_req($psgi_env)

=head2 mojo_req_to_psgi_env

This is a utility method. This is for internal use.

    my $plack_env = mojo_req_to_psgi_env($mojo_req)

=head2 psgi_res_to_mojo_res

This is a utility method. This is for internal use.

    my $mojo_res = psgi_res_to_mojo_res($psgi_res)

=head2 mojo_res_to_psgi_res

This is a utility method. This is for internal use.

    my $psgi_res = mojo_res_to_psgi_res($mojo_res)

=head1 Example

Plack::Middleware::Auth::Basic

    $self->plugin(plack_middleware => [
        'Auth::Basic' => sub {shift->req->url =~ qr{^/?path1/}}, {
            authenticator => sub {
                my ($user, $pass) = @_;
                return $user eq 'user1' && $pass eq 'pass';
            }
        },
        'Auth::Basic' => sub {shift->req->url =~ qr{^/?path2/}}, {
            authenticator => sub {
                my ($user, $pass) = @_;
                return $user eq 'user2' && $pass eq 'pass2';
            }
        },
    ]);

Plack::Middleware::ErrorDocument

    $self->plugin('plack_middleware', [
        ErrorDocument => {
            500 => "$FindBin::Bin/errors/500.html"
        },
        ErrorDocument => {
            404 => "/errors/404.html",
            subrequest => 1,
        },
        Static => {
            path => qr{^/errors},
            root => $FindBin::Bin
        },
    ]);

Plack::Middleware::JSONP

    $self->plugin('plack_middleware', [
        JSONP => {callback_key => 'json.p'},
    ]);

=head1 AUTHOR

Sugama Keita, E<lt>sugama@jamadam.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Sugama Keita.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
