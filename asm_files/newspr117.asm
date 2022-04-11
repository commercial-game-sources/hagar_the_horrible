
       *= $1a00-3

start  = $1000
getscr = $1003
getscll = $1006
getstop = $1009
getextra = $100c
doitall = $2400
flytd2 = $2403
doit2  = $2406
resetspr = $2409
chsfx  = $7006
plotweap = $2400+15
otab   = $3800
zp     = $2e
zp2    = $32
zp3    = $f9
filpar = $ffba
filnam = $ffbd
load   = $ffd5
    ;mover+newspr=system
       jmp startup

       nop
       nop
       nop
       jmp sh
       jmp endless
       jmp putsword
       jmp calcsw
       jmp putpoints
       jmp getprof
       jmp staprof
       jmp loadit
staprof
       stx profit+1
       sty profit+2
       rts
getprof
       lda profit
       ldx profit+1
       ldy profit+2
       rts
sh
       lda #$00
       sta megabomb
       inc action
       lda stop
       bne slutirq
       lda keinspr
       bne okdo
       lda noxrq
       bne irqexit
       lda $fffe
       sta gemmer
       lda $ffff
       sta gemmer+1
       lda sprrast
       sta $d012
       lda #<extirq
       sta $fffe
       lda #>extirq
       sta $ffff
okdo
       jmp irqexit
extirq
       pha
       txa
       pha
       tya
       pha
       lda #$00
       sta $d012
       asl $d019
     ; inc $d020
     ; inc $d020
       jsr flytd2
     ; dec $d020
     ; dec $d020
       lda gemmer
       sta $fffe
       lda gemmer+1
       sta $ffff
       jmp irqexit
slutirq
       sei
       lda #$37
       sta $01
       lda #$31
       sta $0314
       lda #$ea
       sta $0315
       lda #$00
       sta $d01a
       sta $dc0e
       lda #$01
       sta $dc0d
       cli
       jmp $ea31
irqexit
       pla
       tay
       pla
       tax
       pla
       rti
takfornu
       rts
endless
       lda action
       beq endless
       lda stop
       bne takfornu
       jsr doitall
       jsr ctpo
       jsr doit2
       lda keinspr
       bne clnjmp
       jsr movspr
clnjmp
       dec action
       jmp endless
startup
       jsr plotweap
       ldx #$00
sl
       lda ha1,x
       sta anim0,x
       inx
       cpx #20
       bne sl
       jsr resetspr
       jsr initspr
       jsr initsword
       lda backcol1
       sta 53282
       lda backcol2
       sta 53283
       lda mulcol1
       sta 53248+37
       lda mulcol2
       sta 53248+38
       lda #10
       sta sprcols+3
       lda #$00
       sta key
       sta stop
       sta gottem
       sta gottem+1
       sta gottem+2
       sta gottem+3
       sta doend
       sta dying
       sta upt
       lda #3
       sta lft
       lda #93
       sta energy
       jsr calcsw
       lda #110
       sta xmin
       lda #210
       sta xmax
       lda #80
       sta ymax
       lda #65
       sta ymin
       lda #6
       sta backcol
       lda #62
       sta yhag
       lda #%00000100
       sta scrvect
       lda #$02
       sta vej
       lda #$03
       sta maxantal
       lda #35
       sta xhag
       lda #60
       sta yhag
       jmp start
initspr
       ldx #$00
       ldy #$00
l
       lda anim0,x
       sta sprreg,y
       inx
       inx
       inx
       inx
       inx
       iny
       cpy #$08
       bne l
       jmp $7003
xcoor2 .byte 0
tell   .byte 0

gohome
       lda #4
       sta tell
getoff
       rts
slamsprites
       lda thiztel
       beq getoff
       ldx #$00
       stx gem2
sloop1
       lda thiztab,x
       tay
       lda antab,y
       clc
       adc gem2
       sta gem2
       cmp #4
       bcs slamit
       inx
       cpx thiztel
       bne sloop1
slamit
       clc
       lda gem2
       adc sprfree
       cmp #5
       bcc putem
       lda half
       bne gohome
       jsr pex1
putem
       ldx #$00
       stx gem5
mainloop
       lda thiztab,x
       sta objnr
       lda thizret,x
       sta objret
       lda thizc,x
       sta objc
       lda thizc1,x
       sta objc+1
       lda thizcy,x
       sta objcy
       jsr putspr
       lda stopspr
       bne gohome
       inc gem5
       ldx gem5
       cpx thiztel
       bne mainloop
       rts
