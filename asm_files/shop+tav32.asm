          *= $4000

          jmp savescreen
          jmp getscreen
          jmp setup
          rts
          nop
          nop
          jmp statav
          jmp settav
          jmp setshop
          jmp tomgang
          jmp tomgang2
          ldx profit
          ldy profit+1
          lda energi
          rts
statav
          sta tav
          stx energi
          rts
zp        = $34
zp2       = zp+2
zp3       = zp+4
getscr    = $1000+3

staprofit
          lda #3
          jsr $7006
          ldx profit+1
          ldy profit
          jmp $1a00+21
settav
          lda #$9e
          jsr putwin
          jsr setbard
          jsr plotpil2
          rts
setshop
          lda #$8e
          jsr putwin
          jsr setbarm
          jsr plotpil
          rts
tomgang
          jsr flytdatas
          lda spil
          bne tern
          jsr fader
          jsr readjoy2
          rts
tern
          jsr playtern
          rts
tomgang2
          lda #50
wait2
          cmp $d012
          bne wait2
          jsr flytd2
          jsr fader
          jsr readjoy
          sei
          lda #90
wait3
          cmp $d012
          bne wait3
          jsr flytdatas
          cli
          rts
putwin
          sta zp2+1
          lda #$00
          sta zp2
          jsr getscr
          tax
          lda scrs,x
          sta zp+1
          lda #$d8
          sta zp3+1
          lda #$08+$28
          sta zp
          sta zp3
          ldx #$0d
          ldy #$00
lineloop
          lda (zp2),y
          sta (zp),y
          lda #$08
          sta (zp3),y
          iny
          cpy #$18
          bne lineloop
          lda zp2
          clc
          adc #$18
          sta zp2
          lda zp2+1
          adc #$00
          sta zp2+1
          clc
          lda zp
          adc #$28
          bcc noover
          inc zp+1
          inc zp3+1
noover
          sta zp
          sta zp3
          ldy #$00
          dex
          bne lineloop
          jsr $1a00+18
          stx profit+1
          sty profit
          lda #$02
          sta pilpos
          lda #25
          sta joyned
          jmp initcolors
tab18
          .byte %00000100
          .byte %00010100
sprr      .byte $43,$47
setup
          rts
flytdatas
          ldx #$00
fltloop1
          lda sprpos,x
          sta $d000,x
          inx
          cpx #$10
          bne fltloop1
          jsr getscr
          tax
          lda sprr,x
          sta mod1+2
          sta mod2+2
          ldx #$00
fltloop2
          lda sprcols,x
          sta $d027,x
          lda sprreg,x
mod1      sta $43f8,x
          inx
          cpx #$08
          bne fltloop2
          lda mulcol1
          sta 53248+37
          lda mulcol2
          sta 53248+38
          lda screencol
          sta 53281
          lda bordercol
          sta 53280
          lda xover
          sta $d010
          lda multicol
          sta 53248+28
          lda on
          sta 53248+21
          lda #$00
          sta 53248+27
          rts
sprpos
          .byte 100,100
          .byte 100,79
          .byte 124,100
          .byte 124,79
          .byte 0,0
          .byte 0,0
          .byte 0,0
          .byte 0,0
          .byte 0,0
sprcols
          .byte 10
          .byte 10
          .byte 10
          .byte 10
          .byte 0
          .byte 0
          .byte 0
          .byte 0
sprreg
          .byte 110
          .byte 111
          .byte 112
          .byte 113
          .byte $00
          .byte $00
          .byte $00
          .byte 109

xover
          .byte %00000000
multicol
          .byte %01111111
mulcol1
          .byte 0
mulcol2
          .byte 11
screencol
          .byte $06
bordercol
          .byte $00
on
          .byte %11111111
addreg    .byte 96
barmpos   .byte 96,120
bardpos   .byte 154,112
setbarm
          lda barmpos
          sta sprpos
          sta sprpos+2
          sta sprpos+8
          clc
          adc #24
          sta sprpos+4
          sta sprpos+6
          lda barmpos+1
          sta sprpos+1
          sta sprpos+5
          sec
          sbc #21
          sta sprpos+3
          sta sprpos+7
          clc
          adc #$02
          sta sprpos+9
          lda #10
          sta sprcols
          sta sprcols+1
          sta sprcols+2
          sta sprcols+3
          lda #$07
          sta sprcols+4
          lda #14
          clc
          adc addreg
          ldx #$00
