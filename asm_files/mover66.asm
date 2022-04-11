
         *= $2400-3
         jmp $19fd
start    = $1000
getscr   = $1003
getscll  = $1006
getstop  = $1009
getextra = $100c
calcsw   = $1a09+3
loadit   = $1a00+24
chsfx    = $7006
zp       = $30
zp2      = $32

         jmp doitall
         jmp flytd2
         jmp doit2
         jmp resetspr
         jmp doitsmall
         jmp plotweap
doitsmall
         sty qgem
         jsr animation
         jsr flytdatas
         ldy qgem
         rts
shopper
         lda backcol
         sta $d021
         rts
qgem     .byte $00
doitall
         lda shop
         bne shopper
         lda doneit
         bne dd2
         jsr doitsmall
dd2
         jsr getjoy
         lda undead
         and #$03
         tax
         lda udtab,x
         sta sprcols+2
         lda noxrq
         beq gemdat
         rts
gemdat
         jmp makebuffer
udtab    .byte 9,8,7,8

doit2
         lda #$00
         sta sup
         sta sdw
         sta sle
         sta sri
         lda teler
         bne dotele
         lda dying
         beq live
         jmp movehagar
live
         jsr contunder
         lda #$02
         jsr movehagar
         lda undead
         beq nodec
         dec undead
         lda #93
         sta energy
nodec
         lda flweap
         bne movweapons
         lda vej
         and #$03
         tax
         dex
         lda swtab,x
         sta sprreg+3
         jsr scankeyz
         jsr chfire
         jmp conthag
swtab    .byte 114,115
movweapons
         jsr movefl
         jmp conthag
gemp
         .word $00
nodeal
         rts
dotele
         jmp teling
screenbase
         .word $4000,$4400
getjoy
         lda $dc00
         sta joy
         and #%00010000
         sta fire
         lda joy
         and #%00001000
         sta right
         lda joy
         and #%00000100
         sta left
         lda joy
         and #%00000010
         sta down
         lda joy
         and #%00000001
         sta up
         rts
fire     .byte 0
up       .byte 0
down     .byte 0
left     .byte 0
right    .byte 0
scpv     .byte $43,$47
flytdatas
         lda backcol
         sta $d021
         ldx #$0f
fltloop1
         lda sprpos,x
         sta $d000,x
         dex
         bpl fltloop1
         ldx scrpos
         lda #$f8
         sta zp
         lda scpv,x
         sta zp+1
         ldy #$07
fltloop2
         lda sprcols,y
         sta $d027,y
         lda sprreg,y
         sta (zp),y
         dey
         bpl fltloop2

         lda xover
         ora haover
         ora swover
         sta $d010
         lda multicol
         sta 53248+28
         lda on
         and hagon
         sta 53248+21
         lda #$00
         sta 53248+27
         rts
flytd2
         lda pbuff
         sta $d008
         lda pbuff+1
         sta $d009
         lda pbuff+2
         sta $d00a
         lda pbuff+3
         sta $d00b
         lda pbuff+4
         sta $d00c
         lda pbuff+5
         sta $d00d
         lda pbuff+6
         sta $d00e
         lda pbuff+7
         sta $d00f
         ldx scrpos
         lda #$f8+4
         sta $39
         lda scpv,x
         sta $3a
         ldy #$03
flt2
         lda cbuff,y
         sta $d027+4,y
         lda rbuff,y
         sta ($39),y
         dey
         bpl flt2
         lda bxover2
         ora haover
         ora swover
         sta $d010
         lda bmul
         sta 53248+28
         lda bon2
         and hagon
         sta 53248+21
         rts
hagon    .byte $ff
dead
         dec dying
         beq setagain
         rts
setagain
         lda lives
         beq toobad
         sed
         sec
         lda lives
         sbc #$01
         sta lives
         cld
         ldx #$3f
         jsr plotnum
         lda #200
         sta undead
         lda #$01
         sta duk
         lda #93
         sta energy
         jmp calcsw