prpo   .byte 0
maxsprz .byte $00
ctex
       rts
ctpo
       lda prpo
       beq ctex
       asl a
       tax
       lda pointtab+1,x
       sta gem
       lda pointtab,x
       ldy #$00
       ldx prpo
       sty prpo
       cpx #15
       bcc addp
addpro
       sed
       clc
       adc profit+2
       sta profit+2
       lda profit+1
       adc gem
       sta profit+1
       lda profit
       adc #$00
       sta profit
       cld
       rts
addp
       clc
       sed
       adc points+2
       sta points+2
       lda points+1
       adc gem
       sta points+1
       lda points
       adc #$00
       sta points
       cld
ex11
       rts
isnomore .byte 0
exhit  .byte 5
howhit .byte 5
atdown .byte 0
checkhit
       lda dying
       bne ex11
       lda outta
       cmp #11
       beq ex11
       lda thiztab,x
       beq ex11
       cmp #14
       bcs laes
       lda megabomb
       beq laes
       lda #$73
       sta (zp),y
       lda thiztab,x
       tax
       lda antab,x
       sta antab
       lda doend
       bne slukmega
       lda #$01
       jmp chsfx
slukmega
       dec endgegner
       dec megabomb
       lda #$01
       jmp chsfx
laes
       lda yhag
       sec
       sbc #20
       cmp thizcy,x
       bcs ex11
       clc
       adc #40
       cmp thizcy,x
       bcc ex11
       lda thizc1,x
       beq osse
       lda haover
       beq ex12
osse
       lda haover
       beq osse2
       jmp ex12
osse2
       lda xhag
       sec
       sbc #20
       cmp thizc,x
       bcs chmore1
       clc
       adc #40
       cmp thizc,x
       bcc chmore2
       lda thiztab,x
       cmp #14
       bcs takeit
       jsr degy
       jmp killem
takeit
       sta prpo
       lda #$7f
       sta (zp),y
       inc isnomore
       jmp specobj
ex12
       jmp chflyv
chmore1
       sta gem4
       lda vej
       and #$7f
       cmp #$01
       beq ex12
       lda gem4
       sec
       sbc #15
       cmp thizc,x
       bcs ex12
       lda sw
       bne jkillem
       jmp atreal
chmore2
       sta gem4
       lda objret
       and #$7f
       cmp #$02
       beq ex12
       lda gem4
       clc
       adc #15
       cmp thizc,x
       bcc ex12
       lda sw
       bne jkillem
atreal
       lda thiztab,x
       tax
       lda doatttab,x
       bne okdoatt
       rts
okdoatt
       inc att
       lda acter
       bne gotye
       lda atthasttab,x
       sta nedder
       inc acter
ex13
       rts
acter  .byte 0
nedder .byte 0
jkillem jmp killem
killem
       lda thiztab,x
       cmp #14
       bcs ex13
       ldy gem5
       iny
       iny
       iny
       lda (zp),y
       beq kill2
       lda swordpower
       cmp #$02
       bcs raway
       lda flweap
       bne raway
       dec exhit
       bne atreal
raway
       lda howhit
       sta exhit
       lda (zp),y
       cmp swordpower
       bcc kill2
       sec
       sbc swordpower
       sta (zp),y
       jmp atreal
kill2
       lda #$00
       sta acter
       lda #$73
       ldy gem5
       dey
       dey
       sta (zp),y
       ldx thiztel
       lda thiztab,x
       sta prpo
       tax
       lda antab,x
       sta antab
       lda #$01
       jsr chsfx
       ldy gem5
       lda (zp),y
       and #%00111111
       sta (zp),y
       ldx thiztel
       lda doend
       beq ex10
       dec endgegner
ex10
       rts
gotye
       dec nedder
       bne ex10
       lda #50
       sta nedder
       lda #13
       jsr chsfx
       lda duk
       bne halvener
       lda energy
       sec
       sbc #15
       sta energy
       jmp calcsw
halvener
       lda energy
       sec
       sbc #5
       sta energy
       jmp calcsw
specobj
       lda prpo
       cmp #24
       beq nogl
       ldx #$03
specl
       cmp spctab,x
       beq thizone
       dex
       bpl specl
       lda #$03
       jmp chsfx
