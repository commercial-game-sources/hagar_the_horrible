        *= $1000
sfx0    = $7000
sfx3    = sfx0+3
sfx6    = sfx0+6
sfx9    = sfx0+9

        jmp startup
        jmp getlevel
        sta level
        rts
getlevel
        lda level
        rts
soundcont
        jsr sfx0
        lda sfxt
        beq nysfx
        dec sfxt
        rts
nysfx
        lda sfxt2
        beq nysfx2
        dec sfxt2
        rts
nysfx2
        lda #$f0
        sta sfxt
        jsr random
        and #%00011111
        sta sfxt2
        jsr random
        and #%00000111
        tax
        lda sfxtab,x
        sta m1
        jsr random
        and #%00000111
        tax
        lda sfxtab,x
        sta m2
        jsr random
        and #%00000111
        tax
        lda sfxtab,x
        ldx m1
        ldy m2
        jmp sfx9
sfxtab
        .byte $00,$01,$02,$13,$14,$15
        .byte $13,$00
m1      .byte $00
m2      .byte $00
sfxt2   .byte $00
sfxt    .byte $00
handler .byte $00
screenbase .word $0400
startup
        lda #$00
        sta 198
        jsr printpasscode
        jsr sfx3
        jsr setupvar
        jsr setad2
        jsr clearscreen
        jsr setupscreen
        jsr setuplevel
        sei
        lda #$7f
        sta $dc0d
        lda #$81
        sta $d01a
        lda #27
        sta $d011
        lda #0
        sta $d012
        sta doscan
        sta stop
        sta posnow
        sta sover
        lda #88
        sta mulchar
        lda #216
        sta sprpos+12
        sta sprpos
        lda #128
        sta sprpos+13
        sta sprpos+1
        lda #%00010000
        sta xover
        lda #%00010110
        sta xover2
        lda #%00100000
        sta miniover
        lda #18
        sta char1

        asl $d019
        lda #<irqst
        sta $0314
        lda #>irqst
        sta $0315
        cli
wait
        lda handler
        bne donoget
        lda stop
        beq wait
        rts
donoget
        cmp #$01
        beq jpr1
        jsr promttext2
        lda #$00
        sta handler
        jmp wait
jpr1
        jsr promttext
        lda #$00
        sta handler
        jmp wait
rast1
        .byte 0
rast2
        .byte 150
char1   .byte 18
stop    .byte $00
mulchar .byte 88
stb     .byte $00,%01000000

irq1    asl $d019
        lda rast2
        sta $d012
        jsr soundcont
        lda char1
        sta 53272
        lda mulchar
        sta 53270
        lda doscan
        bne scanner
        lda wait4set
        bne doset
        lda sailing
        beq dojoy
        jsr dosail
        jmp nojoy
doset
        jsr setcont
        jmp nojoy
dojoy
        jsr getjoy
        jsr whereto
        jmp nojoy
scanner
        lda #$00
        sta 198
        jsr scankeys
nojoy
        jsr movespr
        jsr animation
        lda xover
        and #%10111111
        ora sover
        sta xover
        lda xover2
        and #%10111111
        ora sover
        sta xover2

        jsr flytdatas
        lda #58
wpos2
        cmp $d012
        bne wpos2
        ldx #10
wn3
        dex
        bne wn3
        lda #18
        sta 53272
        lda #88
        sta 53270

        lda #115
waitpos
        cmp $d012
        bne waitpos
        jsr miniflyt
q1
        lda #<irq2
        sta $0314
        lda #>irq2
        sta $0315
        jmp $ea31
irqexit
        lda stop
        beq iqx
        jmp stopirq
iqx
        pla
        tax
        pla
        tay
        pla
        rti
irq2
        asl $d019
        lda rast1
        sta $d012
        jsr flytdatas2
        lda #<irq1
        sta $0314
        lda #>irq1
        sta $0315
        jmp irqexit
irqst
        asl $d019
        lda #250
        sta $d012
        lda fin
xlx
        cmp #$01
        beq startspr
        jsr scrollmap
        jmp irqexit
startspr
        lda mulcol1
        sta 53248+37
        lda mulcol2
        sta 53248+38

        lda rast2
        sta $d012
        jsr animation
        jsr lightspr
        jsr flytdatas
        lda #115
