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

0 value total
0 value highest

: save? ( -- )
    total highest > if
        total to highest
    then ;

: elves ( -- )
    begin grab while
        dup 0= if   save?
                    ( 0 ) to total
               else total + to total then
    repeat save? ;

: do-the-thing ( -- )
    open elves close highest . ;

do-the-thing bye