nogl
       inc key
       lda #$03
       jmp chsfx
thizone
       lda #$01
       sta gottem,x
       lda #$04
       jmp chsfx
atthasttab
       .byte 0,0,0,0,3,0,0,0,0,51
       .byte 38,1
att    .byte 0
gem5   .byte $00
movspr
       ldy #$00
       sty sprfree
       sty sprfree2
       sty objtel
       sty objtel2
       sty half
       sty thiztel
       sty stopspr
       sty maxsprz

       lda #%00001110
       sta multicol
       sta multicol2
       lda #$01
       sta noxrq
       sta tell
       lda xcoor
       clc
       adc #10
       sta xcoor2
       lda ycoor
       asl a
       tax
       lda quickmult,x
       sta zp
       lda quickmult+1,x
       clc
       adc sprdbase+1
       sta zp+1
       lda #1
       lda enemiesx
       sta tell2
movl1
       lda (zp),y
       beq geton
       jmp movv2
movv1
       iny
inv1
       iny
       iny
       iny
       iny
       iny
       dec tell2
       bne movl1
geton
       jsr slamsprites
       lda tell
       cmp #4
       bcs letsgo
       inc tell
       lda enemiesx
       sta tell2
       clc
       lda zp
       adc ganger
       sta zp
       lda zp+1
       adc #$00
       sta zp+1
       ldy #$00
       sty thiztel
       jmp movl1
slamngo
       jsr slamsprites
letsgo
       jmp clearobjtab
cinv1
       lda maxsprz
       cmp maxantal
       bcc inv1
       jmp slamngo

tell2  .byte $00
qtelt
       .byte 0,32,64,96,128
quptt  .byte 0,8,16,24
outta  .byte 0
gem6   .byte $00
gem7   .byte $00
movv2
       cmp #$7f
       beq movv1
       cmp #$70
       bcc nobj
       clc
       adc #$01
       sta (zp),y
       lda #$00
nobj
       ldx thiztel
       sta thiztab,x
       iny
       lda xcoor2
       sec
       sbc (zp),y
       bcc inv1
       cmp #12
       bcs inv1
       sta outta
       sta gem
       lda scroll1
       ldx tell
       clc
       adc qtelt,x
       ldx upt
       adc quptt,x
       ldx thiztel
       sta thizcy,x
       cmp #44
       bcs vvv
backer
       jmp inv1
vvv
       cmp #165
       bcs backer
       inc maxsprz
       sty gem6
       dec gem6
       iny
       lda (zp),y
       sta gem7
       and #%00111111
       sta gem3
       lda #11
       sec
       sbc gem
       asl a
       asl a
       asl a
       asl a
       clc
       asl a
       pha
       lda #$00
       adc #$00
       sta thizc1,x
       pla
       adc scroll2
       ldx lft
       adc quptt,x
       ldx thiztel
       sta thizc,x
       bcc nover
       inc thizc1,x
nover
       sec
       sbc gem3
       bcs nix
       dec thizc1,x
nix
       sta thizc,x
       sty gem5
       lda teler
       bne nope2
       dey
       dey
       jsr checkhit
       ldy gem5
       lda isnomore
       beq nope1
       dec isnomore
       jmp movv1
ak     .byte 0
nope1
       ldx thiztel
       lda att
       beq nope2
       dec att
       lda #%00001000
       sta ak
       lda thizc1,x
       bne tund
       lda thizc,x
       cmp xhag
       bcs tund
       lda (zp),y
       and #%10111111
       sta (zp),y
       jmp dexm
tund
       lda (zp),y
       ora #%01000000
       sta (zp),y
       jmp dexm
nope2
       ldx thiztel
       lda #$00
       sta ak
       lda gem7
       and #%10000000
       beq jdexm
       lda gem7
       and #%01000000
       sta thizret,x
       beq movri
       lda gem7
       and #%00011111
       clc
       adc #$01
       cmp #32
       beq nex1
       ora #%11000000
       sta (zp),y
       jmp dexm
nex1
       dey
       lda (zp),y
       iny
       iny
       cmp (zp),y
       bne deccp
       lda #%10011111
       dey
       sta (zp),y
       jmp dexm
deccp
       dey
       dey
       sec
       sbc #$01
       sta (zp),y
       iny
       lda #%11000000
       sta (zp),y
jdexm  jmp dexm
movri
       lda gem7
       and #%00011111
       sec
       sbc #$01
       bmi nex2
       ora #%10000000
       sta (zp),y
       jmp dexm
