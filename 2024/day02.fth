create buf 100 chars allot

: maybe-skip ( addr len -- addr len )
  dup if
    1- swap 1+ swap
  then
;

: get-next-number ( addr len -- addr len value )
  0. 2swap >number
  maybe-skip
  2swap drop
;

: is-report-safe ( addr len -- flag )
  get-next-number

  \ direction = 0
  0 >r >r

  \ for each number pair:
  begin dup while
    get-next-number

  \   if !difference or |difference| > 3: return false
    dup r> -
    dup 0= over abs 3 > or if
      2drop 2drop rdrop
      false exit
    then
  \   if direction and sign(difference) != direction: return false
    sgn r> ?dup if
      over <> if
        2drop 2drop
        false exit
      then
    then
  \   direction = sign(difference)
    >r >r
  repeat

  2drop 2rdrop true
;

: day-02 ( addr len -- )
  0 >r
  r/o open-file throw

  begin dup buf 100 chars rot read-line throw while
    buf swap is-report-safe if
      r> 1+ >r
    then
  repeat drop

  close-file throw

  ." safe reports: " r> . cr
;

s" day02.input" day-02 bye
