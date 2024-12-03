: accept-str ( addr1 addr2 len -- addr+len flag )
  tuck 2over str= if
    + true
  else
    + false
  then
;

3 constant number-len
: accept-number ( addr -- addr value true | addr false )
  number-len 0. 2swap >number
  number-len = if
    -rot 2drop false
  else
    -rot d>s true
  then
;

: accept-ch ( addr ch -- addr+1 flag )
  over c@ = if
    1+ true
  else
    1+ false
  then
;

: check-match ( addr -- value|0 )
  s" mul(" accept-str if
    accept-number if
      >r ',' accept-ch if
        accept-number if
          >r ')' accept-ch if
            drop r> r> * exit
          then
        then rdrop
      then rdrop
    then
  then drop false
;

create buf 10000 chars allot
variable total

: day-03 ( addr len -- )
  0 total !

  r/o open-file throw
  begin dup buf 10000 chars rot read-line throw while
    0 ?do
      buf i + check-match ?dup if
        total +!
      then
    loop
  repeat drop
  close-file throw

  ." instruction total: " total @ . cr
;

s" day03.input" day-03 bye