nex2
       dey
       lda (zp),y
       iny
       iny
       iny
       cmp (zp),y
       bne inccp
       lda #%11000000
       dey
       dey
       sta (zp),y
       jmp dexm
inccp
       dey
       dey
       dey
       lda (zp),y
       clc
       adc #$01
       sta (zp),y
       iny
       lda #%10011111
       sta (zp),y
       jmp dexm
dexm
       dey
       lda outta
       cmp #11
       bcc forget2
       jmp cinv1
forget2
       ldx thiztel
       lda thiztab,x
       cmp #12
       bcs coll
       iny
       lda (zp),y
       and #%01000000
       dey
       ora ak
       sta thizret,x
       inc thiztel
       jmp cinv1
coll
       lda #%01000000
       sta thizret,x
       inc thiztel
       jmp cinv1
skrid
       rts
jseck
       jmp seck
atctab .byte 0,0,0,0
mixed  .byte $00
atani  .byte 0
putspr
       lda objret
       and #%00001000
       sta atani
       lda objret
       and #%01000000
       sta objret
       ora objnr
       sta mixed
       ldx half
       bne jseck
       ldx objtel
       cmp objtab,x
       bne putter
       lda atani
       cmp atctab,x
       bne putter
       lda objnr
       asl a
       tax
       lda otab,x
       sta zp2
       lda otab+1,x
       sta zp2+1
       ldx objnr
       lda antab,x
       beq megaerror
       sta antspr
       clc
       adc sprfree
       cmp #5
       bcs pex1
       jmp putv1
pex1
       lda #$01
       sta half
       lda thizcy
       sec
       sbc #26
       cmp #88
       bcs opeex
       lda #88
opeex
       sta sprrast
       lda #$00
       sta noxrq
       rts
megaerror
       lda #$0d
       sta $d020
       rts
putter
       lda mixed
       sta objtab,x
       lda atani
       sta atctab,x
       lda objnr
       asl a
       tax
       lda otab,x
       sta zp2
       lda otab+1,x
       sta zp2+1
       ldx objnr
       lda antab,x
       beq megaerror
       sta antspr
       sta gem
       ldy #12
       lda objret
       bne nix3
       ldy #24
nix3
       lda atani
       beq noatt
       tya
       clc
       adc #24
       tay
noatt
       lda sprfree
       sta gem3
ploo2
       ldx gem3
       lda #$01
       sta animmell+4,x
       txa
       asl a
       asl a
       clc
       adc gem3
       tax
       lda (zp2),y
       sta anim4,x
       iny
       lda (zp2),y
       sta anim4+1,x
       iny
       lda (zp2),y
       sta anim4+2,x
       iny
       lda (zp2),y
       sta anim4+3,x
       iny
       inc gem3
       dec gem
       bne ploo2
putv1
       ldy #$03
       lda sprfree
       asl a
       sta gem
       lda antspr
       sta contspr
       lda zp2
       clc
       adc #$04
       sta zp3
       lda zp2+1
       sta zp3+1
       lda sprfree
       sta msprfree
putlp
       ldx sprfree
       lda objc+1
       sta overs1,x
       lda objret
       bne puller
       lda objc
       clc
       adc (zp2),y
       bcs ueber1
       jmp pulpv1
puller
       lda objc
       sec
       sbc (zp2),y
       cmp objc
       beq pulpv1
       bcs ueber2
       jmp pulpv1
ueber1
       inc overs1,x
       jmp pulpv1
ueber2
       pha
       lda overs1,x
       eor #$01
       sta overs1,x
       pla
pulpv1
       ldx gem
       sta sprpos+8,x
       lda objcy
       clc
       adc (zp3),y
       cmp #172
       bcc okay1
       lda #$00
okay1
       sta sprpos+9,x
       iny
       inc gem
       inc gem
       inc sprfree
       dec contspr
       bne putlp

       ldy #11
       lda (zp2),y
       ldx msprfree
       beq pex2
pl2
       asl a
       dex
       bne pl2
pex2
       ora multicol
       sta multicol
       inc objtel
       rts

gem2   .byte $00
oratab2
       .byte %00010000
       .byte %00100000
       .byte %01000000
       .byte %10000000
oratab1
       .byte %11101111
       .byte %11011111
       .byte %10111111
       .byte %01111111