waitpos2
        cmp $d012
        bne waitpos2
        jsr miniflyt
        lda #<irqst2
        sta $0314
        lda #>irqst2
        sta $0315
        jmp irqexit
exirq
        jmp irq2
irqst2
        asl $d019
        clc
        lda fin
        cmp #$02
        beq exirq
        jsr flytdatas2
        lda #$00
        sta $d012
        lda #<irqst
        sta $0314
        lda #>irqst
        sta $0315
        jmp irqexit
stopirq
        lda #$31
        sta $0314
        lda #$ea
        sta $0315
        lda #$00
        sta $d01a
        lda #$01
        sta $dc0d
        jmp $ea31
fin     .byte 0

joy     .byte 0

xmin    .byte 137
xmax    .byte 47
ymin    .byte 67
ymax    .byte 220

movespr
        jsr chspeed
        lda pilspeed
        sta pspd
movespr2
msv0
        lda right
        beq msv1
        lda sprpos
        cmp xmax
        bne mmsv1
        lda xover
        and #%00000001
        bne msv1
mmsv1
        inc sprpos
        bne msv1
        lda xover
        ora #%00000001
        sta xover
msv1
        lda left
        beq msv2
        lda sprpos
        cmp xmin
        bne mmsv2
        lda xover
        and #%00000001
        beq msv2
mmsv2
        dec sprpos
        bpl msv2
        beq msv2
        lda xover
        and #%11111110
        sta xover
msv2
        lda up
        beq msv3
        lda sprpos+1
        cmp ymin
        beq msv3
        dec sprpos+1
msv3
        lda down
        beq msv4
        lda sprpos+1
        cmp ymax
        beq msv4
        inc sprpos+1
msv4
        dec pspd
        bne movespr2
        rts
chspeed
        lda joy
        and #%00001111
        cmp oldd
        bne chsv1
        lda pilspeed
        cmp #8
        beq chsv2
        dec chned
        bne chsv2
        lda #4
        sta chned
        inc pilspeed
        jmp chsv2
chsv1
        lda #1
        sta pilspeed
chsv2
        lda joy
        and #%00001111
        sta oldd
        rts
pspd
        .byte 2
pilspeed
        .byte 2
oldd    .byte 0
chned   .byte 2

getjoy
        ldx #$00
getloop1
        lda #0
        sta fire,x
        inx
        cpx #$05
        bne getloop1
        ldx $dc00
        stx joy
        txa
        and #%00000001
        sta down
        txa
        and #%00000010
        sta up
        txa
        and #%00000100
        sta right
        txa
        and #%00001000
        sta left
        txa
        and #%00010000
        sta fire
        rts
fire
        .byte 0
up
        .byte 0
down
        .byte 0
left
        .byte 0
right
        .byte 0

sphit1  .byte 0
sphit2  .byte 0
sphit3  .byte 0

flytdatas
        lda $d01e
        and #%00000111
        sta sphit3
        lda #$00
        sta $d01e
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
        ora #%00100010
        sta 53248+21
        rts
gem     .byte 0

miniflyt
        lda $d01e
        and #%00011100
        sta sphit1
        lda #$00
        sta $d01e
        lda on
        and #%11111001
        sta gem
        lda on
        and #%00000010
        asl a
        ora gem
        sta 53269
        lda xover
        ora #%00100000
        sta $d010
        lda minipos
        sta $d004
        lda minipos+1
        sta $d005
        lda minipos+2
        sta $d00a
        lda minipos+3
        sta $d00b
        lda minireg
        sta 2042
        lda minireg+1
        sta 2045
        lda #$04
        sta 53248+41
        rts
flytdatas2
        lda $d01e
        and #%00100100
        sta sphit2
        lda #$00
        sta $d01e
        ldx #$02
fltloop12
        lda sprpos2,x
        sta $d000,x
        inx
        cpx #$0c
        bne fltloop12
        ldx #$01
fltloop22
        lda sprcols2,x
        sta $d027,x
        lda sprreg2,x
        sta 2040,x
        inx
        cpx #$06
        bne fltloop22
        clc
        lda xover
        and #%01000001
        ora xover2
        sta $d010
        lda multicol2
        sta 53248+28
        lda on2
        and flames
        ora #%01000000
        sta 53248+21
        rts

animation

        ldx #$00
        stx animteller
        ldy #$00
        jmp animstart
