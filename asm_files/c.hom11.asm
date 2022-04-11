

         *= $1000
         jmp startup
succes   .byte $00
startup
         nop
         nop
         nop
         jsr setscreen
         lda #$00
         sta stop
         sei
         lda #$7f
         sta $dc0d
         lda #$81
         sta $d01a
         lda #27
         sta $d011
         lda #50
         sta $d012
         asl $d019
         lda succes
         beq do1
         lda #<irq2
         sta $0314
         lda #>irq2
         sta $0315
         cli
         jsr set2
         jmp wait
do1
         lda #<irq1
         sta $0314
         lda #>irq1
         sta $0315
         cli
wait
         lda stop
         beq wait
         rts
stop     .byte $00
vv       .byte $00
irq1
         asl $d019
         jsr animation
         lda sprreg
         clc
         adc #$02
         sta sprreg+1
         jsr fdat
         jsr inhag
         dec vv
         bne nex
         lda #5
         sta vv
         lda sprpos+15
         eor #$01
         sta sprpos+15
nex
         jmp irqslut
irq2
         asl $d019
         jsr animation
         lda sprreg
         clc
         adc #$02
         sta sprreg+1
         jsr fdat
         dec vv
         bne nex2
         lda #5
         sta vv
         lda sprpos+15
         eor #$01
         sta sprpos+15
nex2
         jsr movem
irqslut
         lda $dc00
         and #%00010000
         beq stopit
         lda 197
         cmp #60
         beq stopit
         nop
         nop
         nop
         jmp $ea31
stopit
         inc stop
         lda #31
         sta $0314
         lda #$ea
         sta $0315
         lda #0
         sta $d01a
         lda #$01
         sta $dc0d
         lda #$50
         sta $cc40
         jmp $ea31
set2
         lda #70
         sta nedtell
         rts
movem
         lda nedtell
         beq clan
         jsr inhag
         jsr movhel
         rts
clan
         lda #$00
         sta anim2+4
         lda #129
         sta sprreg+2
         rts
setscreen
         ldx #$00
setloop1
         lda $4000,x
         sta $0400,x
         lda $4000+250,x
         sta $0400+250,x
         lda $4000+500,x
         sta $0400+500,x
         lda $4000+750,x
         sta $0400+750,x
         lda $4400+0,x
         sta $d800+0,x
         lda $4400+250,x
         sta $d800+250,x
         lda $4400+500,x
         sta $d800+500,x
         lda $4400+750,x
         sta $d800+750,x
         inx
         cpx #250
         bne setloop1
         ldx #$00
setloop2
         lda gempos,x
         sta sprpos,x
         inx
         cpx #$17
         bne setloop2
         ldx #$00
setloop3
         lda gemanim,x
         sta anim0,x
         inx
         cpx #20
         bne setloop3

         ldx #$00
         lda succes
         bne sl5
sl4
         lda hel1,x
         sta anim0+20,x
         inx
         cpx #20
         bne sl4
         jmp v1
         ldx #$00
sl5
         lda hel2,x
         sta anim0+20,x
         inx
         cpx #20
         bne sl5
         lda #112
         sta nt4
v1
         lda #18
         sta 53272
         lda #88
         sta 53270
         lda #$1b
         sta 53265
         lda #9
         sta 53282
         lda #$00
         sta 53283
         sta 53280
         lda #$06
         sta 53281
         lda #$00
         sta 53248+37
         ldx succes
         lda otab,x
         sta xover
         lda #$0f
         sta 53248+38
         sta on
         lda #$05
         sta vv
         jmp setspr
otab     .byte 0,%11110000
fdat
         ldx #$00
fltloop1
         lda sprpos,x
         sta $d000,x
         inx
         cpx #$10
         bne fltloop1
         ldx #$00
fltloop2
         lda sprcols,x
         sta $d027,x
         lda sprreg,x
         sta 2040,x
         inx
         cpx #$08
         bne fltloop2
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
         beq animloop1
         dec animmell,x
         bne animloop1
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
         sta sprcols,x
         jmp animloop1
animexit
         rts
animxgem .byte 0
animygem .byte 0
animagem .byte 0
animteller .byte 0

setspr
         ldx #$00
         ldy #$00
setl1
         lda anim0,y
         sta sprreg,x
         lda anim0+2,y
         sta sprcols,x
         tya
         adc #$05
         tay
         inx
         cpx #$08
         bne setl1
         rts
