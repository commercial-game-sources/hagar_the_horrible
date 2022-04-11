       *= $4700
       ;controller
zp     = $2a
zp2    = zp+2
succes = $1003
donesequence = $1000
points = $0c39
getlevel = $1003
stalevel = $1006
game   = $19fd
filpar = $ffba
filnam = $ffbd
load   = $ffd5
mapsequence = $1000
       jmp fromgame
       jmp frommap
       jmp endchar2
       jmp firstin
fromgame
       sei
       lda #$37
       sta $01
       jsr blacker
       lda doend
       beq notswapped
       jsr endchar2
notswapped
       lda level
       sta templev
       jsr checksucces
       jsr musicswap1
       sei
       jsr endchar
       jsr donecode
       jsr putdonescr
       jsr putdonespr
       jsr transsucces
       lda #$00
       sta $fc
       sta $fd
       sta $fe
       sta $ff
       lda #$37
       sta $01
       cli
       jsr donesequence
       sei
       lda #$37
       sta $01
       jsr blacker
       jsr putdonespr
       jsr donecode
       jsr endchar
       jsr musicswap2
       jsr checknull
       lda didit
       bne complete
firstin
       sei
       lda #$37
       sta $01
       jsr blacker
       jsr mapchar
       jsr mapcode
       jsr mapspr
       jsr mapscr
       jsr dosta
       lda #$37
       sta $01
       cli
       jsr mapsequence
       jmp frommap
complete
       jmp loadend
frommap
       sei
       jsr blacker
       lda #$37
       sta $01
       jsr gemlevel
       jsr mapspr
       jsr mapcode
       jsr mapchar
       jsr setlevel
       jsr clearup
       jsr settele
       jsr setcollect
       lda #$37
       sta $01
       cli
       jsr game
       jmp fromgame
blacker
       sei
       lda #$00
       sta $d011
       sta $d020
       sta $d021
       sta 54296
       sta 53248+21
       sta 53248+37
       lda $dd00
       and #%11111100
       ora #%00000011
       sta $dd00
       lda #23
       sta 53272
       lda #200
       sta 53270
       rts
musicswap1
       lda #$37
       sta $01
       ldx #$08
       ldy #$00
       jsr filpar
       ldx #<swnam1
       ldy #>swnam1
       lda #3
       jsr filnam
swapload
       lda #$00
       ldx #$00
       ldy #$c0
       jmp load
musicswap2
       ldx #$08
       ldy #$00
       jsr filpar
       ldx #<swnam2
       ldy #>swnam2
       lda #3
       jsr filnam
       jmp swapload
swnam1 .text "mus"
swnam2 .text "mix"
putdonespr
       lda #$36
       sta $01
       lda #$a7
       sta ss
       lda #$ae
       sta se
       lda #$20
       sta ds
       jsr swapper
       lda #$37
       sta $01
       rts
endchar
       lda #$d8
       sta ss
       lda #$e0
       sta se
       lda #$08
       sta ds
       lda #$30
       sta $01
       jsr swapper
       lda #$37
       sta $01
       rts
endchar2
       lda #$d8
       sta ss
       lda #$e0
       sta se
       lda #$78
       sta ds
       sei
       lda #$30
       sta $01
       jsr swapper
       lda #$37
       sta $01
       cli
       rts
donecode
       sei
       lda #$35
       sta $01
       lda #$ee
       sta ss
       lda #$f2
       sta se
       lda #$10
       sta ds
       jsr swapper
       lda #$37
       sta $01
       rts
clearup
       ldx #$00
       lda #$00
clearloop1
       sta $4700,x
       inx
       bne clearloop1
       rts
putdonescr
       lda #$36
       sta $01

       lda #$00
       sta place
       sta from
       lda #$ae
       sta from+1
       lda #$40
       sta place+1
       lda #$b0
       sta to+1
       lda #$e4
       sta to
       jsr unpack
       lda #$37
       sta $01
       rts
