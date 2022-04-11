         ;ant.hits 1
         ;antal spr. 1
         ;att. ? 1
         ;addx 4
         ;y
         ;multc 1
         ;left+rigthmove
         ;att.mv le+ri
       *= $3600
otab
       .word o0
       .word o1
       .word o2
       .word o3
       .word o4
       .word o5
       .word o6
       .word o7
       .word o8
       .word o9
       .word o10
       .word o11
       .word o12
       .word o13
       .word o14
       .word o15
       .word o16
       .word o17
       .word o18
       .word o19
       .word o20
       .word o21
       .word o22
       .word o23
       .word o24
       .word o25
       .word o26
       .word o27
       .word o28
       .word o29
       .word o30
       .word o31
       .word o32
       .word o33
       .word o34
       .word o35
       .word o36
       .word o37
       .word o38

     ;0=explotion
o0
       .byte %00000000
       .byte 1
       .byte %00000000

       .byte 0,0,8,8
       .byte 4,$f8,0,$f8
       .byte %00000000

       .byte 48,51,4,7
       .byte 48,51,4,8
       .byte 48,51,4,15

       .byte 48,51,4,7
       .byte 48,51,4,8
       .byte 48,51,4,15
;1 - orm
o1
       .byte 0
       .byte 1
       .byte 1

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 124,127,3,7
       .byte 0,0,0,0
       .byte 0,0,0,0

       .byte 127,130,3,7
       .byte 0,0,0,0
       .byte 0,0,0,0
;2 - rotte
o2
       .byte 0
       .byte 1
       .byte 1
       .byte 0,0,0,0
       .byte 8,0,0,0
       .byte %00000000

       .byte 199,200,5,11
       .byte 0,0,0,0
       .byte 0,0,0,0

       .byte 253,255,5,11
       .byte 0,0,0,0
       .byte 0,0,0,0
;3 - slange
o3
       .byte 0
       .byte 2
       .byte 4

       .byte 0,0,0,0
       .byte 2,2,0,0

       .byte %00100000

       .byte 205,206,9,0
       .byte 207,208,9,5
       .byte 0,0,0,0

       .byte 201,202,9,0
       .byte 203,204,9,5
       .byte 0,0,0,0
  ;4 - k0llemand
o4
       .byte 1
       .byte 3
       .byte 5
       .byte 2,0,22,0
       .byte 242,2,248,0
       .byte %01110000

       .byte 222,222,9,10
       .byte 213,216,5,9
       .byte 219,219,9,9

       .byte 221,221,9,10
       .byte 209,212,5,9
       .byte 217,217,9,9

       .byte 222,222,9,10
       .byte 213,213,5,9
       .byte 219,220,25,9

       .byte 221,221,9,10
       .byte 209,209,5,9
       .byte 217,218,25,9

 ;5 -  troldmand
o5
       .byte 0
       .byte 1
       .byte 5
       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 159,160,5,10
       .byte 0,0,0,0
       .byte 0,0,0,0

       .byte 157,158,5,10
       .byte 0,0,0,0
       .byte 0,0,0,0
;6 - fugl
o6
       .byte 0
       .byte 1
       .byte 1

       .byte 0,0,0,0
       .byte 2,0,0,0

       .byte %00010000

       .byte 167,170,5,7
       .byte 0,0,0,0
       .byte 0,0,0,0

       .byte 163,166,5,7
       .byte 0,0,0,0
       .byte 0,0,0,0

;7 - bi
o7
       .byte 0
       .byte 1
       .byte 1

       .byte 0,0,0,0
       .byte 2,0,0,0

       .byte %00010000

       .byte 183,186,5,7
       .byte 0,0,0,0
       .byte 0,0,0,0

       .byte 179,182,5,7
       .byte 0,0,0,0
       .byte 0,0,0,0
  ;8 - havfrue