rloop1
          sta sprreg,x
          clc
          adc #$01
          inx
          cpx #$05
          bne rloop1
          lda #%00011111
          sta on
          rts
setbard
          lda bardpos
          sta sprpos
          clc
          adc #$04
          sta sprpos+4
          sta sprpos+6
          clc
          adc #20
          sta sprpos+2
          lda bardpos+1
          sta sprpos+1
          sta sprpos+3
          sec
          sbc #21
          sta sprpos+5
          sta sprpos+7
          lda #10
          sta sprcols
          sta sprcols+1
          sta sprcols+2
          lda #$07
          sta sprcols+3
          lda #$00
          sta sprpos+9
          clc
          adc addreg
          ldx #$00
rloop2
          sta sprreg,x
          clc
          adc #$01
          inx
          cpx #$04
          bne rloop2
          lda #%11111111
          sta on
          lda #$ff
          lda #$0b
          rts
flytd2
          lda #$00
          sta 53248+37
          sta 53248+27
          lda #$03
          sta 53248+38
          lda screencol
          sta 53281
          lda bordercol
          sta 53280
          ldx #$00
fltl1
          lda sprpos2,x
          sta $d000,x
          inx
          cpx #$10
          bne fltl1
          ldx #$00
fltl2
          lda sprcols2,x
          sta $d027,x
          lda sprreg2,x
mod2      sta $43f8,x
          inx
          cpx #$08
          bne fltl2
          lda xover2
          sta $d010
          lda mul2
          sta 53248+28
          lda on2
          sta 53248+21
          rts

sprpos2
          .byte 130,68
          .byte 152,68
          .byte 178,68
          .byte 200,68
          .byte 220,68
          .byte 240,68
          .byte 0,0
          .byte 130,58
sprreg2
          .byte 115
          .byte 116
          .byte 117
          .byte 118
          .byte 119
          .byte 120
          .byte 0
          .byte 109
sprcols2
          .byte 11
          .byte 11
          .byte 11
          .byte 7
          .byte 14
          .byte 11
          .byte 0
          .byte 1
xover2    .byte $00
mul2      .byte %00111111
on2       .byte %10111111
pilpos    .byte $00
piltab
          .byte 130,58
          .byte 152,58
          .byte 178,58
          .byte 200,58
          .byte 220,58
          .byte 240,58
piltab2
          .byte 110,58
          .byte 180,100
          .byte 220,100
fadtel    .byte 0
fad2      .byte 5
joyned    .byte 10
fadetab3
          .byte 9,5,3,13,7,13,3,5
fader
          dec fad2
          bne ex1
          lda #$04
          sta fad2
          ldx fadtel
          lda fadetab3,x
          ldy tav
          beq sfad
          sta sprcols+7
          jmp fv1
sfad
          sta sprcols2+7
fv1
          cpx #7
          beq newx
          inc fadtel
ex1
          rts
gem       .byte 0
tav       .byte 0
keingeld
          cld
          rts
buy
          lda pilpos
          asl a
          tax
          lda profit+1
          cmp prizetab1+1,x
          bcc keingeld
          bne lotsamoney
          lda profit
          cmp prizetab1,x
          bcc keingeld
lotsamoney
          sei
          sed
          lda profit
          sec
          sbc prizetab1,x
          sta profit
          lda profit+1
          sbc prizetab1+1,x
          sta profit+1
          cld
          cli
          jsr staprofit
          sei
          sed
          ldx pilpos
          cpx #5
          bne nkn
          ldx #8
nkn
          lda knive,x
          clc
          adc #$01
          sta knive,x
          cld
          cli
          rts
newx
          lda #$00
          sta fadtel
          rts
readjoy
          lda joyned
          beq noex
          dec joyned
          rts
noex
          lda #10
          sta joyned
          lda $dc00
          sta gem
          and #%00010000
          beq exit
          lda gem
          and #%00000010
          beq buy
          lda gem
          and #%00000100
          beq left
          lda gem
          and #%00001000
          beq right
ex2
          rts
exit
          rts
left
          lda pilpos
          beq ex2
          dec pilpos
          jmp plotpil
right
          lda pilpos
          cmp maxpos
          beq ex2
          inc pilpos
          jmp plotpil
plotpil
          lda pilpos
          asl a
          tax
          lda piltab,x
          sta sprpos2+14
          lda piltab+1,x
          sta sprpos2+15
          jmp gprize
