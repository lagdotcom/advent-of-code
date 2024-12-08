: .nosp ( n -- )
  s>d <# #s #> type
;

: thank-you-next ( value addr -- )
  tuck @ !                  ( save the value at address )
  dup @ cell+ swap !        ( move the pointer one cell over )
;

: read-number ( c-addr len -- c-addr+n len-n value )
  0. 2swap >number 2swap d>s
;

create read-buf 1000 chars allot

: get-next-line ( file -- file c-addr len true | file 0 )
  dup read-buf 1000 chars rot read-line throw if
    read-buf swap dup if
      true
    else
      2drop 0
    then
  then
;

create rules 10000 cells allot
variable rules*       rules rules* !
variable rule-count   0 rule-count !

: save-rule ( c-addr len -- )
  read-number rules* thank-you-next
  1 /string
  read-number rules* thank-you-next

  1 rule-count +!
  2drop
;

: convert-update ( c-addr len -- addr len )
  align here 0 2>r
  begin read-number dup while
    , r> 1+ >r
    dup if
      1 /string
    then
  repeat drop 2drop 2r>
;

: rule-scan ( addr len n -- addr len i|-1 )
  over 0 do
    2 pick i cells + @ over = if
      drop i unloop exit
    then
  loop drop -1
;

: get-rule ( n -- rb ra )
  cells 2* rules + 2@
;

: breaks-rule? ( addr len n -- f )
  get-rule >r rule-scan ( addr len i|-1 | R: ra )
  dup -1 = if
    rdrop drop 2drop false exit
  then
  ( addr len i-rb | R: ra )
  r> swap >r rule-scan ( addr len i-ra|-1 | R: i-rb )
  dup -1 = if
    rdrop drop 2drop false exit
  then
  r> > nip nip
;

: update. ( addr len -- )
  ." [ "
  0 do
    dup @ . cell+
  loop drop
  ']' emit
;

: rule. ( n -- )
  get-rule .nosp '|' emit .
;

: update-correctly-ordered? ( addr len -- addr len true | 0 )
  rule-count @ 0 do
    2dup i breaks-rule? if
      2dup update. ."  failed rule " i rule. cr
      2drop false unloop exit
    then
  loop true
;

variable middle-total

: add-middle-to-total ( addr len -- )
  2dup update. ."  passed, "
  1- 2/ cells + @
  ." adding: " dup . cr
  middle-total +!
;

: day-05 ( c-addr len -- )
  r/o open-file throw

  begin get-next-line while
    save-rule
  repeat
  ." read " rule-count @ . ." rules" cr

  0 middle-total !
  begin get-next-line while
    convert-update update-correctly-ordered? if
      add-middle-to-total
    then
  repeat

  ." middle page total: " middle-total @ . cr
;

s" day05.input" day-05 bye
