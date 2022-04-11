
         *= $19f0
         jmp $19fd
         *= $1000
         jmp startup
         jmp getscr
         jmp getscll
         jmp getstop
         jmp getex
         jmp iq1
sprcon   = $1a03
transv1  = $1a00
endless  = $1a06
putsword = $1a09
doitsmall = $240c
putpoints = $1a09+6
zp       = $fb
zp2      = $fd
gem      .byte 0
contdo
         inc doneit
         jmp doitsmall
startup
         jsr setup
         sei
         lda #$c7
         sta $dc04
         lda #$4c
         sta $dc05
         lda #$01
         sta $d01a
         lda #$00
         sta $dc0e
         lda #$81
         sta $dc0d
         lda #$00
         sta $dc0e
         lda #$35
         sta $01
         lda $dd00
         and #%11111100
         ora #%00000010
         sta $dd00
         lda #$00
         sta $d012
         lda #$00
         sta $d011

         lda #<irq2
         sta $fffe
         lda #>irq2
         sta $ffff
         lda #<irq1
         sta $fffa
         lda #>irq1
         sta $fffb
         lda $d011
         bpl *-3
         lda $d011
         bmi *-3
         lda #174
ww
         cmp $d012
         bne ww
         lda #%10010001
         sta $dc0e
         lda #$1b
         sta $d011
         cli
wait
         jmp endless
irq1
         rti
iq1
         ldx borvect
         stx 53272
         ldy #$7f
         sty $d011
         ldx #$00
         stx $d021
         stx $d008
         stx $d00a
         stx $d00c
         stx $d00e
         stx $d010
         lda #15
         sta 53248+38
         jsr putpoints
         ldx #23
         lda $d012
vent1
         cmp $d012
         beq vent1
         stx $d011
         lda #200
         sta 53270
         lda #$00
         sta doneit
         jsr hyper
         dec achtel
         jsr $7000
         lda okblit
         cmp #$02
         bne irqv2
         jsr checkkeys
         jsr colcalc
jex
         jmp irqexit
irqv2
         jsr checkkeys
         jsr calc
         lda okblit
         bne irqexit
irqv3
         jsr animchar
ex8
         jsr putsword
         jmp irqexit
irqexit
         pla
         tay
         pla
         tax
         pla
         rti
install
         ldx scrpos
         lda scrvect,x
         sta 53272
         lda scroll10
         ora #%00010000
         sta $d011
         lda scroll20
         ora #%00010000
         sta 53270
         rts
jiq1
         jmp iq1
irq2
         pha
         txa
         pha
         tya
         pha
         lda $dc0d
         and #$01
         bne jiq1
         lda $d019
         and #$01
         beq irqexit
         sta $d019
         ldx scrpos
         lda scrvect,x
         sta 53272
         lda shop
         bne full
         lda scroll10
         ora #%00010000
         sta $d011
         lda scroll20
         ora #%00010000
         sta 53270
         lda scroll2
         sta scroll20
         lda scroll1
         sta scroll10
         jmp sprcon
full
         lda #27
         sta $d011
         lda #88
         sta 53270
         jmp sprcon
source   .word $00
dest     .word $00
blitter2
         lda source
         sta zp
         lda source+1
         sta zp+1
         lda dest
         sta zp2
         lda dest+1
         sta zp2+1
         lda #$02
         sta okblit
blit2loop2
         ldy #$00
blit2loop
         jsr putsword
         jsr fastm1
         jsr fastm1
         jsr fastm1
         jsr fastm1

         inc zp+1
         inc zp2+1
blit2loop3
         jsr fastm1
         jsr fastm1
         jsr fastm1
         jsr fastm1

         inc zp2+1
         inc zp+1
         jsr install
         jsr contdo
         ldy #$00
blit2loop4
         lda lastx
         cmp #$80
         beq hiv1
         jsr fastm1
         jsr fastm11
         jmp ex6
hiv1
         jsr fastm1
         jsr fastm1
ex6
         lda #$02
         sta okblit
         jmp chway

cblitter2
         lda source
         sta zp
         lda source+1
         sta zp+1
         lda dest
         sta zp2
         lda dest+1
         sta zp2+1
         lda #$00
         sta okblit
         lda revcol
         bne revcblit
