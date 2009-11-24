#!/usr/bin/env perl5.10

use strict;
use warnings;
use WWW::AtMovies;
use IMDB::FIlm;

# prevent "Wide character in print at..."
binmode(STDOUT, ':encoding(utf8)');

my $foo = WWW::AtMovies->new( crit => 'the ugly truth' );

if ($foo->status) {
    print $foo->title, "\n";
    print $foo->chinese_title, "\n";
    print $foo->imdb_code, "\n";
}

my $imdb = IMDB::Film->new( crit => $foo->imdb_code );
if ($imdb->status) {
    print $imdb->title,  "\n";
    print $imdb->year,   "\n";
    my $rating = $imdb->rating;
    print $rating, "\n";
}
