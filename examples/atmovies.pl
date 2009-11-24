#!/usr/bin/env perl5.10

use strict;
use warnings;
use WWW::AtMovies;
use IMDB::FIlm;
use utf8;

# prevent "Wide character in print at..."
binmode(STDIN,  ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

my $foo = WWW::AtMovies->new( crit => '男女生了沒' );

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