cblit2loop2
         jsr putsword
         ldy #$00
         jsr fastm1
         jsr fastm1
         jsr fastm1
         jsr fastm1

         inc zp+1
         inc zp2+1
cblit2loop3
         jsr fastm1
         jsr fastm1
         jsr fastm1
         jsr fastm1

         inc zp2+1
         inc zp+1
         jsr install
         jsr contdo
         ldy #$00

cexblit2
         ldy #$00
cblit2loop4
         lda lastx
         cmp #$80
         beq hiv2
         jsr fastm1
         jsr fastm11
         jmp ex7
hiv2
         jsr fastm1
         jsr fastm1
ex7
         jmp cchway
revcblit
         inc zp+1
         inc zp+1
         inc zp2+1
         inc zp2+1
         ldy lastx
rcblit2loop
         lda lastx
         cmp #$80
         beq hiv3
         jsr putsword
         jsr fastm2
         jsr fastm22
         jmp gv1
hiv3
         jsr putsword
         jsr fastm2
         jsr fastm2
         lda (zp),y
         sta (zp2),y
gv1
         dec zp+1
         dec zp2+1
         ldy #$ff
rcblit2loop3
         jsr fastm2
         jsr fastm2
         jsr fastm2
         jsr fastm2
         dec zp2+1
         dec zp+1
         jsr install
         jsr contdo

         ldy #$ff
rcbl4
         jsr fastm2
         jsr fastm2
         jsr fastm2
         jsr fastm2

         jmp cchway
lastx
         .byte $00
sch      .byte 2
sch2     .byte 3
rast1    .byte 165+8
rast2    .byte 0
blockbase
         .word $3000
mapbase
         .word $3500
xw
         .byte 64
yw
         .byte 50
mup
         .byte 0
mdw
         .byte 0
mle
         .byte 0
mri
         .byte 0
stmove
         .byte 0
screenbase
         .word $4000
         .word $4400
fastm1   = $0800
fastm11  = $08c8
fastm2   = $0941
fastm22  = $0941+$c3
hyper
         lda hyperspeed
         beq norm
         lda #4
         sta sch
         lda #4
         sta sch2
         jmp animchar
norm
         lda #$02
         sta sch
         lda #$03
         sta sch2
         rts
ex1
         rts
cup
         lda scroll1
         sec
         sbc sch2
         tay
         cmp #$08
         bcs goon
         jmp cupex
goon
         clc
         lda stmove
         adc okblit
         bne ex1
         tya
         clc
         adc #$08
         sta scroll1
         lda #$28
         sta mup
         sta stmove
yv1
         lda upt
         beq xxup1
xxup2
         dec upt
         rts
xxup1
         lda #$03
         sta upt
         inc ycoor
         rts
cupex
         tya
         sta scroll1
ex10
         rts
cdown
         lda scroll1
         clc
         adc sch
         cmp #$08
         bcc cdwex
         tay
         lda stmove
         clc
         adc okblit
         bne ex10
         tya
         sec
         sbc #$08
         sta scroll1
         lda #$28
         sta mdw
         sta stmove
yv2
         lda upt
         cmp #$03
         beq xxdw1
xxdw2
         inc upt
         rts
xxdw1
         lda #$00
         sta upt
         dec ycoor
         rts
cdwex
         sta scroll1
         rts
jcup
         jmp cup
checkkeys
         lda sup
         beq cv1
         jmp cup
cv1
         lda sdw
         beq cv2
         jsr cdown
cv2
         lda sle
         beq cv3
         jmp cleft
cv3
         lda sri
         beq cv4
         jmp cright
cv4
         rts

cleft
         lda scroll2
         sec
         sbc sch
         tay
         and #%10000000
         beq cleex
         lda stmove
         clc
         adc okblit
         bne ex2
         tya
         clc
         adc #$08
         sta scroll2
         lda #$01
         sta mle
         sta stmove
yv3
         lda lft
         beq xxlf1
xxlf2
         dec lft
         rts
xxlf1
         lda #$03
         sta lft
         inc xcoor
         rts
cleex
         tya
         sta scroll2
         rts
ex2
         rts
