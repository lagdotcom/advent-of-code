require ../list.fth

create buf 100 chars allot
2000 list.new la
2000 list.new lb

: skip-char ( addr len -- addr+1 len-1 )
  1- swap 1+ swap
;

: read-both-lists ( addr len -- )
  r/o open-file throw

  begin dup buf 100 chars rot read-line throw while
    buf swap
    0. 2swap >number
    2swap d>s la list.append
    skip-char skip-char skip-char
    0. 2swap >number
    2drop d>s lb list.append
  repeat drop

  close-file throw
;

: sort-list { list -- }
  list list.length 0 ?do
    list list.length i 1+ ?do
      list i list.fetch
      list j list.fetch 2dup < if
        list i list.set
        list j list.set
      else 2drop then
    loop
  loop
;

: total-list-differences ( -- total-difference )
  0 la list.length lb list.length min 0 ?do
    la i list.fetch lb i list.fetch - abs +
  loop
;

: part-1 ( -- )
  la sort-list
  lb sort-list
  ." total distance: " total-list-differences . cr
;

: calc-list-similarity ( -- similarity )
  0 la list.length 0 ?do
    la i list.fetch 0           ( total item count )
    lb list.length 0 ?do
      over lb i list.fetch = if 1+ then
    loop
    * +
  loop
;

: part-2 ( -- )
  ." similarity score: " calc-list-similarity . cr
;

s" day01.input" read-both-lists part-1 part-2 bye
