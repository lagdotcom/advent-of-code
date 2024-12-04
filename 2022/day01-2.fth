\ ----------------------------------------------- IO Code
0 value fp
variable grab-buffer 4 cells allot

: open ( -- )
    s" day01.input" r/o open-file throw to fp ;

: close ( -- )
    fp close-file throw 0 to fp ;

: grab ( -- n f )
    grab-buffer 10 fp read-line throw
    if ( not eof )
        grab-buffer swap s>number?
        2drop -1
    then ;

\ ----------------------------------------------- The Algorithm
3 constant highest-count
variable highest-three highest-count cells allot
0 value total

: report ( -- )
    0 highest-count 0 do
        i cells highest-three + @ dup
        ." elf " i . ." has " . cr
        +
    loop
    ." total = " . cr ;

: save? ( -- )
    total highest-count 0 do
        i cells highest-three + dup @ rot
        ( addr addr-score current-score )
        2dup < if   rot !
               else nip nip then
    loop drop ;

: elves ( -- )
    begin grab while
        dup 0= if   save?
                    ( 0 ) to total
               else total + to total then
    repeat save? ;

: do-the-thing ( -- )
    open elves close report ;

do-the-thing bye