animloop1
        cpx #$0f
        beq animexit
        tya
        adc #$05
        tay
        inx
animstart
        lda anim0+4,y
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
        bpl animfade
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
        sty animygem
        stx animxgem


        lda anim0+3,y
        clc
        sbc #$10
        tax
        lda fadetab,x
        tax
fadev1
        ldx animxgem
       ; sta animagem
        clc
        adc fadetel,x

        tax  ;samlet tillaegs vaerdi i x
        lda fade1,x
        ldx animxgem
        sta sprcols,x

        jmp animloop1

animexit
        rts

animxgem .byte 0
animygem .byte 0
animagem .byte 0
fadetab .byte 0,6,12,18,24,30,36,40

animteller .byte 0

setspr
        ldx #$00
        ldy #$00
setloop1
        lda anim0,y
        sta sprreg,x
        tya
        adc #$05
        tay
        inx
        cpx #$10
        bne setloop1
        rts

sprpos
        .byte 140,100
        .byte 128,106
        .byte 154,67
        .byte 225,68
        .byte 15,92
        .byte 128,90
        .byte 216,128
        .byte 222,128
sprpos2
        .byte 200,100
        .byte 35,178
        .byte 1,197
        .byte 202,202

        .byte 16,179
        .byte 222,203
        .byte 0,0
        .byte 0,0
minipos
        .byte 156,121
        .byte 33,130
miniover .byte %00100000
sprcols
        .byte 10
        .byte 7
        .byte 7
        .byte 11
        .byte 3
        .byte 7
        .byte 9
        .byte 7
sprcols2
        .byte 10
        .byte 5
        .byte 11
        .byte 14

        .byte 7
        .byte 7
        .byte 0
        .byte 0
sprreg
        .byte $f9
        .byte $e7
        .byte $fe
        .byte $fd
        .byte $fc
        .byte $e8
        .byte $e9
        .byte $f8
sprreg2
        .byte $f9
        .byte $fb
        .byte $fd
        .byte $fa
        .byte $f5
        .byte $f7
        .byte $00
        .byte $00

minireg .byte $ff,$f2
xover
        .byte %00010000
xover2
        .byte %00010110
multicol
        .byte %11111111
multicol2
        .byte %11001111
mulcol1
        .byte 0
mulcol2
        .byte 12
screencol
        .byte $00
bordercol
        .byte $00
on
        .byte %11111111
on2
        .byte %11111111

anim0
        .byte $f9,$f9,3,10,0
anim1
        .byte 0,0,0,0,0
anim2
        .byte $fe,$fe,1,$16,0
anim3
        .byte 0,0,0,0,0
anim4
        .byte 0,0,0,0,0
anim5
        .byte $fe,$fe,1,$16,0
anim6
        .byte 0,0,0,0,0
anim7
        .byte 0,0,0,0,0

anim8
        .byte 0,0,0,0,0
anim9
        .byte $f9,$ff,3,10,0
anim10
        .byte 0,0,0,0,0
anim11
        .byte 0,0,0,0,0
anim12
        .byte $f4,$f5,5,$14,1
anim13
        .byte $f6,$f7,4,$14,1
anim14
        .byte 0,0,0,0,0
anim15
        .byte 0,0,0,0,0

animmell
        .byte 1,1,1,1,1,1,1,1 ;ned tell
        .byte 1,1,1,1,1,1,1,1


         ;fade registre
fade1
        .byte $0b,$0c,$0f,$01,$0f,$0c

        .byte $06,$04,$02,$0a,$02,$04

        .byte $05,$03,$0d,$07,$0d,$03

        .byte $09,$08,$07,$01,$07,$08

        .byte $09,$05,$0a,$07,$0a,$09

        .byte 7,13,7,13,7,13
fadetel
        .byte 0,0,0,0,0,0,0,0
        .byte 0,0,0,0,0,0,0,0,0
inde
        .byte 13