mapscr
       sei
       lda #$35
       sta $01
       lda #$00
       sta place
       sta from
       lda #$fa
       sta from+1
       lda #$40
       sta place+1
       lda #$fd
       sta to+1
       lda #$89
       sta to
       jsr unpack
       lda #$37
       sta $01
       rts
swapper
       lda #$00
       sta zp
       sta zp2
       lda ss
       sta zp+1
       lda ds
       sta zp2+1
       ldy #$00
swaploop
       lda (zp),y
       pha
       lda (zp2),y
       sta (zp),y
       pla
       sta (zp2),y
       iny
       bne swaploop
       inc zp+1
       inc zp2+1
       lda zp+1
       cmp se
       bne swaploop
       rts
checksucces
       clc
       lda gottem
       adc gottem+1
       adc gottem+2
       adc gottem+3
       cmp #$04
       beq suc
       lda #$00
       sta succ
       rts
transsucces
       lda succ
       sta succes
       rts
suc
       lda #$01
       sta succ
       rts
mapchar
       lda #$d0
       sta ss
       lda #$d8
       sta se
       lda #$08
       sta ds
       lda #$30
       sta $01
       jsr swapper
       lda #$37
       sta $01
       rts
mapcode
       lda #$35
       sta $01
       lda #$e0
       sta ss
       lda #$ee
       sta se
       lda #$10
       sta ds
       jsr swapper
       lda #$37
       sta $01
       rts
mapspr
       lda #$a0
       sta ss
       lda #$a7
       sta se
       lda #$39
       sta ds
       lda #$36
       sta $01
       jsr swapper
       lda #$37
       sta $01
       rts
checknull
       lda rightend
       beq resetall
       lda #$00
       sta rightend
       lda templev
       cmp #$07
       bne normal1
       lda succ
       beq noinc
       lda #$01
       sta didit
normal1
       lda succ
       beq noinc
       inc templev
noinc
       rts
dosta
       lda templev
       clc
       adc #$01
       jmp stalevel
resetall
       lda #$00
       ldx #$05
rloop1
       sta points,x
       dex
       bpl rloop1
       lda #$04
       sta lives
       lda #$01
       sta pakker
       lda #$10
       sta knive
       lda #$01
       sta bomber
       lda #$02
       sta kugler
       lda #$05
       sta axes
       sta spyd
       lda #$00
       sta templev
       sta dying
       sta doend
       rts
gemlevel
       jsr getlevel
       sta templev
       dec templev
       rts
setlevel
       ldx templev
       stx level
       lda dimtab,x
       sta $1260
       lda maxuptab,x
       sta maxup
       lda endtab,x
       sta endgegner
loadlevel
       lda #$37
       sta $01
       ldx #$08
       ldy #$00
       jsr filpar
       lda #<f1
       clc
       adc level
       tax
       ldy #>f1
       lda #$01
       jsr filnam
       lda #$00
       ldx #$00
       ldy #$80
       jmp load
loadend
       lda #$37
       sta $01
       ldx #$08
       ldy #$00
       jsr filpar
       ldx #<endtitle
       ldy #>endtitle
       lda endl
       jsr filnam
       lda #$00
       ldx #$01
       ldy #$08
       jsr load
       cli
       jmp $080b
ss     .byte $00
se     .byte $00
ds     .byte $00
succ   .byte $00
didit  .byte $00

f1     .text "1"
f2     .text "2"
f3     .text "3"
f4     .text "4"
f5     .text "5"
f6     .text "6"
f7     .text "7"
f8     .text "8"
dimtab
       .byte $82,$82,$88,$78
       .byte $6e,$73,$82,$6e
objliste
       .byte 16,18,37,31  ;1
       .byte 30,37,17,22  ;2
       .byte 34,29,15,23  ;3
       .byte 28,35,36,33  ;4
       .byte 15,17,34,38  ;5
       .byte 18,22,19,21  ;6
       .byte 28,32,19,22  ;7
       .byte 14,35,37,15  ;8
