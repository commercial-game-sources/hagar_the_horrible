         *= $1400

startup
         jsr clearpic
         sei
         lda #$7f
         sta $dc0d
         lda #$81
         sta $d01a
         lda #$3b
         sta $d011
         lda #0
         sta $d012
         asl $d019
         lda #<irq1
         sta $0314
         lda #>irq1
         sta $0315
         lda #25
         sta 53272
         lda #88
         sta 53270
         lda #$00
         sta $d020
         sta $d021
         jsr putscr
         lda #$03
         sta 53248+23
         lda #%00111100
         sta 53248+29
         cli
wait
         jmp wait
irq1     asl $d019
         lda #250
         sta $d012
         lda #23
         sta $d011

         lda fstop
         bne makenormal
         lda stop
         bne sprmuc
         jsr do
         jsr do
         jsr do
         jsr do
irqexit
         lda #$3b
         sta $d011
         pla
         tay
         pla
         tax
         pla
         rti
makenormal
         lda #$1b
         sta $d011
         lda #23
         sta $d018
         lda #$0e
         sta 646
         lda #200
         sta 53270
         jsr $e544
         lda #$31
         sta $0314
         lda #$ea
         sta $0315
         lda #$60
         sta wait
         lda #$f0
         sta $d01a
         lda #255
         sta $dc0d
         lda #$06
         sta $d021
         lda #$0e
         sta $d020
         lda #$00
         sta 53269
         jmp irqexit
sprmuc
         lda #23
         sta $d011
         lda #$00
         sta 53248+27
         jsr flytdatas
         jsr animation
         jsr mspr
         jsr putcol
         jsr checkkey
         lda #<irq2
         sta $0314
         lda #>irq2
         sta $0315
         lda #$00
         sta $d012
         jmp irqexit
irq2
         asl $d019
         lda #$ff
         sta $d004
         sta $d006
         sta $d008
         sta $d00a
         lda #%11111100
         sta 53248+16
         lda #250
         sta $d012
         lda #<irq1
         sta $0314
         lda #>irq1
         sta $0315
         jmp irqexit

putscr
         lda #$00
         sta $34
         sta $36
         sta $30
         sta $32

         lda #$04
         sta $35
         lda #$d8
         sta $37

         lda #$18
         sta $31
         lda #$1c
         sta $33
         ldy #$00
l1
         lda ($30),y
         sta ($34),y
         lda ($32),y
         sta ($36),y
         dey
         bne l1
         inc $35
         inc $31
         inc $33
         inc $37
         lda $35
         cmp #$08
         bne l1
         rts
putline
         ldx #40
         ldy #$00
g1
         lda ($34),y
         sta ($36),y
         lda $34
         clc
         adc #$08
         bcc nix1
         inc $35
         inc $37
nix1
         sta $34
         sta $36
         dex
         bne g1
ex1
         rts
d1
         .byte 0
stop
         .byte $00
do
         lda stop
         bne ex1
         ldx d1
         lda $1300,x
         tax
         lda $1200,x
         sta $36
         sta $34
         lda $1100,x
         clc
         adc #$20
         sta $37
         clc
         adc #$20
         sta $35
         lda slet
         bne slt
         jsr putline
         jmp v1
slt
         jsr clearline
v1
         inc d1
         lda d1
         cmp #208
         bne ex2
         lda #0
         sta d1
         lda slet
         bne finex
         eor #$ff
         sta slet
         inc stop
ex2
         rts
finex
         inc fstop
         rts
slet     .byte $00
clearline
         ldx #40
         ldy #$00
g2
         lda #$00
         sta ($36),y
         lda $36
         clc
         adc #$08
         bcc nix2
         inc $37
nix2
         sta $36
         dex
         bne g2
         rts
clearpic
         lda #$00
         sta $34
         lda #$20
         sta $35
         ldy #$00
         lda #$00
p1
         lda #$00
         sta ($34),y
         dey
         bne p1
         inc $35
         lda $35
         cmp #$40
         bne p1
         rts

ex3
         rts
