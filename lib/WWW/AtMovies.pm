package WWW::AtMovies;

use warnings;
use strict;
use Moose;
use WWW::Mechanize;
use HTML::TokeParser::Simple;
#use Smart::Comments;

has 'title'         => ( is => 'rw', isa => 'Str' );
has 'chinese_title' => ( is => 'rw', isa => 'Str' );
has 'crit'          => ( is => 'rw', isa => 'Str' );
has 'imdb_code'     => ( is => 'rw', isa => 'Num' );
has 'status'        => ( is => 'rw', isa => 'Num' );

=head1 NAME

WWW::AtMovies - The great new WWW::AtMovies!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    use WWW::AtMovies;

    my $foo = WWW::AtMovies->new( crit => 'Troy' );
    if ($foo->status) {
	print $foo->title, "\n";
	print $foo->chinese_title, "\n";
	print $foo->imdb_code, "\n";
    }

=head1 FUNCTIONS

=head2 new 

=cut

sub new {
    my ($class, %args) = @_;
    my $self = bless \%args, $class;
    $self->_init;
    return $self;
}

sub _init {
    my $self = shift;
    my $search_term = $self->crit;
    my $search_url 
	= 'http://www.google.com.tw/search?hl=zh-TW&q=' 
	    . $search_term 
	    . '+site%3Awww.atmovies.com.tw';
    ### $search_url
    my $mech = WWW::Mechanize->new;
    $mech->get($search_url);

    ### search result
    my $result_link = $mech->find_link( url_regex => qr/film_id/ );
    if (!$result_link) {
	$self->status(0);
	return;
    }
    $mech->get($result_link->url_abs);

    ### movie page
    my $imdb_url = $mech->find_link( url_regex => qr/imdb/ )->url_abs;
    my ($imdb_code) = $imdb_url =~ /(\d+)/;
    $self->imdb_code($imdb_code);

    my $parser = HTML::TokeParser::Simple->new( string => $mech->content );
    while ( my $span = $parser->get_tag('span') ) {
	my $class = $span->get_attr('class');
	next unless defined $class;
	if ($class eq 'at21b') {
	    $self->chinese_title( $parser->get_trimmed_text('/span') );
	}
	elsif ($class eq 'at12b_gray') {
	    $self->title( $parser->get_trimmed_text('/span') );
	}
    }

    $self->status(1);
    return;
}

=head1 AUTHOR

Alec Chen, C<< <alec at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-atmovies at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-AtMovies>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::AtMovies


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-AtMovies>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-AtMovies>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-AtMovies>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-AtMovies/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Alec Chen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of WWW::AtMovies