endtitle
       .text "the end"
endl
       .byte endl-endtitle
 ;unpacker-routine for DWARFERV1.37
 ; Rasmus Wernersson, 4/5 1992.

unpack
       jsr initget
       ldy #$00
loop1
       jsr get
       sta buffer,y
       iny
       bne loop1
loop2
       jsr get
       sta $09
       lda #$08
       sta $04
v3
       lsr $09
       bcc v1
       jsr get
v4
       sta ($fe),y
       sta $02
       iny
       bne v2
       inc $ff
v2
       dec $04
       bne v3
       jsr finish
       cpx #$00
       beq loop2
       rts
v1
       ldx $02
       lda buffer,x
       sta $02
       bcc v4
error
       inc $d020
       jmp error

initget
       lda place
       sec
       sbc #$07
       sta $fe
       lda place+1
       sec
       sbc #$01
       sta $ff
       lda from
       sta $fb
       lda from+1
       sta $fc
       rts
finish
       ldx #$00
       lda $fc
       cmp to+1
       bcc return
       lda $fb
       cmp to
       bcc return
       inx
return
       rts
get
       sty temp
       ldy #$00
       lda ($fb),y
       pha
       clc
       lda $fb
       adc #$01
       sta $fb
       lda $fc
       adc #$00
       sta $fc
       pla
       ldy temp
       rts
       ;-----------
settele
       lda level
       asl a
       tax
       lda teletab,x
       sta zp
       lda teletab+1,x
       sta zp+1
       ldy #$00
settloop
       lda (zp),y
       cmp #$ff
       beq settex
       sta $4720,y
       iny
       jmp settloop
settex
       rts
setcollect
       lda level
       asl a
       asl a
       tax
       lda objliste,x
       sta spctab
       lda objliste+1,x
       sta spctab+1
       lda objliste+2,x
       sta spctab+2
       lda objliste+3,x
       sta spctab+3
       lda #80
       sta $d001
       sta $d003
       sta $d005
       sta $d007
       lda #$00
       sta $d010
       sta 53248+37
       lda #$0f
       sta $d015
       sta $d01c
       sta 53248+38
       sei
       lda #$37
       sta $01
       lda #$00
       sta zp
       sta zp2
       lda #$40
       sta zp+1
       lda #$d8
       sta zp2+1
       ldy #$00
bakkl3
       lda #$00
       sta (zp),y
       lda #$0f
       sta (zp2),y
       iny
       bne bakkl3
       inc zp+1
       inc zp2+1
       lda zp+1
       cmp #$44
       bcc bakkl3
       lda #$36
       sta $01
       ldx #0
bakkl
       lda $b100,x
       sta $4000,x
       lda $b200,x
       sta $4100,x
       inx
       bne bakkl
       lda #$07
       sta $d85f+41
       sta $d860+41
       sta $d861+41
       sta $d862+41
       sta $d863+41
       sta $d864+41
       sta $d865+41
       sta $d866+41
       sta $d867+41
       lda #140
       sta $d000
       lda #163
       sta $d002
       lda #186
       sta $d004
       lda #209
       sta $d006
       lda #88
       sta 53270
       lda #9
       sta 53282
       lda #8
       sta 53283
       ldx #$03
bakkl2
       stx gem
       lda spctab,x
       asl a
       tax
       lda $c600,x
       sta zp
       lda $c601,x
       sta zp+1
       ldy #12
       lda (zp),y
       ldx gem
       sta $43f8,x
       ldy #15
       lda (zp),y
       sta 53248+39,x
       dex
       bpl bakkl2
       lda $dd00
       and #%11111100
       ora #%00000010
       sta $dd00
       lda #%00001111
       sta 53272
       jsr endchar2
       lda #27
       sta $d011
       cli