sprpos
         .byte 14,177
         .byte 14,177
         .byte 14,190
         .byte 0,187
         .byte 30-6,190-16
         .byte 30-6,190-16
         .byte 30,190
         .byte 30-24,183

nt4      .byte 30
nedtell  .byte 135
n2       .byte $02
ventlidt
         .byte $20
vl2      .byte $20
nt3      .byte 135
twize    .byte $02



sprcols
         .byte 0
         .byte 0
         .byte 0
         .byte 0
         .byte 0
         .byte 0
         .byte 0
         .byte 0
sprreg
         .byte $80
         .byte $00
         .byte $00
         .byte $00
         .byte $00
         .byte $00
         .byte $00
         .byte $00
xover
         .byte %11110000
multicol
         .byte %11101110
mulcol1
         .byte 0
mulcol2
         .byte 15
on
         .byte %00001111
anim0
         .byte 138,139,4,$00,1
         .byte 140,141,4,$02,0
anim2
         .byte 128,132,5,$09,1
         .byte 146,146,$ff,9,0

         .byte 151,151,$ff,0,0
         .byte 152,152,$ff,10,0
         .byte 148,148,$ff,5,0
         .byte 155,155,$ff,10,0
animmell
         .byte 1,1,1,1,1,1,1,1
inhag
         lda nedtell
         beq there
         inc sprpos
         inc sprpos+2
         inc sprpos+4
         inc sprpos+6
         lda sprpos
         beq over1
         lda sprpos+6
         beq over2
inex
         dec n2
         bne inex2
         dec nedtell
         lda #$02
         sta n2
inex2
         rts
over1
         lda #%11110111
         sta xover
         jmp inex
over2
         lda #$ff
         sta xover
         jmp inex
there
         lda succes
         beq geton
         rts
geton
         lda ventlidt
         beq skralde
         dec ventlidt
         bne normcl
         lda #147
         sta sprreg+3
         lda #133
         sta anim2
         lda #137
         sta anim2+1
         lda #142
         sta anim0
         sta sprreg+0
         lda #143
         sta anim0+1
         lda #190
         sta sprpos+7
normcl
         lda #%00000000
         sta on
         rts
skralde
         lda #$0f
         sta on
         jsr dehag
         lda vl2
         beq movhel
         dec vl2
         rts
gempos
         .byte 14,177
         .byte 14,177
         .byte 14,190
         .byte 0,187
         .byte 30-6,190-16
         .byte 30-6,190-16
         .byte 30,190
         .byte 30-24,183


         .byte 30
         .byte 135
         .byte $02

         .byte $20
         .byte $20
         .byte 135
         .byte $02
dehag
         lda nt3
         beq end
         dec nt3
back
         dec sprpos
         dec sprpos+2
         dec sprpos+4
         dec sprpos+6
         lda sprpos
         cmp #$ff
         beq under1
         lda sprpos+6
         cmp #$ff
         beq under2
         rts
end
         lda twize
         beq e3
         lda #80
         sta nt3
         dec twize
         jmp back
e3
         rts
under1
         lda xover
         eor #%00000111
         sta xover
         rts
under2
         lda xover
         eor #%00001000
         sta xover
         rts
movhel
         lda #$ff
         sta on
         lda nt4
         beq end2
         dec nt4
         dec sprpos+8
         dec sprpos+10
         dec sprpos+12
         dec sprpos+14
         lda sprpos+8
         cmp #$ff
         beq u1
         lda sprpos+12
         cmp #$ff
         beq u2
         lda sprpos+14
         cmp #$ff
         beq u3
         rts
end2
         rts
u1
         lda xover
         eor #%00110000
         sta xover
         rts
u2
         lda xover
         eor #%01000000
         sta xover
         rts
u3
         lda xover
         eor #%10000000
         sta xover
         rts
gemanim
         .byte 138,139,4,$00,1
         .byte 140,141,4,$02,0
         .byte 128,132,5,$09,1
         .byte 146,146,$ff,9,0
hel1
         .byte 151,151,$ff,0,0
         .byte 152,152,$ff,10,0
         .byte 148,148,$ff,5,0
         .byte 150,150,$ff,10,0
hel2
         .byte 153,153,$ff,0,0
         .byte 154,154,$ff,10,0
         .byte 148,148,$ff,5,0
         .byte 155,155,$ff,10,0