setupscreen
        lda screenbase
        sta destination
        lda screenbase+1
        sta destination+1
        lda #$00
        sta source
        lda #$40  ; $4000
        sta source+1
        lda #$10-3
        sta xb
        lda #$19
        sta yb
        lda #$18+3
        sta smod
        sta dmod
        jsr blitter
        lda #$00
        sta destination
        sta source
        lda #$d8
        sta destination+1
        lda #$44
        sta source+1
        jsr blitter
        lda #12
        sta smod
        sta dmod
        lda #$28-12
        sta xb
        lda #$00
        sta $0400+12
        sta $0428+12
        sta $0400+(24*40)+12
        sta $0400+(23*40)+12
        lda #$09
        sta 53248+37
        lda #$07
        sta 53248+38
        lda #$00
        sta 53248+39
        sta 53248+40
        lda #132
        sta 53248
        lda #128
        sta 53250
        lda #90
        sta 53249
        lda #106
        sta 53251
        lda #$03
        sta 53269
        sta 53248+28
        lda #$e5
        sta 2041
        lda #$e6
        sta 2040
        rts

blitter
        clc
        lda yb
        sta yb2
        lda #$00
        cmp xb
        beq error
        cmp yb
        beq error
        lda source
        sta $fb
        lda source+1
        sta $fc
        lda destination
        sta $fd
        lda destination+1
        sta $fe
blitloop2
        ldy #$00
blitloop
        lda ($fb),y
        sta ($fd),y
        iny
        cpy xb
        bne blitloop
        clc
        lda $fb
        adc smod
        bcc blitv1
        inc $fc
blitv1
        clc
        adc xb
        bcc blitv3
        inc $fc
blitv3
        sta $fb
        clc
        lda $fd
        adc dmod
        bcc blitv2
        inc $fe
blitv2
        clc
        adc xb
        bcc blitv4
        inc $fe
blitv4
        sta $fd
        clc
        dec yb2
        bne blitloop2
        rts
error
        lda #$01
        sta err
        rts

source  .word $00
destination .word $00
xb      .byte $00
yb      .byte $00
yb2     .byte $00
smod    .byte $00
dmod    .byte $00
err     .byte $00
scrcont .byte 1
str     .byte 10
str2    .byte 13
scradd  .byte 0
finex
        lda #$01
        sta fin
ex      rts
mcv2
        lda #50
        sta scrcont
        jsr set2
        jmp mcv1
scrollmap
        dec scrcont
        bne ex
        lda #$01

        sta scrcont
        jsr setad1
        jsr set3
        clc
        lda str
        cmp #10
        beq mcv2
        jsr set2
        jsr set4
mcv1
        clc
        lda str
        cmp #$00
        beq finex
        dec str
        inc str2
        rts
setad1
        lda #$02
        sta yb
        lda #12
        sta source
        lda #$40
        sta source+1
        lda str
        asl a
        tax
        lda scraddtab1,x
        sta destination
        inx
        lda scraddtab1,x
        clc
        adc #$04
        sta destination+1
        jsr blitter
        lda source+1
        clc
        adc #$04
        sta source+1
        clc
        lda destination+1
        adc #$d4
        sta destination+1
        jsr blitter
        rts

set2
        lda #$01
        sta yb
        lda str
        asl a
        tax
        inx
        inx
        inx
        inx
        lda scraddtab1,x
        sta source
        sta destination
        inx
        lda scraddtab1,x
        tay
        clc
        adc #$40
        sta source+1
        tya
        clc
        adc #$04
        sta destination+1
        jsr blitter
        clc
        lda source+1
        adc #$04
        sta source+1
        clc
        lda destination+1
        adc #$d4
        sta destination+1
        jsr blitter
        rts
set3
        lda #$02
        sta yb
        lda #$98+12
        sta source
        lda #$43
        sta source+1
        lda str2
        asl a
        tax
        lda scraddtab1,x
        sta destination
        inx
        lda scraddtab1,x
        clc
        adc #$04
        sta destination+1
        jsr blitter
        clc
        lda source+1
        adc #$04
        sta source+1
        clc
        lda destination+1
        adc #$d4
        sta destination+1
        jsr blitter
        rts

set4
        lda #$01
        sta yb
        lda str2
        asl a
        tax
        dex
        dex
        lda scraddtab1,x
        sta source
        sta destination
        inx
        lda scraddtab1,x
        tay
        clc
        adc #$40
        sta source+1
        tya
        clc
        adc #$04
        sta destination+1
        jsr blitter
        clc
        lda source+1
        adc #$04
        sta source+1
        clc
        lda destination+1
        adc #$d4
        sta destination+1
        jsr blitter
        rts
setad2

        lda #$28
        sta xb
        lda #$01
        sta yb
        lda #$00
        sta smod
        sta dmod
        rts