msprfree .byte 0
contspr .byte 0
antspr .byte 0
objret .byte 0
sprfree .byte $00
sprfree2 .byte 0
gem    .byte 0
sprdbase .word $3e00
objnr  .byte 0
objc   .word $00
objcy  .byte 0
objtel .byte 0

objtel2 .byte 0

objtab .byte 0,0,0,0
objtab2 .byte 0,0,0,0

half   .byte $00
atttab2 .byte 0,0,0,0
lastpos .byte $00
stopspr .byte $00
cutit
       inc stopspr
       rts
seck
       ldx objnr
       lda antab,x
       beq mega2
       sta antspr
       clc
       adc sprfree2
       cmp #$05
       bcs cutit
       txa
       asl a
       tax
       lda otab,x
       sta zp2
       lda otab+1,x
       sta zp2+1
       lda mixed
       ldx objtel2
       cmp objtab2,x
       bne xputter
       lda atani
       cmp atttab2,x
       bne ind2
       jmp xputv1
mega2
       lda #$0a
       sta $d020
       rts
gem3
       .byte $00
gem4
       .byte $00

xputter

       lda mixed
       sta objtab2,x
ind2
       lda atani
       sta atttab2,x
       lda antspr
       sta gem
       ldy #12
       lda objret
       bne xnix3
       ldy #24
xnix3
       lda atani
       beq noatt2
       tya
       clc
       adc #24
       tay
noatt2
       lda sprfree2
       sta gem3
xploo2
       ldx gem3
       lda #$01
       sta animmell+8,x
       txa
       asl a
       asl a
       clc
       adc gem3
       tax
       lda (zp2),y
       sta anim1c,x
       iny
       lda (zp2),y
       sta anim1c+1,x
       iny
       lda (zp2),y
       sta anim1c+2,x
       iny
       lda (zp2),y
       sta anim1c+3,x
       iny
       inc gem3
       dec gem
       bne xploo2
xputv1
       ldy #$03
       lda sprfree2
       asl a
       sta gem
       lda antspr
       sta contspr
       lda zp2
       clc
       adc #$04
       sta zp3
       lda zp2+1
       sta zp3+1
       lda sprfree2
       sta msprfree
xputlp
       ldx sprfree2
       lda objc+1
       sta overs2,x
       lda objret
       bne xpul
       lda objc
       clc
       adc (zp2),y
       bcs xu1
       jmp xpulpv1
xpul
       lda objc
       sec
       sbc (zp2),y
       cmp objc
       beq xpulpv1
       bcs xu2
       jmp xpulpv1
xu1
       inc overs2,x
       jmp xpulpv1
xu2
       pha
       lda #$00
       sta overs2,x
       pla
xpulpv1
       ldx gem
       sta sprpos+16,x
       lda objcy
       clc
       adc (zp3),y
       cmp #172
       bcc xok
       lda #$00
xok
       sta sprpos+17,x
       iny
       inc gem
       inc gem
       inc sprfree2
       dec contspr
       bne xputlp
       ldy #11
       lda (zp2),y
       ldx msprfree
       beq xpex2
xpl2
       asl a
       dex
       bne xpl2
xpex2
       ora multicol2
       sta multicol2
       inc objtel2
       rts
overs1
       .byte 0,0,0,0
overs2
       .byte 0,0,0,0
ontab
       .byte %00001111
       .byte %00011111
       .byte %00111111
       .byte %01111111
       .byte %11111111
loadit
       sei
       lda #55
       sta $01
       lda #$00
       sta $d011
       sta $d01a
       sta $dc0e
       asl $d019
       sta scrpos
       sta scrpos+1
       lda #$01
       sta $dc0d
       lda #%00001110
       sta scrvect
       sta 53272
       lda #$01
       ldx #$08
       ldy #$00
       jsr filpar
       ldx level
       lda m1tab,x
       sta $d022
       lda m2tab,x
       sta $d023
       lda batab,x
       sta backcol
       lda endpostab,x
       sta ymax
       lda endupt,x
       sta upt
       lda level
       asl a
       clc
       adc #<nam1
       tax
       lda #>nam1
       adc #$00
       tay
       lda #$02
       jsr filnam
       lda #$00
       sta $d020
       lda #$00
       ldx #$00
       ldy #$40
       jsr load
       sei
       nop
       nop
       nop
       sei
slamcol
       ldx #0