animexit
         rts
toobad
         lda #$01
         sta stop
         rts
animation
         ldx #256-1
         ldy #256-5
animloop1
         cpx #11
         beq animexit
         iny
         iny
         iny
         iny
         iny
         inx
animstart
         lda anim0+4,y
         beq animloop1
         dec animmell,x
         bne animloop1
         lda anim0+2,y
         sta animmell,x
         lda sprreg,x
         cmp anim0+1,y
         bcs animv2
         cmp anim0,y
         bcc animv2
         inc sprreg,x
         jmp animfarv
animv2
         lda anim0,y
         sta sprreg,x
animfarv
         lda anim0+3,y
         sta sprcols,x
         jmp animloop1
ha1
         .byte 106,107,5,0,1
         .byte 108,109,5,2,1
         .byte 96,100,4,9,1
ha2
         .byte 110,111,5,0,1
         .byte 112,113,5,2,1
         .byte 101,105,4,9,1
jumha1
         .byte 146,146,5,0,1
         .byte 147,147,5,2,1
         .byte 150,150,4,9,1
jumha2
         .byte 148,148,5,0,1
         .byte 149,149,5,2,1
         .byte 151,151,4,9,1

swt      .byte 0
swn      .byte 0
megapower
         sta buildup
         sta $4ae2
         sta $4ae3
         sta $4ae4
         sta $4ae5
         sta $4ae6
         lda #$10
         sta swordpower
         jmp setup
chfire
         lda fire
         beq afire
         lda #$00
         ldx buildup
         beq nomcl
         cpx #64
         bcs megapower
         sta $4ae2
         sta $4ae3
         sta $4ae4
         sta $4ae5
         sta buildup
nomcl
         sta sw
         sta swn
         lda flweap
         bne noreset
         lda #$01
         sta swordpower
noreset
         rts
afire
         lda swn
         beq setup
         lda swt
         beq qn
qn2
         lda #$01
         sta sw
         dec swt
         rts
setup
         lda #5
         sta swt
         sta swn
         lda #$02
         jsr chsfx
         jmp qn2
qn
         lda #$00
         sta sw
         lda buildup
         cmp #64
         bcs firex
         inc buildup
         lda buildup
firex
         lsr a
         lsr a
         lsr a
         lsr a
         tax
         lda #$99
         sta $4ae2,x
         rts
buildup  .byte $00
conthag
         lda dying
         beq notd
         rts
notd
         lda haover
         bne ctv1
         lda xhag
         cmp #40
         bcs ctv2
         lda #40
         sta xhag
         jmp ctv2
ctv1
         lda xhag
         cmp #60
         bcc ctv2
         lda #60
         sta xhag
ctv2
         lda xhag
         sta sprpos
         sta sprpos+2
         sta sprpos+4
         lda yhag
         pha
         ldx hop
         beq ctv3
         sec
         sbc #$02
ctv3
         ldx duk
         beq f2
         clc
         adc #3
f2
         sta sprpos+1
         sta sprpos+3
         pla
         clc
         adc #13
         sta sprpos+5
         ldx flweap
         bne excont
         ldx duk
         beq f3
         clc
         adc #5
f3
         sec
         sbc #5
         sta sprpos+7
         ldx sw
         lda xhag
         clc
         adc plsw,x
         sta sprpos+6
excont
         rts
jump     .byte 0
jumptel  .byte 0
jmphi    .byte 18
pvej     .byte 0
hop      .byte 0
hoptel   .byte 0
cutit1
         rts
jmovhgv1
         jmp movhgv1
sit
         lda hop
         clc
         adc air
         bne getgoing
         lda #$01
         sta duk
         jsr chtele
         lda teler
         bne cutit1

         lda vej
         and #$7f
         cmp #$01
         beq allright

         lda #162
         sta anim2
         sta anim2+1
         sta sprreg+2
         jmp exmovhg