wloop
       lda $dc00
       cmp #127
       beq wloop
       jsr blacker
       jmp endchar2
place  .word $6800
from   .word $4800
to     .word $4ddc
temp   .byte $00
teletab
       .word tele1
       .word tele2
       .word tele3
       .word tele4
       .word tele5
       .word tele6
       .word tele7
       .word tele8
tele1
       .byte $5c,$0c
       .byte $32,$0d,0,0
       .byte 0,0,0,0
       .byte $73,$0d,0,0
       .byte 0,0,0,0
       .byte 6
       .byte $4e,$0e,$1d,$0e
       .byte $1d,$0e,$4e,$0e
       .byte $20,$0e,$7b,$02
       .byte $7b,$02,$20,$0e
       .byte $78,$0b,$02,$0e
       .byte $02,$0e,$78,$0b
       .byte $ff
tele2
       .byte $80,$0e
       .byte $01,$0d,0,0
       .byte 0,0,0,0
       .byte $34,$0a,$77,$0c
       .byte 0,0,0,0
       .byte 4
       .byte $01,$06,$80,$05
       .byte $80,$05,$01,$06
       .byte $31,$0b,$80,$09
       .byte $80,$09,$31,$0b
       .byte $ff
tele3
       .byte $85,$09
       .byte $47,$02,0,0
       .byte 0,0,0,0
       .byte $26,$01,0,0
       .byte 0,0,0,0
       .byte 10
       .byte $07,$01,$03,$04
       .byte $03,$04,$07,$01
       .byte $03,$01,$27,$04
       .byte $27,$04,$03,$01
       .byte $0d,$0a,$1c,$04
       .byte $1c,$04,$0d,$0a
       .byte $34,$04,$16,$07
       .byte $16,$07,$34,$04
       .byte $27,$07,$34,$07
       .byte $34,$07,$27,$07
       .byte $ff
tele4
       .byte $6d,$0b
       .byte $37,$01,0,0
       .byte 0,0,0,0
       .byte $2e,$05,0,0
       .byte 0,0,0,0
       .byte 4
       .byte $37,$09,$5a,$07
       .byte $5a,$07,$37,$09
       .byte $50,$0b,$54,$03
       .byte $54,$03,$50,$0b
       .byte $ff
tele5
       .byte $69,$0b
       .byte $28,$05,$53,$07
       .byte 0,0,0,0
       .byte $30,$09,$49,$0b
       .byte 0,0,0,0
       .byte 2
       .byte $2f,$01,$4b,$03
       .byte $4b,$03,$2f,$01
       .byte $ff
tele6
       .byte $6d,$0b
       .byte $01,$0c,$69,$02
       .byte 0,0,0,0
       .byte $62,$0b,0,0
       .byte 0,0,0,0
       .byte 18
       .byte $2f,$0c,$04,$04
       .byte $05,$04,$2f,$0c
       .byte $08,$06,$14,$0c
       .byte $14,$0c,$08,$06
       .byte $01,$08,$4a,$05
       .byte $4a,$05,$01,$08
       .byte $6d,$02,$64,$08
       .byte $64,$08,$6d,$02
       .byte $66,$08,$64,$0c
       .byte $64,$0c,$66,$08
       .byte $65,$0c,$6e,$06
       .byte $6e,$06,$65,$0c
       .byte $66,$0c,$5d,$0c ;????
       .byte $5d,$0c,$66,$0c
       .byte $03,$0a,$0c,$08
       .byte $0c,$08,$03,$0a
       .byte $ff