scraddtab1
        .byte $0c,$00,$34,$00,$5c,$00
        .byte $84,$00,$ac,$00,$d4,$00
        .byte $fc,$00,$24,$01,$4c,$01
        .byte $74,$01,$9c,$01,$c4,$01
        .byte $ec,$01,$14,$02,$3c,$02
        .byte $64,$02,$8c,$02,$b4,$02
        .byte $dc,$02,$04,$03,$2c,$03
        .byte $54,$03,$7c,$03,$a4,$03
        .byte $cc,$03
clearscreen
        clc
        ldx #$00
        lda #$00
clearloop
        sta $0400,x
        sta $0400+250,x
        sta $0400+500,x
        sta $0400+750,x
        inx
        cpx #250
        bne clearloop
        rts

setupvar
        lda #$00
        sta $d011
        jsr wait2
        sta $d020
        sta $d021
        sta on
        sta on2
        sta lih
        lda #18
        sta 53272
        sta fin
        sta scradd
        lda #10
        sta str
        lda #13
        sta str2
        lda #9
        sta 53282
        lda #8
        sta 53283
        lda #88
        sta 53270
        rts
lih     .byte 0
liht
        .byte 2
ex3
        lda #$02
        sta fin
ex2
        rts
lightspr
        clc
        dec liht
        bne ex2
        lda #4
        sta liht
        clc
        ldx lih
        clc
        cpx #10
        beq ex3
        lda litb,x
        sta on
        lda litb2,x
        sta on2
        clc
        inc lih
        rts
litb
        .byte %00000001,%00000011
        .byte %00000111,%00001111
        .byte %00011111,%00111111
        .byte %00111111,%00111111
        .byte %00111111,%11111111
litb2
        .byte 0,0,0,0,0,0
        .byte %00010011,%00010111
        .byte %00111111,%11111111


wait2
        clc
        ldx #$10
w3
        ldy #$00
w2
        dey
        bne w2
        dex
        bne w3
        rts
backobjtab1
        .byte $f9
        .byte $e7
        .byte $fe
        .byte $fd
        .byte $fc
        .byte $e8
        .byte $e9
        .byte $f8
        .byte $f9
        .byte $fb
        .byte $fd
        .byte $fa
        .byte $f5
        .byte $f7
        .byte $00
        .byte $00

        .byte $ff,$fe
lv      .byte 0
flames  .byte 0
ex4
        rts
setuplevel
        lda #5
        sta sprcols2+1
        lda level
        sta lv
        dec lv
        lda #$ff
        sta flames
        ldx #$00
slev1
        lda backobjtab1,x
        sta sprreg,x
        inx
        cpx #18
        bne slev1
        lda level
        cmp #$01
        beq ex4
        lda #$f3
        sta minireg
        dec lv
        beq ex4
        lda #$f2
        sta sprreg+2
        dec lv
        beq ex4
        lda #$f1
        sta sprreg+3
        dec lv
        beq ex4
        lda #$f2
        sta sprreg+4
        dec lv
        beq ex4
        lda #$f0
        sta minireg+1
        dec lv
        beq ex4
        lda #$ef
        sta sprreg2+1
        lda #$01
        sta sprcols2+1
        lda #%00101111
        sta flames
        dec lv
        beq ex4
        lda #$f1
        sta sprreg2+2
        dec lv
        beq ex4
        lda #$ee
        sta sprreg2+3
        lda #$01
        sta sprcols2+3
        lda #%00001111
        sta flames
ex5
        rts
goto    .byte 0
whereto
        lda fire
        bne ex5
        lda sphit1
        beq wp2
        tay
        and #%00000100
        beq wv1
        lda #$02
        jmp ex6
wv1
        tya
        and #%00001000
        beq wv2
        lda #$03
        jmp ex6
wv2
        lda #$04
        jmp ex6
wp2
        lda sphit2
        beq wp3
        and #%00000100
        beq wv3
        lda #$01
        jmp ex6
wv3
        lda #$05
        jmp ex6
wp3
        lda sphit3
        beq wp4
        tay
        and #%00000100
        beq wv4
        lda #$07
        jmp ex6
wv4
        tya
        and #%00000010
        beq wv5
        lda #$06
        jmp ex6
wv5
        lda #$08
        jmp ex6
wp4
        rts
ex6
        sta going
        lda #$00
        sta revs