keingeld2
          rts
buy2
          lda pilpos
          asl a
          tax
          lda profit+1
          cmp prizetab2+1,x
          bcc keingeld2
          bne lotsamoney2
          lda profit
          cmp prizetab2,x
          bcc keingeld2
lotsamoney2
          sei
          sed
          lda profit
          sec
          sbc prizetab2,x
          sta profit
          lda profit+1
          sbc prizetab2+1,x
          sta profit+1
          cld
          cli
          jsr staprofit
          lda pilpos
          bne noener
          lda #93
          sta energi
          rts
noener
          cmp #$01
          bne nofood
          lda pakker
          sei
          sed
          clc
          adc #$01
          cld
          cli
          sta pakker
          rts
nofood
          lda #100
          sta spil
          jmp setterns
ex4
          rts
spil
          .byte 0
maxpos
          .byte 5
readjoy2
          dec joyned
          bne ex3
          lda #10
          sta joyned
          lda $dc00
          sta gem
          and #%00010000
          beq ex3
          lda gem
          and #%00000010
          beq buy2
          lda gem
          and #%00000100
          beq left2
          lda gem
          and #%00001000
          beq right2
ex3
          rts
left2
          lda pilpos
          beq ex3
          dec pilpos
          jmp plotpil2
right2
          lda pilpos
          cmp maxpos2
          beq ex3
          inc pilpos
plotpil2
          lda pilpos
          asl a
          tax
          lda piltab2,x
          sta sprpos+14
          lda piltab2+1,x
          sta sprpos+15
          jmp gprize2
gprize
          lda pilpos
          asl a
          lda prizetab1,x
          tay
          lda prizetab1+1,x
          jmp printprize
gprize2
          lda pilpos
          asl a
          lda prizetab2,x
          tay
          lda prizetab2+1,x
          jmp printprize
przt
          .byte $42,$46
printprize
          sta gem
          tya
          pha
          jsr getscr
          tax
          lda przt,x
          sta zp+1
          lda #$15
          sta zp
          pla
          ldx gem
          ldy #$03
          pha
          and #%00001111
          clc
          adc #$a0
          sta (zp),y
          pla
          and #%11110000
          lsr a
          lsr a
          lsr a
          lsr a
          clc
          adc #$a0
          dey
          sta (zp),y
          txa
          dey
          and #%00001111
          clc
          adc #$a0
          sta (zp),y
          txa
          and #%11110000
          lsr a
          lsr a
          lsr a
          lsr a
          clc
          adc #$a0
          dey
          sta (zp),y
          rts
initcolors
          lda #$07
          sta $d800+536
          sta $d800+535
          sta $d800+534
          sta $d800+533
          rts
terns     .byte 0,0
setterns
          lda #$ff
          sta multicol
          lda #125
          sta sprpos+13
          sta sprpos+15
          lda #208
          sta sprpos+12
          lda #234
          sta sprpos+14
          lda #$0f
          sta sprcols+6
          sta sprcols+7
          jsr randomize
          and #%00000011
          sta terns
          jsr randomize
          and #%00000011
          sta terns
          jsr randomize
          and #%00000111
          clc
          adc #90
          sta spil
ex5
          rts
tim       .byte 5
playtern
          dec tim
          bne ex5
          lda #5
          sta tim
          dec spil
          lda spil
          beq endgame
          cmp #20
          bcc ex5
          lda terns
          beq nt1
          dec terns
bakt1
          lda terns+1
          cmp #$06
          beq nt2
          inc terns+1
bakt2
          lda terns
          clc
          adc #102
          sta sprreg+6
          lda terns+1
          clc
          adc #102
          sta sprreg+7
          rts
nt1
          lda #$06
          sta terns
          jmp bakt1
nt2
          lda #$00
          sta terns+1
          jmp bakt2

endgame
          lda #$00
          sta sprpos+12
          sta sprpos+13
          lda #$7f
          sta multicol
          lda terns
          cmp #$06
          beq morejoker
          cmp terns+1
          beq toens
          lda terns+1
          cmp #$06
          beq onejoker
          jmp setpil
morejoker
          lda terns+1
          cmp #$06
          beq supervind
onejoker
          lda #$01
          jsr addprof
          jmp setpil
toens
          lda #$02
          jsr addprof
          jmp setpil
