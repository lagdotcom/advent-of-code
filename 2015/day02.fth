: skip-char ( addr len -- addr+1 len-1 )
  1- swap 1+ swap
;

: get-side ( addr len -- n addr len )
  2>r 0. 2r>
  >number
  2>r d>s 2r>
;

: get-sides ( addr len -- l w h )
  get-side skip-char
  get-side skip-char
  get-side 2drop
;

: get-area ( l w h -- area )
  \ area = 2*l*w + 2*w*h + 2*h*l + smallest
      over over * >r            ( l w h | wh )
  rot swap over * >r            ( w l   | wh hl )
                *               ( lw    | wh hl )

  r> over over r@               ( lw hl lw hl wh | wh )

  min min                       ( lw hl smallest | wh )
  -rot r> 2* swap 2* +          ( smallest lw 2wh+2hl )
  swap 2* + +
;

: get-area-easy-to-read-version { l w h -- area }
  l w *
  w h *
  h l *
  min min

  l w 2 * *
  w h 2 * *
  h l 2 * *
  + + +
;

create line-buffer 10 chars allot

: day-02 ( addr len -- )
  0 >r
  r/o open-file throw
  begin
    dup                         ( file file )
    line-buffer 10 chars rot    ( file addr len file )
    read-line throw             ( file len flag )
  while
    line-buffer swap get-sides  ( file l w h )
    get-area r> + >r            ( file )
  repeat
  drop close-file throw

  ." total is " r> . ." square feet" cr
;

s" day02.input" day-02 bye
