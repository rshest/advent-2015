USING: io io.files io.encodings.ascii kernel command-line formatting
  sets hash-sets assocs sequences sequences.extras math.vectors namespaces ;
IN: dec03-factor

CONSTANT: INPUT-FILE "vocab:dec03-factor/input.txt"

: offset ( char -- offset ) H{
  { CHAR: > {  1  0 } } { CHAR: v {  0  1 } }
  { CHAR: < { -1  0 } } { CHAR: ^ {  0 -1 } } } at ;

: parse-offsets ( path -- offsets ) [ offset ] { } map-as ;

: positions ( offsets -- positions ) { 0 0 } [ v+ ]  accumulate swap suffix ;

: positions2 ( offsets -- positions1 positions2 )
  [ odd-indices positions ] [ even-indices positions ] bi ;

: num-unique ( seq -- result ) >hash-set members length ;

: main ( -- )
  command-line get dup empty? [ drop INPUT-FILE ] [ first ] if
  ascii file-lines first parse-offsets
  dup positions num-unique "Unique positions: %d\n" printf
  positions2 append num-unique "Unique positions 2: %d\n" printf ;

MAIN: main