allright
         lda #161
         sta anim2
         sta anim2+1
         sta sprreg+2
         jmp exmovhg
dodead
         lda air
         bne frtz2
         jmp killim
movehagar
         lda dying
         beq fortz
         jmp dead
fortz
         lda energy
         beq dodead
frtz2
         lda down
         beq sit
getgoing
         lda duk
         bne f1
         lda right
         bne jmovhgv1
         jmp f5
f1
         lda vej
         and #$7f
         cmp #$02
         beq jmovhgv1
         jmp f6
f5
         lda vej
         cmp #$01
         beq mo3
f6
         lda #$00
         sta duk
         jsr putan1
         jmp mo3
putan1
         ldy #$00
         sty hop
         ldx #$00
         lda air
         beq moloop1
         ldx #30
         stx hop
moloop1
         lda ha1,x
         sta anim0,y
         inx
         iny
         cpy #15
         bne moloop1
         lda #21
         sta plsw+1
         lda #5
         sta plsw
         jsr resetspr
         lda #$01
         sta vej
         rts
mo3
         lda onlr+1
         beq ex3
         lda xhag
         cmp xmax
         bne mov3
         lda #$01
         sta sle
ex3
         jmp exmovhg
mov3
         clc
         adc #$02
         beq mo1
         sta xhag
         jmp exmovhg
mo1
         sta xhag
         clc
         lda haover
         eor #%00001111
         sta haover
         jmp exmovhg
null
         lda jump
         bne why1
         jsr clearanim
why1
         jmp exmovhg
movhgv1
         lda duk
         bne f4
         lda left
         bne null

         lda vej
         cmp #$02
         beq mo4
f4
         lda #$00
         sta duk
         jsr putan2
         jmp mo4
putan2
         ldy #$00
         sty hop
         ldx #$00
         lda air
         beq moloop2
         ldx #30
         stx hop
moloop2
         lda ha2,x
         sta anim0,y
         inx
         iny
         cpy #15
         bne moloop2
         lda #256-21
         sta plsw+1
         lda #256-5
         sta plsw
         jsr resetspr
         lda #$02
         sta vej
         rts
mo4
         lda onlr
         beq exmovhg
         lda xhag
         cmp xmin
         bne mov4
         ldx xcoor
         cpx #$00
         beq mov4
         lda #$01
         sta sri
         jmp exmovhg
mov4
         lda xhag
         sec
         sbc #$02
         sta xhag
         bcs exmovhg
         lda haover
         eor #$0f
         sta haover
exmovhg
         lda #$01
         sta air
         lda jump
         bne ejump
         lda onground
         beq exmov1
         lda hop
         bne em4
         lda #$00
         sta duk
         lda vej
         and #%01111111
         cmp #1
         bne em5
         jsr putan1
         jmp em4
em5
         jsr putan2
em4
         lda yhag
         cmp ymax
         bcc em1
em2
         lda #$01
         sta sup
         rts
em1
         inc yhag
         lda yhag
         cmp ymax
         bcs em2
         inc yhag
         rts
jstjump  jmp stjump
exmov1
         lda #$00
         sta air
         lda up
         beq jstjump
         lda hop
         beq ex7
inhop
         lda vej
         and #%01111111
         cmp #$01
         bne em3
         jsr putan1
ex7
         rts
em3
         jsr putan2
         jmp ex7
jend3    jmp endjump3
ejump
         dec jumptel
         beq jend3
backend2
         lda doend
         bne quite
         lda xhag
         clc
         adc #$08
         sec
         sbc scroll1
         sta chx
         lda yhag
         sec
         sbc scroll2
         clc
         adc #$04
         sta chy
         lda haover
         sta chover
         jsr setbox1
         lda charunder1
         cmp #$c0
         bcc quite
         cmp maxup
         bcs quite
         cmp #$cc
         bcc jend
         cmp #$dd
         bcc quite
         jmp jend
