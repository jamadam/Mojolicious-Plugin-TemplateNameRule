package Mojolicious::Plugin::TemplateNameRule;
use strict;
use warnings;
use Mojo::Base 'Mojolicious::Plugin';
our $VERSION = '0.01';
    
    __PACKAGE__->attr('pattern', '%template.%format.%handler');
    
    ### ---
    ### register
    ### ---
    sub register {
        my ($self, $app, $options) = @_;
        
        no warnings 'redefine';
        
        $self->pattern($options->{pattern});
        
        *Mojolicious::Renderer::template_name = sub {
            my ($r, $options) = @_;
            
            if (! $r->{templates} && ! $r->{data}) {
                my $idxs = {};
                my $regex = do {
                    my $tmp = $self->pattern;
                    my $idx = 0;
                    while ($tmp =~ qr{%(\w+)}) {
                        my $name = $1;
                        $idxs->{$name} = $idx;
                        $idx++;
                        $tmp =~ s{%$name}{(\\w+)};
                    }
                    $tmp;
                };
                if ($idxs->{handler}) {
                    for (map { sort @{Mojo::Home->new($_)->list_files} }
                                                                @{$r->paths}) {
                        if (my @capture = ($_ =~ qr{$regex})) {
                            my $short = $self->_template_name(
                                $capture[$idxs->{template}],
                                $capture[$idxs->{format}],
                            );
                            $r->{templates}->{$short} ||=
                                                    $capture[$idxs->{handler}];
                        }
                    }
                    for (map { sort keys %{Mojo::Command->get_all_data($_)} }
                                                        @{$r->classes}) {
                        if (my @capture = ($_ =~ qr{$regex})) {
                            my $short = $self->_template_name(
                                $capture[$idxs->{template}],
                                $capture[$idxs->{format}],
                            );
                            $r->{data}->{$short} ||= $capture[$idxs->{handler}];
                        }
                    }
                }
            }
            
            $self->_template_name(
                $options->{template}, $options->{format}, $options->{handler});
        };
        
        sub _template_name {
            my ($self, $template, $format, $handler) = @_;
            my $p = $self->pattern;
            $p =~ s{%template}{$template||''}e;
            $p =~ s{%format}{$format||''}e;
            $p =~ s{%handler}{$handler||''}e;
            return $p;
        }
    }

1;

__END__

=head1 NAME

Mojolicious::Plugin::TemplateNameRule - Customize template naming rule

=head1 SYNOPSIS

    # index.ep.html style
    plugin TemplateNameRule => {
        pattern => '%template.%handler.%format'
    };
    
    # no renderer type like index.html
    plugin TemplateNameRule => {
        pattern => '%template.%format'
    };

=head1 DESCRIPTION

This plugin allows you to customize the naming rule for templates.
This plugin does very evil hack inside of it and might not work in any cases.

=head2 OPTIONS

=head1 METHODS

=head2 register

$plugin->register;

Register plugin hooks in L<Mojolicious> application.

=head1 AUTHOR

Sugama Keita, E<lt>sugama@jamadam.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Sugama Keita.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