cright
         lda scroll2
         clc
         adc sch
         cmp #$08
         bcc criex
         tay
         lda stmove
         clc
         adc okblit
         bne ex2
         tya
         sec
         sbc #$08
         sta scroll2
         lda #$01
         sta mri
         sta stmove
yv4
         lda lft
         cmp #$03
         beq xxri1
xxri2
         inc lft
         rts
xxri1
         lda #$00
         sta lft
         dec xcoor
         rts
criex
         sta scroll2
         rts
endcalc
         lda #$00
         sta mup
         sta mdw
         sta mle
         sta mri
         rts
calc
         lda stmove
         beq endcalc
         lda #$00
         sta stmove
         lda scrpos
         eor #$01
         sta scrpos+1
         asl a
         tax
         lda screenbase+1,x
         sta dest+1
         lda mdw
         clc
         adc mri
         sta dest
         lda scrpos
         asl a
         tax
         lda screenbase+1,x
         sta source+1
         lda screenbase,x
         clc
         adc mup
         adc mle
         sta source
         sec
         lda #$80
         sbc mdw
         sbc mup
         sta lastx
         jmp blitter2
okblit   .byte 0
colcalc
         lda scrpos
         eor #$01
         sta scrpos+1
         lda #$d8
         sta dest+1
         lda mdw
         clc
         adc mri
         sta dest
         lda #$d8
         sta source+1
         lda mup
         clc
         adc mle
         sta source
         lda scrpos+1
         sta scrpos
         lda #$00
         sta revcol
         lda mdw
         beq ccv1
         inc revcol
         jmp cblitter2
ccv1
         lda mup
         bne ccv3
ccv2
         lda mri
         beq ex4
         lda #$01
         sta revcol
ex4
         jmp cblitter2
ccv3
         lda #$00
         sta revcol
         jmp cblitter2
revcol   .byte 0
varb
         .byte 0,0
gemvar
         lda zp
         sta varb
         lda zp+1
         sta varb+1
         rts
getvar
         lda varb
         sta zp
         lda varb+1
         sta zp+1
         rts
cw1
         clc
         lda mup
         adc mdw
         beq cx
         jsr getblock1
         jsr putxblocks
         rts
chway
         clc
         lda mle
         adc mri
         beq cw1
         jsr getby
         jsr putyblocks
cx
         rts
ccw1
         clc
         lda mup
         adc mdw
         beq ccx
         jsr cputx
         jmp ccx
cchway
         clc
         lda mle
         adc mri
         beq ccw1
         jsr cputy
ccx
         jmp endcalc

getblock1
         lda mup
         beq gb1
         jsr calcmappos2
         jmp gb2
gb1
         jsr calcmappos
gb2
         lda mappos
         sta zp
         clc
         lda mappos+1
         adc mapbase+1
         sta zp+1
         ldy #$00
         ldx #$00
blloop
         lda (zp),y
         sta xnow,x
         iny
         inx
         cpx #11
         bne blloop
         rts
xnow
         .byte 0,0,0,0,0,0,0,0,0,0
         .byte 0
ynow

         .byte 0,0,0,0
         .byte 0
getby
         jsr calcmappos
         lda mappos
         sta zp
         clc
         lda mappos+1
         adc mapbase+1
         sta zp+1
         ldx #$00
         ldy #$00
         lda lft
         sta elft
         cpy mri
         bne gy1
         lda lft
         cmp #$03
         bne gy10
         lda #$00
         sta elft
         ldy #9
         jmp gy1
gy10
         inc elft
         ldy #10
gy1
         lda (zp),y
         sta ynow,x
         clc
         lda zp
         adc xw
         bcc gy2
         inc zp+1
gy2
         sta zp
         inx
         cpx #5
         bne gy1
         rts
gbl
         sta m
         lda #32
         sta n
         jsr mult
         clc
         lda result
         sta zp
         lda result+1
         adc blockbase+1
         sta zp+1
         rts
cputy
         lda #$10
         sta lowadd
         lda #$d8
         sta zp2+1
         lda #$00
         jsr cvk1
         lda #$00
         sta lowadd
         rts
putyblocks
         lda scrpos
         eor #$01
         asl a
         tax
         lda screenbase+1,x
         sta zp2+1
         lda screenbase,x
cvk1
         ldy mri
         cpy #$00
         bne py1
         clc
         adc #39