checkkey
         lda stop
         beq ex3
         lda $dc00
         cmp #127
         beq ex3
         dec stop
         rts
fstop
         .byte $00

flytdatas
         ldx #$00
fltloop1
         lda sprpos,x
         sta $d000,x
         inx
         cpx #$0c
         bne fltloop1


         ldx #$00
fltloop2
         lda sprcols,x
         sta $d027,x
         lda sprreg,x
         sta 2040,x
         inx
         cpx #$06
         bne fltloop2

         lda mulcol1
         sta 53248+37
         lda mulcol2
         sta 53248+38
         lda xover
         sta $d010
         lda multicol
         sta 53248+28
         lda on
         sta 53248+21
         rts

animation

         ldx #$00
         stx animteller
         ldy #$00
         jmp animstart
animloop1
         cpx #$07
         beq animexit
         tya
         adc #$05
         tay
         inx
animstart
         lda anim0+4,y
         cmp #$00
         beq animloop1
         lda animmell,x
         beq animv1

         dec animmell,x
         jmp animloop1
animv1
         lda anim0+2,y
         sta animmell,x
         lda sprreg,x
         cmp anim0+1,y
         beq animv2

         inc sprreg,x
         jmp animfarv

animv2
         lda anim0,y
         sta sprreg,x

animfarv
         lda anim0+3,y
         cmp #$10
         bcs animfade
         sta sprcols,x

         jmp animloop1

animfade
         lda fadetel,x
         cmp #$05
         bne animv3

         lda #$00
         sta fadetel,x
         jmp fadev2
animv3
         inc fadetel,x

fadev2
         stx animxgem

         lda anim0+3,y
         clc
         sbc #$10
         tax
         lda fadetab,x
fadev1
         ldx animxgem
         clc
         adc fadetel,x
         tax
         lda fade1,x
         ldx animxgem
         sta sprcols,x

         jmp animloop1

animexit
         rts

animxgem .byte 0
fadetab  .byte 0,6,12,18,24,30
fade1
         .byte 14,7,13,1,5,1

         .byte 6,8,5,2,9,3

sprpos
         .byte 216,138
         .byte 216,138
         .byte 130,5
         .byte 178,5
         .byte 130,6
         .byte 178,6
         .byte 0,0
         .byte 0,0
sprcols
         .byte 0
         .byte 0
         .byte 11
         .byte 11
         .byte 0
         .byte 0
         .byte 0
         .byte 0
sprreg
         .byte 48
         .byte 53
         .byte 38
         .byte 45
         .byte 38
         .byte 45
         .byte $00
         .byte $00

xover
         .byte %00000000
multicol
         .byte %00000000
mulcol1
         .byte 10
mulcol2
         .byte 0
screencol
         .byte $0b
bordercol
         .byte $00
on
         .byte %00111111
anim0
         .byte 48,52,5,12,1
anim1
         .byte 53,57,5,11,1
anim2
         .byte 32,38,250,$07,1
anim3
         .byte 39,45,250,$07,1
anim4
         .byte 32,38,250,$0b,1
anim5
         .byte 39,45,250,$0b,1
anim6
         .byte 0,0,0,0,0
anim7
         .byte 0,0,0,0,0
animmell
         .byte 1,1,1,1,1,1,1,1
animteller .byte $00
fadetel

         .byte 0,0,0,0,0,0,0,0
realfade
         .byte $06,14,3,13,7,8,9
t        .byte $00
f        .byte $03
putcol
chn      nop
         dec f
         bne ex4
         lda #$03
         sta f
         ldx t
         lda realfade,x
         sta sprcols+2
         sta sprcols+3
         inx
         cpx #$07
         bne ex5
         ldx #$00
ex5
         stx t
ex4
         rts
mspr
         lda animmell+2
         cmp #25
         bcc mdw
         cmp #226
         bcc ex6
mdw
         lda #$ea
         sta chn
         rts
ex6
         lda #$07
         sta sprcols+2
         sta sprcols+3
         lda #$60
         sta chn
         rts
