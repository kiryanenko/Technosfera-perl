use strict;
use warnings;

use Test::More;

sub test_bin {
    my ($name, $params, $input, $output) = @_;

    $input =~ s/'/'"'"'/;
    is(`echo -n '$input' | bin/music_library.pl $params`, $output, $name);
}

test_bin
'basic', '',
<<INPUT
./Band/123 - Album/track.mp3
./B/3210 - AlbumAlbum/t.format
INPUT
,
<<OUTPUT
/-------------------------------------------\\
| Band |  123 |      Album | track |    mp3 |
|------+------+------------+-------+--------|
|    B | 3210 | AlbumAlbum |     t | format |
\\-------------------------------------------/
OUTPUT
;

test_bin
'empty result', '--band UNKNOWN',
<<INPUT
./B/3210 - AlbumAlbum/x.format
INPUT
,
<<OUTPUT
OUTPUT
;

test_bin
'filter', '--band B',
<<INPUT
./Band/123 - Album/track.mp3
./B/3210 - AlbumAlbum/t.format
./B/3210 - AlbumAlbum/x.format
INPUT
,
<<OUTPUT
/------------------------------------\\
| B | 3210 | AlbumAlbum | t | format |
|---+------+------------+---+--------|
| B | 3210 | AlbumAlbum | x | format |
\\------------------------------------/
OUTPUT
;

test_bin
'int filter', '--year 210',
<<INPUT
./B/0210 - AlbumAlbum/t.format
./B/210 - AlbumAlbum/x.format
./B/310 - AlbumAlbum/x.format
INPUT
,
<<OUTPUT
/------------------------------------\\
| B | 0210 | AlbumAlbum | t | format |
|---+------+------------+---+--------l
| B |  210 | AlbumAlbum | x | format |
\\------------------------------------/
OUTPUT
;

test_bin
'sort', '--sort format',
<<INPUT
./B/210 - AlbumAlbum/m.mp3
./B/210 - AlbumAlbum/o.ogg
./B/210 - AlbumAlbum/a.abc
INPUT
,
<<OUTPUT
/--------------------------------\\
| B | 210 | AlbumAlbum | a | abc |
|---+-----+------------+---+-----|
| B | 210 | AlbumAlbum | m | mp3 |
|---+-----+------------+---+-----|
| B | 210 | AlbumAlbum | o | ogg |
\\--------------------------------/
OUTPUT
;

test_bin
'int sort', '--sort year',
<<INPUT
./B/10 - AlbumAlbum/m.mp3
./B/100 - AlbumAlbum/o.ogg
./B/20 - AlbumAlbum/a.abc
INPUT
,
<<OUTPUT
/--------------------------------\\
| B |  10 | AlbumAlbum | m | mp3 |
|---+-----+------------+---+-----|
| B |  20 | AlbumAlbum | a | abc |
|---+-----+------------+---+-----|
| B | 100 | AlbumAlbum | o | ogg |
\\--------------------------------/
OUTPUT
;

done_testing();