quite
         lda yhag
         cmp ymin
         bcs ejump2
         lda ycoor
         bne qn1
         lda upt
         cmp #$03
         bne qn1
         jmp ejump2
qn1
         lda doend
         bne norex
         lda #$01
         sta sdw
norex
         rts
ejump2
         dec yhag
         lda yhag
         cmp ymin
         bne ejump3
         lda ycoor
         bne qn1
         lda upt
         cmp #$03
         bne qn1
         jmp ejump3
         lda #$01
         sta sdw
         rts
jend     jmp endjump
ejump3
         lda yhag
         cmp #10
         bcc nojump
         dec yhag
         rts
nojump
         lda #10
         sta yhag
noj2
         rts
stjump
         lda energy
         beq noj2
         lda #$01
         sta jump
         lda jmphi
         sta jumptel
         lda #$09
         jsr chsfx
         lda #$01
         sta air
         lda undead
         beq normhop
         lda #$05
         sta hoptel
         jmp inhop
normhop
         lda #$03
         sta hoptel
         jmp inhop
endjump3
         dec hoptel
         beq endjump
         lda up
         bne endjump
         lda jmphi
         lsr a
         sta jumptel
         jmp backend2
endjump
         lda #$00
         sta jump
ex6
         rts
resetspr
         lda anim0
         sta sprreg
         lda anim1
         sta sprreg+1
         lda anim2
         sta sprreg+2
         rts
clearanim
         lda #$00
         sta anim0+4
         sta anim1+4
         sta anim2+4
         lda vej
         and #$7f
         cmp #$02
         beq onway
         pha
         lda #97
bakreal
         sta sprreg+2
         pla
         ora #%10000000
         sta vej
         rts
onway
         pha
         lda #102
         jmp bakreal
chx      .byte 0
chy      .byte 0
chover   .byte 0
boxxcoor .byte 0
boxycoor .byte 0
air      .byte 0
setbox1
         lda chx
         lsr a
         lsr a
         lsr a
         sta boxxcoor
         lda chy
         lsr a
         lsr a
         lsr a
         sta boxycoor
fixboxcoors
         lda boxycoor
         sec
         sbc #6
         sta boxycoor
         lda chover
         beq fixbxexit
         lda boxxcoor
         clc
         adc #32
         sta boxxcoor
fixbxexit
         lda boxxcoor
         sec
         sbc #3
         sta boxxcoor
getcharbx
         lda scrpos
         asl a
         tax
         lda screenbase,x
         sta zp
         lda screenbase+1,x
         sta zp+1
         ldy boxycoor
         beq gcbv1
         cpy #20
         bcs gcbv1
gcbloop1
         lda zp
         clc
         adc #40
         sta zp
         lda zp+1
         adc #$00
         sta zp+1
         dey
         bne gcbloop1
gcbv1
         ldy boxxcoor
         lda (zp),y
         sta charunder1
         rts
contunder
         lda yhag
         cmp #25
         bcs ingenko
         lda #25
         sta yhag
ingenko
         cmp lastyhag
         beq sync
norm
         lda #$02
         sta ready
         lda #$00
         sta ok
n2
         jsr checkunder
         rts
sync
         lda onground
         bne norm
         lda ready
         cmp #$01
         beq n3
         lda #$01
         sta ready
         jmp n2
n3
         lda ok
         bne n2
         dec yhag
         jsr checkunder
         lda onground
         beq fine
         inc yhag
         jsr checkunder
         lda #$01
         sta ok
fine
         rts
ok       .byte $00
ready    .byte 0
charunder1 .byte 0,0
charunder2 .byte 0,0,0
onlr     .byte 0,0
onground .byte 0
lastyhag .byte 0
speccalc
         lda yhag
         cmp #120
         bcc inair
         lda #$01
         sta onlr
         sta onlr+1
         lda #$00
         sta onground
         jmp challd
inair
         lda #$01
         sta onlr
         sta onlr+1
         sta onground
         rts