prelev
        lda #$01
        sta sailing
        lda going
        sec
        sbc #$01
        asl a
        asl a
        asl a
        sta fastboath
        tax
        lda revs
        bne jrvs
        lda sailtab1,x
        sta sailtel
        lda sailtab1+1,x
        sta bret
        lda #$01
        sta wait4set
        rts
jrvs    jmp rvsail1
revs    .byte $00
revsail
        ldx #$00
        lda sailing
        and #$01
        beq lfrh2
        ldx #$01
lfrh2
        lda bret
        bne sadw
        jmp incpos
dosail
        lda sailtel
        beq vsail1
        sec
        sbc #$01
        sta sailtel
        lda revs
        bne revsail
        ldx #$00
        lda sailing
        and #$01
        bne lfrh
        ldx #$01
lfrh
        lda bret
        beq sadw
incpos
        lda #$ed
        sta sprreg+6
        lda sprpos+12,x
        clc
        adc #$01
        sta sprpos+12,x
        bne nocross
        lda #%01000000
        sta sover
nocross
        rts
sadw
        lda #$ec
        sta sprreg+6
        lda sprpos+12,x
        sec
        sbc #$01
        sta sprpos+12,x
        cmp #$ff
        bne nocross
        lda #$00
        sta sover
        rts
vsail1
        lda sailing
        cmp #$04
        bcs finsail
        inc sailing
        lda fastboath
        clc
        adc #$02
        sta fastboath
        tax
        lda revs
        bne rvsail1
        lda sailtab1,x
        sta sailtel
        lda sailtab1+1,x
        sta bret
        rts
rvsail1
        lda revsailtab1,x
        sta sailtel
        lda revsailtab1+1,x
        sta bret
        rts
finsail
        lda #$00
        sta sailing
        lda revs
        bne clearrevs
        lda going
        cmp level
        bcs sprt
        lda #$01
        sta revs
        sta posnow
        lda going
        jmp prelev
clearrevs
        lda #$01
        sta wait4set
        rts
sprt
        lda #$01
        sta handler
        rts
promttext
        lda #23
        sta char1
        lda #200
        sta mulchar
        ldx #$00
promtloop1
        lda #11
        sta $d800,x
        lda input,x
        and #%10111111
        sta $0400,x
        inx
        cpx #$28
        bne promtloop1
        lda #$01
        sta doscan
        lda #$50
        sta $0401
        rts
promttext2
        lda #18
        sta char1
        lda #88
        sta mulchar
        ldx #$00
promtloop2
        lda #9
        sta $d800,x
        lda $4000,x
        sta $0400,x
        inx
        cpx #$28
        bne promtloop2
        lda #$00
        sta doscan
        rts
waitscan .byte $10
scankeys
        lda waitscan
        beq stscan
        dec waitscan
        rts
stscan
        ldx posnow
        lda #$64
        sta $0400+30,x
        ldy sccol
        lda sctab,y
        sta $d800+30,x
        cpy sccoll
        bne stsc2
        lda #$ff
        sta sccol
stsc2
        inc sccol
        lda 197
        beq backspc
        cmp #$01
        beq return
        ldx #$00
scanloop1
        cmp keycon,x
        beq found
        inx
        cpx #10
        bne scanloop1
        rts
found
        txa
        ldx posnow
        cpx #$04
        beq normex
        sta thizword,x
        clc
        adc #$30
        sta $0400+30,x
        lda #$0f
        sta $d800+30,x
        cpx #$04
        beq normex
        inc posnow
normex
        lda #10
        sta waitscan
        rts
posnow
        .byte $00
thizword .byte 0,0,0,0
return
        lda posnow
        cmp #$04
        bne bad
        lda going
        sec
        sbc #$01
        asl a
        asl a
        tax
        ldy #$00
comloop1
        lda thizword,y
        cmp pass1,x
        bne bad
        iny
        inx
        cpy #$04
        bne comloop1
        lda #$01
        sta stop
        lda going
        sta level
        rts
bad
        lda #$02
        sta handler
        lda #$01
        sta revs
        lda #$00
        sta doscan
        sta posnow
        lda going
        jmp prelev
backspc
        ldx posnow
        beq normex
        dex
clearchar
        lda #$20
        sta $0400+30,x
        sta $0400+31,x
        stx posnow
        jmp normex

doscan  .byte $00
sover   .byte $00
wait4set .byte $00
setw
        .byte $05