slamcloop
       lda $4280,x
       sta $d800,x
       lda $4280+160,x
       sta $d800+160,x
       lda $4280+320,x
       sta $d800+320,x
       lda $4280+480,x
       sta $d800+480,x
       inx
       cpx #160
       bne slamcloop
       lda $d011
       bpl *-3
       lda $d011
       bmi *-3
       lda #174
wwwww
       cmp $d012
       bne wwwww
       lda #%01001001
       sta $dc0e
       lda #$1b
       sta $d011
       lda #$81
       sta $dc0d
       lda #$01
       sta $d01a
       lda #$35
       sta $01
       cli
       rts
chx3
       lda thizc,x
       clc
       adc #20
       cmp sprpos+6
       bcc jbbk
       rts
jbbk   jmp bbk
       *= $0a82
chflyv
       lda flweap
       beq chex
       lda thiztab,x
       cmp #14
       bcs chex
       lda swover
       lsr a
       lsr a
       lsr a
       cmp thizc1,x
       bne chex
       lda sprpos+6
       sec
       sbc #20
       cmp thizc,x
       bcs chex3
bbk
       clc
       lda thizc,x
       sec
       sbc #$20
       cmp sprpos+6
       bcs chex2
ddd
       lda #$00
       sta flweap
       sta swover
       jmp killem
chex
       rts
chex3  jmp chx3
chex2
       lda sprpos+6
       clc
       adc #20
       cmp thizc,x
       bcs ddd
       rts
putsword
       lda #$ff
       sta 53269
       sta 53248+28
       lda #%00000100
       sta 53248+27
       lda #214
       sta $d001
       sta $d003
       sta $d005
       sta $d007
       sta $d009
       sta $d00b
       lda #$09
       sta $d027
       sta $d028
       lda #11
       sta $d029
       sta $d02a
       sta $d02b
       sta $d02c
       lda swcoors
       sta $d000
       lda swcoors+1
       sta $d002
       lda swcoors+2
       sta $d004
       lda swcoors+3
       sta $d006
       lda swcoors+4
       sta $d008
       lda swcoors+5
       sta $d00a
       rts
initsword
       ldx #152
       stx $4bf8
       inx
       stx $4bf9
       stx $4bfa
       inx
       stx $4bfb
       inx
       stx $4bfc
       inx
       stx $4bfd
       rts
swcoors
       .byte 125,149,139,173,197,221
clearobjtab
       lda #$00
       ldx objtel
       cpx #$03
       beq clov1
cvol1
       sta objtab,x
       inx
       cpx #$03
       bne cvol1
clov1
       ldx objtel2
       cpx #$03
       beq clov2
cvol2
       sta objtab2,x
       inx
       cpx #$03
       bne cvol2
clov2
       clc
       lda overs1+3
       asl a
       adc overs1+2
       asl a
       adc overs1+1
       asl a
       adc overs1
       asl a
       asl a
       asl a
       asl a
       sta xover
       clc
       lda overs2+3
       asl a
       adc overs2+2
       asl a
       adc overs2+1
       asl a
       adc overs2
       asl a
       asl a
       asl a
       asl a
       sta xover2
       ldx sprfree
       lda ontab,x
       sta on
       ldx sprfree2
       lda ontab,x
       sta on2
       rts
putpoints
       ldy #$01
       lda points
       jsr point2
       ldy #$03
       lda points+1
       jsr point2
       lda points+2
       ldy #$05
       jsr point2
       lda profit
       ldy #21
       jsr point2
       lda profit+1
       ldy #23
       jsr point2
       lda profit+2
       ldy #25
       jmp point2
point2
       pha
       and #%11110000
       lsr a
       lsr a
       lsr a
       lsr a
       clc
       adc #$a0
       sta $4800+650,y
       pla
       and #%00001111
       clc
       adc #$a0
       sta $4800+651,y
       rts
degy
       dec energy
calcsw
       ldx #$00
       lda energy
       cmp #$13
       bcc ol4
       cmp #94
       bcc ol3
ol4
       lda #$00
       sta energy
ol3
       clc
       adc #149-93
ol
       clc
       adc #24
       cmp #149
       bcs ol2
       pha
       lda #0
       sta swcoors+3,x
       pla
       inx
       cpx #3
       bne ol
       rts
ol2
       sta swcoors+3,x
       inx
       cpx #3
       bne ol
       rts