checkunder
         lda doend
         bne speccalc
         lda xhag
         sec
         sbc scroll2
         sta chx
         lda yhag
         clc
         adc #27
         sec
         sbc scroll1
         sta chy
         lda haover
         sta chover
         jsr setbox1
         iny
         lda (zp),y
         sta chdang
         sty gem
         iny
         iny
         lda (zp),y
         sta charunder1+1
         tya
         clc
         adc #38
         tay
         lda (zp),y
         sta charunder2
         jsr checkgr
         lda yhag
         sta lastyhag
         rts
checkgr
         ldx #$00
         lda #$01
         sta onlr
         sta onlr+1
         sta onground
cg
         lda charunder1,x
         cmp #$c0
         bcs ongr
ex
         inx
         cpx #$03
         bne cg
         lda charunder2
         cmp #$01
         beq dowat
         lda #$00
         sta allwat
         jmp nosfx
dowat
         lda allwat
         bne nosfx
         lda #$01
         sta allwat
         lda #$05
         jsr chsfx
nosfx
         lda chdang
         cmp #$b0
         bcc ex11
         cmp #$bc
         bcs ex11
degy
         dec energy
         jmp calcsw
allwat   .byte $00
ex11
         cmp #$01
         bne vx
         lda undead
         bne vx
         sec
         lda zp
         sbc #80
         sta zp
         lda zp+1
         sbc #$00
         sta zp+1
         ldy gem
         lda (zp),y
         cmp #1
         bne vx
         lda #$00
         sta energy
vx
         rts
chdang   .byte 0
ongr
         lda #$00
         sta onlr,x
         jmp ex
makebuffer
         lda sprpos+16
         sta pbuff
         lda sprpos+17
         sta pbuff+1
         lda sprpos+18
         sta pbuff+2
         lda sprpos+19
         sta pbuff+3
         lda sprpos+20
         sta pbuff+4
         lda sprpos+21
         sta pbuff+5
         lda sprpos+22
         sta pbuff+6
         lda sprpos+23
         sta pbuff+7
         lda sprreg+8
         sta rbuff
         lda sprreg+9
         sta rbuff+1
         lda sprreg+10
         sta rbuff+2
         lda sprreg+11
         sta rbuff+3
         lda sprcols+8
         sta cbuff
         lda sprcols+9
         sta cbuff+1
         lda sprcols+10
         sta cbuff+2
         lda sprcols+11
         sta cbuff+3
         lda multicol2
         sta bmul
         lda xover2
         sta bxover2
         lda on2
         sta bon2
         rts
starttav
         lda #$01
         sta shop
         sta tav
         sta teler
         jmp setuptav
startshop
         lda #$01
         sta shop
         sta teler
         jmp setupshop
chshy
         lda rycoor
         cmp shoptab+1,x
         beq startshop
         lda rxcoor
         jmp bak
chtvy
         lda rycoor
         cmp tavtab+1,x
         beq starttav
         lda rxcoor
         jmp bak2
chshop
         lda rxcoor
         ldx #$00
         cmp shoptab,x
         beq chshy
bak
         cmp tavtab,x
         beq chtvy
bak2
         inx
         inx
         cmp shoptab,x
         beq chshy
         cmp tavtab,x
         beq chtvy
         rts
sekend
         lda rycoor
         cmp endtab+1
         bne bakkaend
         jmp finishit
chtele
         lda key
         beq ikketele
         jsr calcrcoor
         jsr printpos
         lda rxcoor
         cmp endtab
         beq sekend
bakkaend
         ldx #$00
         lda antele
         sta gem
         lda rxcoor
teloop1
         cmp teletab,x
         beq chtey
telev1
         inx
         inx
         inx
         inx
         dec gem
         bne teloop1
         jmp chshop
ikketele
         rts
chtey
         lda rycoor
         cmp teletab+1,x
         beq sttele
         lda rxcoor
         jmp telev1