py1
         sta zp2
         lda #$00
         sta xtel
         lda ynow
         jsr setzp
         lda upt
         asl a
         asl a
         sta ygem
         lda #15
         sec
         sbc ygem
         sec
         sbc elft
         tay
         lda #$03
         sec
         sbc elft
         sta ygem2
         jmp st1
pyl1
         clc
         lda ynow,x
         jsr setzp
         ldy ygem2
st1
         lda (zp),y
         sty ygem
         ldy #$00
         sta (zp2),y
         clc
         lda zp2
         adc #40
         bcc st2
         inc zp2+1
st2
         sta zp2
         lda ygem
         clc
         adc #$04
         tay
         cpy #16
         bcc st1
         inc xtel
         ldx xtel
         cpx #5
         bne pyl1
         rts
ygem     .byte 0
yadd
         .byte 0
yer2     .byte 0
ygem2    .byte 0
elft     .byte 0
eupt     .byte 0
lowadd   .byte $00
lowtab
         .byte $00,$20,$40,$60
         .byte $80,$a0,$c0,$e0
cputx
         lda #$10
         sta lowadd
         lda mup
         beq cputv1
         lda #88
         sta zp2
         lda #$d8+2
         sta zp2+1
         jmp cpjm
cputv1
         lda #$00
         sta zp2
         lda #$d8
         sta zp2+1
cpjm
         jsr px2
         lda #$00
         sta lowadd
         rts
putxblocks
         lda #$00
         sta yadd
         lda scrpos
         eor #$01
         asl a
         tax
         lda mup
         beq px1
         clc
         lda screenbase,x
         adc #88
         sta zp2
         lda screenbase+1,x
         adc #$02
         sta zp2+1
         jmp px2
px1
         lda screenbase,x
         sta zp2
         lda screenbase+1,x
         sta zp2+1
px2
         lda eupt
         asl a
         asl a
         sta yer2
         lda #12
         sec
         sbc yer2
         sta yer2
         clc
         adc #$03
         sec
         sbc lft
         tay
         sty samy2
         lda #$00
         sta xtel
         lda xnow
         jsr setzp
         lda yer2
         clc
         adc #$04
         sta samy
         jmp sx1
sx1
         lda (zp),y
         sty ygem
         ldy yadd
         sta (zp2),y

         inc zp2
         ldy ygem
         iny
         cpy samy
         bne sx1
         inc xtel
         ldx xtel
pxl1
         lda xnow,x
         jsr setzp
         lda zp
         clc
         adc yer2
         sta zp

         ldy #$00
sx3
         lda (zp),y
         sta (zp2),y
         iny
         cpy #$04
         bne sx3
         lda zp2
         adc #$03;+1
         sta zp2

         inc xtel
         ldx xtel
         cpx #10
         bne pxl1

         lda yer2
         cmp samy2
         beq ex9
         lda xnow,x
         jsr setzp
         ldy yer2
sx2

         lda (zp),y
         sty ygem
         ldy yadd
         sta (zp2),y
         clc
         inc zp2
         ldy ygem
         iny
         cpy samy2
         bne sx2
ex9
         rts
setzp
         tax
         lsr a
         lsr a
         lsr a
         clc
         adc #$30
         sta zp+1
         txa
         and #%00000111
         tax
         lda lowtab,x
         clc
         adc lowadd
         sta zp
         rts
samy2    .byte 0
samy     .byte 0
gmap     .word $00
start
         lda blockno
         sta m
         lda #32
         sta n
         jsr mult
         lda result
         sta zp
         lda result+1
         clc
         adc blockbase+1
         sta zp+1
         ldy #$00
bloop3
         lda (zp),y
         sta chrgem,y
         iny
         cpy #32
         bne bloop3
         lda scrpos
         asl a
         tax
         lda screenbase,x
         sta zp2
         lda screenbase+1,x
         sta zp2+1
         lda #$00
         sta zp
         lda #$d8
         sta zp+1
         ldy scrxy+1
         cpy #$00
         beq bv1
bloop2
         clc
         lda zp
         adc #40
         bcc notover2
         inc zp+1
         inc zp2+1
notover2
         sta zp
         sta zp2
         dey
         bne bloop2