antab
       .byte 1
       .byte 1,1,2,3,1,1,1,2
       .byte 3,3,3,1,1

       .byte 1,1,1,1,1,1,1,1,1
       .byte 1,1,1,1,1,1,1,1,1
       .byte 1,1,1,1,1,1,1,1,1
points
       .byte $00,$00,$00
profit .byte $00,$00,$00

thiztab
       .byte 0,0,0,0,0,0,0,0
thizc
       .byte 0,0,0,0,0,0,0,0
thizc1
       .byte 0,0,0,0,0,0,0,0
thizcy
       .byte 0,0,0,0,0,0,0,0
thizret
       .byte 0,0,0,0,0,0,0,0
thiztel .byte $00
gemmer .word $00
sprrast .byte 130
doatttab
       .byte 0,0,0,0,1
       .byte 0,0,0,0,1
       .byte 1,1,0,0,0
       .byte 0,0,0,0,0
       .byte 0,0,0,0,0
       .byte 0,0,0,0,0
       .byte 0,0,0,0,0
       .byte 0,0,0,0,0
pointtab
       .word $00
       .word $0100
       .word $0200
       .word $0500
       .word $1100
       .word $0400
       .word $0200
       .word $0225
       .word $0400
       .word $1200
       .word $0800
       .word $1000
       .word $0700
       .word $0500
       .word $50
       .word $20
       .word $35
       .word $25
       .word $25
       .word $15
       .word $20
       .word $30
       .word $35
       .word $25
       .word $20
       .word $10
       .word $20
       .word $15
       .word $45
       .word $50
       .word $30
       .word $40
       .word $45
       .word $10
       .word $10
       .word $80
       .word $95
       .word $0300
       .word $0400
       *= $0d00
quickmult
       .word 0
       .word 1*48
       .word 2*48
       .word 3*48
       .word 4*48
       .word 5*48
       .word 6*48
       .word 7*48
       .word 8*48
       .word 9*48
       .word 10*48
       .word 11*48
       .word 12*48
       .word 13*48
       .word 14*48
       .word 15*48
       .word 16*48
       .word 17*48
       .word 18*48
endpostab
       .byte 147
       .byte 155
       .byte 150
       .byte 164
       .byte 150
       .byte 146
       .byte 146
       .byte 150
endupt
       .byte 0,0,0,0,0,0,0,0
m1tab
       .byte 9,9,9,9
       .byte 9,11,11,11
m2tab
       .byte 0,0,8,0
       .byte 0,12,12,12
nam1   .text "e1"
nam2   .text "e2"
nam3   .text "e3"
nam4   .text "e4"
nam5   .text "e5"
nam6   .text "e6"
nam7   .text "e7"
nam8   .text "e8"
batab
       .byte 6,6,0,6
       .byte 6,0,0,0
       *= $0f80
sprpos
       .word $00,0,0,0,0,0,0,0
       .word $00,0,0,0
sprcols
       .word $00,0,0,0
       .word $00,0
sprreg
       .word $00,0,0,0
       .word $00,0
on
       .byte 0
on2
       .byte 0
haover .byte 0
xhag
       .byte 180
yhag   .byte 60
sw
       .byte 0
plsw
       .byte 9,21
mcc    .byte 8,2
anim0
       .byte 0,0,0,0,1
anim1
       .byte 0,0,0,0,1
anim2
       .byte 0,0,0,0,1
anim3
       .byte 0,0,0,0,1
anim4
       .byte 0,0,0,0,1
       .byte 0,0,0,0,1
       .byte 0,0,0,0,1
       .byte 0,0,0,0,1
anim1c
       .byte 0,0,0,0,1
       .byte 0,0,0,0,1
       .byte 0,0,0,0,1
       .byte 0,0,0,0,1

energy .byte 93
action .byte $00
vej    .byte 1
joy    .byte 0
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
pakker .byte $01
knive  .byte $10
spyd   .byte $05
axes   .byte $05
kugler .byte $02
bomber .byte $01
swover .byte $00
flweap .byte $00
megabomb .byte $00
lives  .byte $04
dying  .byte $00
undead .byte $00
enemiesx .byte $08
ganger .byte 48
key    .byte $00
spctab .byte 14,15,16,17
gottem .byte 0,0,0,0
stop   .byte $00
keinspr .byte $00
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
level  .byte $07
backcol .byte $06
maxantal .byte $03
maxup  .byte $f5
