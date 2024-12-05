
0 value grid-width
0 value grid-height
create grid 20000 chars allot

: grid-loc ( x y -- addr )
  grid-width * + grid +
;
: grid@ ( x y -- ch )
  2dup 0 grid-height within swap
       0 grid-width within and if grid-loc c@
  else 2drop '?' then
;

: read-grid ( addr len -- )
  r/o open-file throw
  grid
  begin 2dup 1000 chars rot read-line throw while
    tuck +
    swap to grid-width
  repeat drop swap
  close-file throw

  grid - grid-width / to grid-height
;

create directions
 1  0 2,
 1  1 2,
 0  1 2,
-1  1 2,
-1  0 2,
-1 -1 2,
 0 -1 2,
 1 -1 2,

: get-dir-deltas ( d -- dx dy )
  2* cells directions + 2@
;

s" >3v1<7^9" drop constant dirnames

: .dir ( d -- )
  dirnames + c@ emit
;

0 value xmas-total

: coord+ ( x y dx dy -- x y )
  swap >r +
  swap r> +
  swap
;

: check-xmas-dir ( x y d -- f )
  get-dir-deltas 2swap ( dx dy x y )

  false >r

  2over coord+ ( dx dy nx ny )
  2dup grid@ 'M' = if
    2over coord+
    2dup grid@ 'A' = if
      2over coord+
      2dup grid@ 'S' = if
        rdrop true >r
      then
    then
  then 2drop 2drop r>
;

: check-xmas ( x y -- )
  2dup grid@ 'X' <> if
    2drop exit
  then

  8 0 do
    2dup i check-xmas-dir if
      2dup swap ." xmas found: @" . ." , " .
      ." dir " i .dir cr
      xmas-total 1+ to xmas-total
    then
  loop 2drop
;

: show-grid ( -- )
  grid-height 0 do
    grid-width 0 do
      i j grid@ emit
    loop
    cr
  loop
;

: part-1 ( -- )
  0 to xmas-total
  grid-height 0 do
    grid-width 0 do
      i j check-xmas
    loop
  loop

  ." xmas count: " xmas-total . cr
;

: check-x-mas-dir ( x y dm ds -- f )
\ break:
  2over rot get-dir-deltas coord+ grid@ 'S' = if
    get-dir-deltas coord+ grid@ 'M' = if
      true
    else false then
  else drop 2drop false then
;

: check-x-mas-dirs ( x y da db -- f )
  2dup >r >r

  2over 2swap check-x-mas-dir -rot
    2r>       check-x-mas-dir or
;

: check-x-mas ( x y -- )
  2dup grid@ 'A' <> if
    2drop exit
  then

  2dup 1 5 check-x-mas-dirs if
    2dup 3 7 check-x-mas-dirs if
      2dup swap ." x-mas found: @" . . cr
      xmas-total 1+ to xmas-total
      2drop exit
    then
  then

  2dup 3 7 check-x-mas-dirs if
    2dup 1 5 check-x-mas-dirs if
      2dup swap ." x-mas found: @" . . cr
      xmas-total 1+ to xmas-total
      2drop
    then
  then
;

: part-2 ( -- )
  0 to xmas-total
  grid-height 1- 1 do
    grid-width 1- 1 do
      i j check-x-mas
    loop
  loop

  ." x-mas count: " xmas-total . cr
;

s" day04.input" read-grid part-1 part-2 bye