tele7
       .byte $14,$0d
       .byte $0a,$08,$54,$02
       .byte 0,0,0,0
       .byte $0c,$03,0,0
       .byte 0,0,0,0
       .byte 13
       .byte $10,$04,$19,$05
       .byte $19,$05,$10,$04
       .byte $33,$0d,$54,$0a
       .byte $54,$0a,$33,$0d
       .byte $66,$0b,$76,$0b
       .byte $76,$0b,$65,$0b
       .byte $72,$05,$34,$06
       .byte $34,$06,$3e,$02
       .byte $3e,$02,$72,$05
       .byte $5b,$02,$69,$0d
       .byte $69,$0d,$5b,$02
       .byte $75,$05,$10,$0c
       .byte $10,$0c,$75,$05
       .byte $ff
tele8
       .byte $66,$01
       .byte $40,$03,0,0
       .byte 0,0,0,0
       .byte $07,$01,$23,$02
       .byte 0,0,0,0
       .byte 4
       .byte $24,$0b,$01,$09
       .byte $01,$09,$24,$0b
       .byte $28,$0b,$37,$0b
       .byte $37,$0b,$28,$0b
       .byte $ff
templev .byte 0
endtab
       .byte 3
       .byte 3
       .byte 3
       .byte 4
       .byte 3
       .byte 4
       .byte 4
       .byte 4
gem    .byte 0
maxuptab
       .byte $f1
       .byte $f5
       .byte $f5
       .byte $f5
       .byte $f5
       .byte $f1
       .byte $f1
       .byte $f5
       .word 0,0,0,0,0,0,0,0,0,0,0,0,0
       .word 0,0,0,0,0,0,0,0,0,0,0,0,0
       .word 0,0,0,0,0,0,0,0,0,0,0,0,0
       .word 0,0,0,0,0,0,0,0,0,0,0,0,0
       .word 0,0,0,0,0,0,0,0,0,0,0,0,0
       .word 0,0,0,0,0,0,0,0,0,0,0,0,0
       .word 0,0,0,0,0,0,0,0,0,0,0,0,0
       .word 0,0,0,0,0,0,0,0,0,0,0,0,0
       .word 0,0,0,0,0,0,0,0,0,0,0,0,0
       .word 0,0,0,0,0,0,0,0,0,0,0,0,0


buffer = $0400
       *= $0d81
ha1
       .byte 106,107,5,0,1
       .byte 108,109,5,2,1
       .byte 96,100,3,9,1
       .byte 114,114,10,10,0
addpoint .byte $00
animmell
       .byte 1,1,1,1,1,1,1,1
       .byte 1,1,1,1

ymin   .byte 65
ymax   .byte 80
xmin   .byte 110
xmax   .byte 210
multicol
       .byte %00001110
multicol2
       .byte %00001110
mulcol1
       .byte 0
mulcol2
       .byte 15
backcol1
       .byte 9
backcol2
       .byte 8
extra  .byte 0
extra2 .byte 0
xover
       .byte 0
xover2 .byte 0
nospr  .byte 0
teler  .byte 0
duk    .byte 0
swordpower .byte $02
pakker .byte $99
knive  .byte $99
spyd   .byte $99
axes   .byte $99
kugler .byte $99
bomber .byte $99
swover .byte $00
flweap .byte $00
megabomb .byte $00
lives  .byte $99
dying  .byte $00
undead .byte $00
enemiesx .byte $08
ganger .byte 48
key    .byte $00
spctab .byte 14,15,16,17
gottem .byte 0,0,0,0
stop   .byte $00
keinspr .byte $00
rightend .byte 0

       *= $0e00
sup    .byte $00
sdw    .byte $00
sle    .byte $00
sri    .byte $00
upt
       .byte 3
lft
       .byte 3
xcoor
       .byte 4
ycoor
       .byte 1
scrvect .byte %00000101
       .byte %00010101
borvect
       .byte %00100101
scrpos
       .byte 0,0
scroll10 .byte 4
scroll1 .byte 2
scroll2
       .byte 0
scroll20
       .byte 0
doneit .byte $00
noxrq  .byte $01
doend  .byte $00
endgegner .byte $02
level  .byte $00
backcol .byte $06
maxantal .byte 3
maxup  .byte $f1
