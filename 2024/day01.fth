create buf 100 chars allot
create la 2000 cells allot 0 la !
create lb 2000 cells allot 0 lb !

: .length ( list -- len )
  @
;

: .at ( list n -- addr )
  1+ cells +
;

: .fetch ( list n -- item )
  .at @
;

: .set ( item list n -- )
  .at !
;

: .append ( item list -- )
  tuck dup @ .set
  1 swap +!
;

: skip-char ( addr len -- addr+1 len-1 )
  1- swap 1+ swap
;

: read-both-lists ( addr len -- )
  r/o open-file throw

  begin dup buf 100 chars rot read-line throw while
    buf swap
    0. 2swap >number
    2swap drop la .append
    skip-char skip-char skip-char
    0. 2swap >number
    2drop drop lb .append
  repeat drop

  close-file throw
;

: sort-list { list -- }
  list .length 0 ?do
    list .length i 1+ ?do
      list i .fetch
      list j .fetch 2dup < if
        list i .set
        list j .set
      else 2drop then
    loop
  loop
;

: total-list-differences ( -- total-difference )
  0 la .length lb .length min 0 ?do
    la i .fetch lb i .fetch - abs +
  loop
;

: part-1 ( -- )
  la sort-list
  lb sort-list
  ." total distance: " total-list-differences . cr
;

: calc-list-similarity ( -- similarity )
  0 la .length 0 ?do
    la i .fetch 0           ( total item count )
    lb .length 0 ?do
      over lb i .fetch = if 1+ then
    loop
    * +
  loop
;

: part-2 ( -- )
  ." similarity score: " calc-list-similarity . cr
;

s" day01.input" read-both-lists part-1 part-2 bye