sttele
         lda #160
         sta xhag
         lda #80
         sta yhag
         lda #%11110000
         sta hagon
         lda #$01
         sta teler
         lda teletab+2,x
         sta whereto
         stx gem
         cmp #5
         bcs noneed
         ldx whereto
         lda whtab,x
         sta xhag
noneed
         ldx gem
         lda teletab+3,x
         sta whereto+1
         lda #$01
         sta hyperspeed
         lda #$07
         jsr chsfx
         rts
whereto  .byte 0,0
jmpshop
         jmp contshop
teling
         lda shop
         bne jmpshop
         jsr calcrcoor
         lda rycoor
         cmp whereto+1
         beq gox
         bcc undery
         lda #$01
         sta sdw
         rts
undery
         lda #$01
         sta sup
         rts
gox
         lda rxcoor
         cmp whereto
         beq telefin
         bcc underx
         lda #$01
         sta sri
         rts
underx
         lda #$01
         sta sle
         rts
telefin
         lda #$00
         sta teler
         sta nospr
         sta hyperspeed
         lda #$ff
         sta hagon
         lda #$08
         jsr chsfx
         rts
printpos
         jsr calcrcoor
         ldy #$00
         lda rxcoor
         pha
         and #%11110000
         lsr a
         lsr a
         lsr a
         lsr a
         jsr plott
         pla
         and #%00001111
         jsr plott
         iny
         lda rycoor
         pha
         and #%11110000
         lsr a
         lsr a
         lsr a
         lsr a
         jsr plott
         pla
         and #%00001111
         jsr plott
         ldy #20
         lda scroll1
         jmp plott

plott
         tax
         lda hextab,x
         sta $4a92,y
         iny
         rts
hextab
         .byte $a0,$a1,$a2,$a3,$a4
         .byte $a5,$a6,$a7,$a8,$a9
         .byte $80,$81,$82,$83,$84
         .byte $85,$86
gem      .byte $00
whtab
         .byte 25,32,64,96,128
calcrcoor
         lda lft
         asl a
         asl a
         asl a
         sta gem
         lda xhag
         clc
         adc scroll2
         sec
         sbc gem
         clc
         lsr a
         lsr a
         lsr a
         lsr a
         lsr a
         clc
         adc xcoor
         sta rxcoor

         lda upt
         asl a
         asl a
         asl a
         sta gem
         lda yhag
         clc
         adc scroll1
         sec
         sbc gem
         clc
         lsr a
         lsr a
         lsr a
         lsr a
         lsr a
         clc
         adc ycoor
         sta rycoor
         rts
keyw     .byte 10
pause
         lda #$00
         sta sup
         sta sdw
         sta sle
         sta sri
ploop
         lda $dc01
         cmp #251
         beq ploop
         rts
scankeyz
         lda keyw
         beq scv
         dec keyw
         rts
scv
         lda #$00
         sta $dc00
         lda $dc01
         cmp #$ff
         beq exscan
         sta gem
         lda #$fe
         sta $dc00
         lda $dc01
         cmp gem
         bne exscan
         ldx #10
         stx keyw
         cmp #$fd
         beq ret
         cmp #$ef
         beq kf1
         cmp #$df
         beq jkf3
         cmp #$bf
         beq jkf5
         cmp #$f7
         beq jkf7
exscan
         lda #$7f
         sta $dc00
         lda $dc01
         cmp #$ef
         beq spacy

         cmp #253
         bne nobreak
         lda up
         beq nobreak
         lda #$01
         sta stop
nobreak
         cmp #251
         beq pause
         rts
spacy
         lda up
         beq nobreak
         lda bomber
         beq nobreak
         ldx #10
         stx keyw
         sed
         sec
         lda bomber
         sbc #$01
         sta bomber
         cld
         inc megabomb
         ldx #$1d
         jmp plotnum
jkf3
         jmp kf3
jkf5
         jmp kf5
jkf7
         jmp kf7
ret
         lda pakker
         beq exscan
         ldx #93
         stx energy
         sed
         sec
         sbc #$01
         sta pakker
         cld
         ldx #$1d+3
         jsr plotnum
         jsr calcsw
         jmp exscan