bv1
         ldy scrxy
         ldx #$00
         lda #$04
         sta xmod
bloop4
         lda chrgem,x
         sta (zp2),y
         lda colgem,x
         sta (zp),y
         dec xmod
         bne bv2
         lda #$04
         sta xmod
         tya
         adc #36
         tay
bv2
         iny
         inx
         cpx #$10
         bne bloop4
         rts
wholescreen
         jsr calcmappos
         lda #$00
         sta scrxy
         sta scrxy+1
         sta xtel
         sta ytel
whloop1
         lda mappos
         sta gmap
         sta zp
         lda mappos+1
         clc
         adc mapbase+1
         sta zp+1
         sta gmap+1
wl1
         ldy #$00
         lda (zp),y
         sta blockno
         jsr gemvar
         jsr start
         jsr getvar
         lda zp
         clc
         adc xw
         bcc notover3
         inc zp+1
notover3
         sta zp
         clc
         lda scrxy+1
         adc #$04
         sta scrxy+1
         inc ytel
         lda ytel
         cmp #4
         beq whv1
         jmp wl1
whv1
         lda #$00
         sta ytel
         sta scrxy+1
         clc
         lda scrxy
         adc #$04
         sta scrxy
         lda gmap+1
         sta zp+1
         inc xtel
         clc
         lda xtel
         adc gmap
         bcc ok3
         inc zp+1
ok3
         sta zp
         lda xtel
         cmp #10
         bne wl1
         rts

chrgem   .word 0,0,0,0,0,0,0,0

colgem   .word 0,0,0,0,0,0,0,0
xmod     .byte $00
xtel     .byte $00
ytel     .byte $00

scrxy    .byte 0,0
blockno  .byte 0
mappos   .word $00
calcmappos
         lda upt
         sta eupt
         lda xw
         sta m
         lda ycoor
         sta n
cok
         jsr mult
         clc
         lda xcoor
         adc result
         sta mappos
         lda result+1
         adc #$00
         sta mappos+1
         rts
calcmappos2
         lda xw
         sta m
         lda upt
         sta eupt
         cmp #$03
         bne cmm2
         lda #$00
         sta eupt
         lda ycoor
         clc
         adc #$03
         sta n
         jmp cok
cmm2
         inc eupt
         clc
         lda ycoor
         adc #$04
         sta n
         jmp cok
result   .word 0
m        .byte 0
n        .byte 0
mult
         clc
         lda #$00
         sta result
         ldx #$08
gentag
         lsr m
         bcc noadd
         clc
         adc n
noadd
         ror a
         ror result
rorb
         dex
         bne gentag
         sta result+1
         rts
setup
         lda #$00
         sta $d020
         sta $d011
         lda #$03
         sta upt
         sta lft
         lda #$01
         sta xcoor
         lda #$00
         sta ycoor
         jsr setbor
         jsr wholescreen
         rts
setbor
         ldx #$00
sbl1
         lda $4800,x
         sta $da00,x
         lda $4900,x
         sta $db00,x
         dex
         bne sbl1
         rts
getv
         ldy #$00
lp1
         jsr transv1
         sta sup,y
         iny
         cpy #$04
         bne lp1
         rts
getscr
         lda scrpos
         ldx xcoor
         ldy ycoor
         rts
getscll
         ldx scroll10
         ldy scroll20
         rts
getstop
         rts
getex
         ldx upt
         ldy lft
         rts
achtel
         .byte $24
animchar
         lda achtel
         cmp #$20
         bcc fgoon
         rts
firec
         .byte $00
fpoint
         .word $5380
         .word $53a0
         .word $53c0
         .word $53a0
fvec
         .word $55a0
fgoon
         lda firec
         asl a
         tax
         lda fpoint,x
         sta zp
         lda fpoint+1,x
         sta zp+1
         lda fvec
         sta zp2
         lda fvec+1
         sta zp2+1
         ldy #$00
firel1
         lda (zp),y
         sta (zp2),y
         iny
         cpy #32
         bne firel1
         inc firec
         lda firec
         cmp #3
         bne fex
         lda #$00
         sta firec
fex
         lda #$24
         sta achtel
         rts
         *= $0d80
hyperspeed .byte $00
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
maxup    .byte $f5
shop     .byte $00