supervind
          lda #$04
          jsr addprof
setpil
          lda #109
          sta sprreg+7
          jmp plotpil2
addprof
          sei
          sed
          clc
          adc profit+1
          sta profit+1
          cld
          cli
          jmp staprofit
randomize
          lda $dc04
          sec
          sbc $dc05
          lsr a
          lsr a
          lsr a
          clc
          adc $d012
          rts
maxpos2   .byte 2
prizetab1
          .word $50,$0100,$50,$75
          .word $0100,$0150
prizetab2
          .word $50,$75,$0100

profit
          .word $1000
energi    .byte 93
scrs      .byte $40,$44
scrs2     .byte $44,$40

savescreen
          jsr getscr
          tax
          lda #$00
          sta zp
          sta zp2
          lda scrs,x
          sta zp+1
          lda #$04
          sta zp2+1
          ldy #$00
savelp1
          lda (zp),y
          sta (zp2),y
          iny
          bne savelp1
          inc zp+1
          inc zp2+1
          lda zp2+1
          cmp #$07
          bne savelp1
          lda #0
          sta zp
          sta zp2
          lda #$d8
          sta zp+1
          lda scrs2,x
          sta zp2+1
          ldy #$00
savelp2
          lda (zp),y
          sta (zp2),y
          iny
          bne savelp2
          inc zp+1
          inc zp2+1
          lda zp+1
          cmp #$db
          bne savelp2
swapchars
          nop
          sei
          lda #$35
          sta $01
          ldy #$00
          sty $d011
savelp3
          lda $f900,y
          sta gem
          lda $56b0,y
          sta $f900,y
          lda gem
          sta $56b0,y
          iny
          cpy #168
          bne savelp3
          lda #$00
          sta zp
          sta zp2
          lda #$58
          sta zp+1
          lda #$f2
          sta zp2+1
          ldy #$00
savelp4
          lda (zp),y
          sta gem
          lda (zp2),y
          sta (zp),y
          lda gem
          sta (zp2),y
          iny
          bne savelp4
          inc zp+1
          inc zp2+1
          lda zp2+1
          cmp #$f9
          bne savelp4
          lda #$37
          sta $01
          nop
          lda #23
          sta $d011
          cli
          rts
getscreen
          cld
          lda #$00
          sta zp
          sta zp2
          lda #$04
          sta zp+1
          jsr getscr
          tax
          lda scrs,x
          sta zp2+1
          ldy #$00
getloop1
          lda (zp),y
          sta (zp2),y
          iny
          bne getloop1
          inc zp+1
          inc zp2+1
          lda zp+1
          cmp #$07
          bne getloop1

          lda #$00
          sta zp
          sta zp2
          lda scrs2,x
          sta zp+1
          lda #$d8
          sta zp2+1
          ldy #$00
getloop2
          lda (zp),y
          sta (zp2),y
          iny
          bne getloop2
          inc zp+1
          inc zp2+1
          lda zp2+1
          cmp #$db
          bne getloop2
          jmp swapchars
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0
          .word 0,0,0,0,0,0,0,0,0,0

          *= $0d81
ha1
          .byte 106,107,5,0,1
          .byte 108,109,5,2,1
          .byte 96,100,3,9,1
          .byte 114,114,10,10,0
addpoint  .byte $00
animmell
          .byte 1,1,1,1,1,1,1,1
          .byte 1,1,1,1

ymin      .byte 65
ymax      .byte 80
xmin      .byte 110
xmax      .byte 210
xxxxcol
          .byte %00001110
xxxxcol2
          .byte %00001110
xyzcol1
          .byte 0
xyzcol2
          .byte 15
backcol1
          .byte 9
backcol2
          .byte 8
extra     .byte 0
extra2    .byte 0

          .byte 0
          .byte 0
nospr     .byte 0
teler     .byte 0
duk       .byte 0
swordpower .byte $02
pakker    .byte $01
knive     .byte $10
spyd      .byte $02
axes      .byte $04
kugler    .byte $02
bomber    .byte $01
swover    .byte $00
flweap    .byte $00
megabomb  .byte $00
lives     .byte $04
dying     .byte $00
undead    .byte $00
enemiesx  .byte $08
ganger    .byte 48
key       .byte $00
spctab    .byte 14,15,16,17
gottem    .byte 0,0,0,0
stop      .byte $00
keinspr   .byte $00
