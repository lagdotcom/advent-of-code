0 value basement

create buf 10000 chars allot

: day-1 ( -- )
  buf 10000 chars
  s" day01.input" r/o open-file throw
  dup >r
  read-file throw
  r> close-file throw
  buf swap

  0 to basement
  0 swap

  0 do
    over c@ ( addr count ch )
    [char] ( = if 1+ else 1- then
    dup -1 = basement 0= and if
      i 1+ to basement
    then

    swap 1+ swap
  loop nip

  ." floor " . cr
  ." entered basement at index " basement . cr
;

day-1 bye