o8
       .byte 0
       .byte 2
       .byte $ff

       .byte 0,0,0,0
       .byte 21,0,0,0

       .byte %00110000

       .byte 189,190,5,11
       .byte 193,194,6,10
       .byte 0,0,0,0

       .byte 187,188,5,11
       .byte 191,192,6,10
       .byte 0,0,0,0
;9 b0ddel
o9
       .byte 1
       .byte 3
       .byte 5

       .byte 0,0,20,0
       .byte 2,237,237,0

       .byte %01110000

       .byte 227,230,6,11
       .byte 233,234,8,10
       .byte 238,239,8,9

       .byte 223,226,6,11
       .byte 231,232,8,10
       .byte 235,236,8,9

       .byte 227,227,6,11
       .byte 233,234,25,10
       .byte 239,240,25,9

       .byte 223,223,6,11
       .byte 231,232,25,10
       .byte 236,237,25,9
   ;10 - ridder (m)
o10
       .byte 1
       .byte 3
       .byte 3

       .byte 0,0,16,0
       .byte 2,237,237,0

       .byte %01110000

       .byte 243,244,20,2
       .byte 247,248,20,2
       .byte 195,197,20,11

       .byte 241,242,20,2
       .byte 245,246,20,2
       .byte 249,250,20,11

       .byte 243,243,20,2
       .byte 247,247,25,2
       .byte 195,198,12,11

       .byte 241,241,20,2
       .byte 245,245,25,2
       .byte 249,252,12,11
 ;11 - ridder (sv)
o11
       .byte 1
       .byte 3
       .byte 0

       .byte 0,0,24,0
       .byte 2,$ff-18,$ff-18,0
       .byte %01110000

       .byte 58,60,5,11
       .byte 61,61,5,11
       .byte 62,62,5,11

       .byte 52,54,5,11
       .byte 55,55,5,11
       .byte 56,56,5,11

       .byte 60,60,50,11
       .byte 61,61,25,11
       .byte 62,63,25,11

       .byte 54,54,50,11
       .byte 55,55,25,11
       .byte 56,57,25,11
     ;12 - faelde
o12
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 138,142,$05,7

     ;13 - pael
o13
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 143,145,$05,7

     ;14 - baeger 1.
o14
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 135,135,$ff,7

     ;15 - diamant, gr0n
o15
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 122,122,$ff,5

     ;16 - diamant, r0d
o16
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 122,122,$ff,2

     ;17 - diamant, blaa
o17
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 122,122,$ff,6
     ;18 - cirkel(1), r0d
o18
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 123,123,$ff,2
     ;19 - cirkel(1), blaa
o19
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 123,123,$ff,6

     ;20 - cirkel(1), gr0n
o20
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 123,123,$ff,5

     ;21 - ring , r0d
o21
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 132,132,$ff,2

     ;22 - ring , blaa
o22
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 132,132,$ff,6
     ;23 - ring , gr0n
o23
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 132,132,$ff,5
     ;24 - n0gle
o24
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 133,133,$ff,7
     ;25 - hjerte, gr0n
o25
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 134,134,$ff,5
     ;26 - hjerte, blaa
o26
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 134,134,$ff,6

     ;27 - hjerte, r0d
o27
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 134,134,$ff,2
     ;28 - krone (1)
o28
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 136,136,$ff,7
     ;29 - horn, gr0n
o29
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 137,137,$ff,5
     ;30 - horn, blaa
o30
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 137,137,$ff,6
     ;31 - horn, r0d
o31
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 137,137,$ff,2
     ;32 - baeger2
o32
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 176,176,$ff,11
     ;33 - skaal
o33
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 178,178,$ff,7
     ;34 - firkant m. streger
o34
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 171,171,$ff,13
     ;35 - krone 2
o35
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 175,175,$ff,7
     ;36 - krone 3
o36
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 177,177,$ff,2

     ;37 - 'domino'
o37
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 173,173,$ff,2
     ;38 - cirkel 2
o38
       .byte 0
       .byte 1
       .byte 0

       .byte 0,0,0,0
       .byte 2,0,0,0
       .byte %00010000

       .byte 172,172,$ff,2