kf1
         lda knive
         beq exscan
         sed
         sec
         sbc #$01
         sta knive
         cld
         lda #$01
         jsr startfly
         ldx #$00
         lda knive
         jsr plotnum
         jmp exscan
kf3
         lda spyd
         beq exs2
         sed
         sec
         sbc #$01
         sta spyd
         cld
         lda #$02
         jsr startfly
         ldx #$03
         lda spyd
         jsr plotnum
         jmp exscan

kf5
         lda axes
         beq exs2
         sed
         sec
         sbc #$01
         sta axes
         cld
         lda #$03
         jsr startfly
         lda axes
         ldx #$06
         jsr plotnum
exs2
         jmp exscan

kf7
         lda kugler
         beq exs2
         sed
         sec
         sbc #$01
         sta kugler
         cld
         lda #$04
         jsr startfly
         lda kugler
         ldx #$1a
         jsr plotnum
         jmp exscan
plotnum
         pha
         and #%00001111
         clc
         adc #$a0
         sta $4ad4,x
         pla
         and #%11110000
         lsr a
         lsr a
         lsr a
         lsr a
         clc
         adc #$a0
         sta $4ad3,x
         rts
startfly
         sta flweap
         nop
         nop
         nop
         nop
         nop
         lda vej
         and #%00000011
         sec
         sbc #$01
         sta flvej
         asl a
         asl a
         clc
         adc flweap
         tax
         lda weaptab,x
         sta sprreg+3
         ldx flweap
         lda weaptabc,x
         sta sprcols+3
         lda skade,x
         sta swordpower
         rts
skade
         .byte 1,4,8,6,16
weaptab
         .byte 0,116,118,120,174
wt2
         .byte 117,119,121,174
weaptabc
         .byte 0,9,9,9,7
movefl
         lda flvej
         bne decfl
         lda swover
         and #%00001000
         beq incfl
         lda sprpos+6
         cmp #65
         bcs stopfl
incfl
         lda sprpos+6
         clc
         adc #15
         sta sprpos+6
         bcc notover
         lda swover
         ora #%00001000
         sta swover
notover
         rts
decfl
         lda sprpos+6
         cmp #25
         bcc stopfl
         sec
         sbc #15
         sta sprpos+6
         rts
stopfl
         lda #$00
         sta flweap
         sta swover
         lda #10
         sta sprcols+3
         rts
flvej    .byte $00
rxcoor   .byte $00
rycoor   .byte $00
hyperspeed = $0d80
animant  .byte 20
         *= $0e20
killim
         sta sprpos+7
         lda #131
         sta sprreg+2
         sta anim2
         sta anim2+1
         lda #200
         sta dying
         lda sprpos+5
         sec
         sbc #7
         sta sprpos+1
         sta sprpos+3
         ldx #9
killoop
         lda ha1,x
         sta anim0,x
         dex
         bpl killoop
         lda #$06
         jsr chsfx
         rts
plotweap
         lda lives
         ldx #$3f
         jsr plotnum
         lda knive
         ldx #0
         jsr plotnum
         lda spyd
         ldx #3
         jsr plotnum
         lda axes
         ldx #6
         jsr plotnum
         lda kugler
         ldx #$1a
         jsr plotnum
         lda pakker
         ldx #$1d+3
         jsr plotnum
         lda bomber
         ldx #$1d
         jmp plotnum
finishit
         lda #$01
         sta doend
         lda #150
         sta ymax
         lda #255
         sta xmax
         lda #35
         sta xmin
         lda #$a0
         sta xcoor
         lda #$00
         sta ycoor
         lda #$00
         sta scroll10
         sta scroll20
         sta upt
         sta lft
         lda #50
         sta final
         lda #4
         sta maxantal
         jmp loadit
challd
         lda endgegner
         bne callx
         dec final
         bne callx
         lda #$01
         sta stop
         sta rightend
