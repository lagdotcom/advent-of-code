: list.new ( size "name" -- )
  create
  here >r
  cells allot
  0 r> !
;

: list.length ( list -- len )
  @
;

: list.at ( list n -- addr )
  1+ cells +
;

: list.fetch ( list n -- item )
  list.at @
;

: list.set ( item list n -- )
  list.at !
;

: list.append ( item list -- )
  tuck dup @ list.set
  1 swap +!
;