setcont
        lda revs
        bne revssejl
setsejl
        dec setw
        bne setex
        lda #$05
        sta setw
        lda sprreg+6
        cmp #$ec
        beq finset1
        inc sprreg+6
setex
        rts
finset1
        lda #$00
        sta wait4set
        rts
revssejl
        dec setw
        bne setex
        lda #$05
        sta setw
        lda sprreg+6
        cmp #$e9
        beq finset2
        dec sprreg+6
        rts
finset2
        lda #$00
        sta wait4set
        sta revs
        rts
printpasscode
        jsr $e544
        ldx #29
prploop
        lda #$07
        sta $d800,x
        lda passtext,x
        sta $0400,x
        dex
        bpl prploop
        lda level
        clc
        adc #$30
        sta $0418
        cmp #$31
        beq specprint
        lda level
        sec
        sbc #$02
        asl a
        asl a
        tax
        lda pc2,x
        sta $041e
        lda pc2+1,x
        sta $041f
        lda pc2+2,x
        sta $0420
        lda pc2+3,x
        sta $0421
        lda #$08
        sta $d81e
        sta $d81f
        sta $d820
        sta $d821
        jmp waiter
specprint
        ldx #9
spcprl
        lda pc1,x
        sta $041e,x
        lda #$02
        sta $d81e,x
        dex
        bpl spcprl
waiter
        lda #23
        sta 53272
        lda #$1b
        sta $d011
hhh
        lda $d012
        bne hhh
        lda 197
        cmp #64
        bne passex
        lda $dc00
        cmp #127
        beq hhh
passex
        rts
random
        lda $dc04
        sec
        sbc $dc05
        lsr a
        lsr a
        lsr a
        clc
        adc $d012
        rts
         ; 0=up/left  1=dw/right
sailtab1
        .byte $18,$00,$0a,$00,$0e,$00
        .byte $00,$00
        .byte $18,$00,$28,$00,$10,$00
        .byte $05,$00
        .byte $18,$00,$28,$00,$18,$01
        .byte $01,$00
        .byte $00,$00,$04,$01,$22,$01
        .byte $1a,$00
        .byte $00,$00,$10,$01,$36,$01
        .byte $00,$00
        .byte $00,$00,$14,$01,$3a,$01
        .byte $06,$01
        .byte $00,$00,$20,$01,$21,$01
        .byte $1b,$01
        .byte $00,$00,$20,$01,$06,$01
        .byte $1a,$01

        .byte $00
upndw   .byte $00
bret    .byte $00
fastboath .byte $00
going   .byte $00
sailing .byte $00
sailtel .byte $00
level   .byte 2
input
        .text " please enter the pass"
        .text "code:             "
pass1   .byte 0,8,0,8
pass2   .byte 0,0,4,2
pass3   .byte 7,9,1,3
pass4   .byte 1,9,8,4
pass5   .byte 4,8,3,0
pass6   .byte 3,3,4,6
pass7   .byte 1,9,7,4
pass8   .byte 2,0,0,1
keycon
        .byte 35,56,59,8,11,16,19,24
        .byte 27,32
revsailtab1
        .byte $00,$00,$0e,$00,$0a,$00
        .byte $18,$00
        .byte $05,$00,$10,$00,$28,$00
        .byte $18,$00
        .byte $01,$00,$18,$01,$28,$00
        .byte $18,$00
        .byte $1a,$00,$22,$01,$04,$01
        .byte $00,$00
        .byte $00,$00,$36,$01,$10,$01
        .byte $00,$00
        .byte $06,$01,$3a,$01,$14,$01
        .byte $00,$00
        .byte $1b,$01,$21,$01,$20,$01
        .byte $00,$00
        .byte $1a,$01,$06,$01,$20,$01
        .byte $00,$00
passtext
        .text " the passcode for level"
        .text "   is: "
pc1
        .text "see manual"
pc2
        .text "0042"
pc3
        .text "7913"
pc4
        .text "1984"
pc5
        .text "4830"
pc6
        .text "3346"
pc7
        .text "1974"
pc8
        .text "2001"
sccol   .byte $00
sctab
        .byte 9,9,9,5,5,5,13,13,13
        .byte 7,7,7,1,1,1,13,13,13
        .byte 5,5,5
sccoll  .byte sccoll-sctab