callx
         rts
final    .byte $00
         *= $4720
endtab   .byte 6,7
shoptab  .byte 8,4
         .byte 8,4
         .byte 0,0,0,0
tavtab
         .byte 6,4
         .byte 6,4
         .byte 0,0,0,0
antele
         .byte $04
teletab
         .byte $16,$04,$32,$04
         .byte $32,$04,$15,$01
         .byte $33,$04,$16,$04
         .byte $04,$04,$16,$04
         *= $3d00
shtv     = $6800
setupshop
         lda #$01
         sta keinspr
         jsr shtv
         lda #$00
         ldx energy
         jsr shtv+12
         jmp shtv+18
contshop
         lda tav
         bne conttav
         lda $dc00
         and #%00010000
         bne nshop
         lda #$00
         sta shop
         sta teler
         lda #15
         sta 53248+38
         jsr shtv+3
         lda #$00
         sta keinspr
         rts
nshop
         lda #27
         sta 53265
         lda #88
         sta 53270
         jsr plotweap
         jmp shtv+24
setuptav
         lda #$01
         sta keinspr
         jsr shtv
         lda #$01
         ldx energy
         jsr shtv+12
         jmp shtv+15
conttav
         lda $dc00
         and #%00010000
         bne ntav
         lda #$00
         sta shop
         sta tav
         sta teler
         lda #15
         sta 53248+38
         jsr shtv+3
         lda #$00
         sta keinspr
         rts
ntav
         lda #27
         sta 53265
         lda #16
         sta 53270
         jsr plotweap
         jsr shtv+27
         sta energy
         jsr calcsw
         jmp shtv+21
shop     .byte $00
tav      .byte $00

         *= $43e0
pbuff    .word $00,0,0,0
rbuff    .word $00,0
cbuff    .word $00,0
bon2     .byte $00
bmul     .byte $00
bxover2  .byte $00
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
haover   .byte 0
xhag
         .byte 180
yhag     .byte 60
sw
         .byte 0
plsw
         .byte 9,21
mcc      .byte 8,2
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

energy   .byte 93
action   .byte $00
vej      .byte 1
joy      .byte 0
         *= $0d81
         .byte 106,107,5,0,1
         .byte 108,109,5,2,1
         .byte 96,100,3,9,1
         .byte 114,114,10,10,0
addpoint .byte $00
animmell
         .byte 1,1,1,1,1,1,1,1
         .byte 1,1,1,1

ymin     .byte 65
ymax     .byte 80
xmin     .byte 110
xmax     .byte 210
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
extra    .byte 0
extra2   .byte 0
xover
         .byte 0
xover2   .byte 0
nospr    .byte 0
teler    .byte 0
duk      .byte 0
swordpower .byte $02
pakker   .byte $01
knive    .byte $10
spyd     .byte $05
axes     .byte $05
kugler   .byte $02
bomber   .byte $01
swover   .byte $00
flweap   .byte $00
megabomb .byte $00
lives    .byte $04
dying    .byte $00
undead   .byte $00
enemiesx .byte $08
ganger   .byte 48
key      .byte $00
spctab   .byte 14,15,16,17
gottem   .byte 0,0,0,0
stop     .byte $00
keinspr  .byte $00
rightend .byte $00
         *= $0e00
sup      .byte $00
sdw      .byte $00
sle      .byte $00
sri      .byte $00
upt
         .byte 3
lft
         .byte 3
xcoor
         .byte 4
ycoor
         .byte 1
scrvect  .byte %00000101
         .byte %00010101
borvect
         .byte %00100101
scrpos
         .byte 0,0
scroll10 .byte 4
scroll1  .byte 2
scroll2
         .byte 0
scroll20
         .byte 0
doneit   .byte $00
noxrq    .byte $01
doend    .byte $00
endgegner .byte $02
level    .byte $07
backcol  .byte $06
maxantal .byte $03
maxup    .byte $f1
