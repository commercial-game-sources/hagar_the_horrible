*= $2000
z = $50
data = z
fxbase = z+2
fx0sto = z+4
fx1sto = z+5
fx2sto = z+6
sd400 = z+7
sd401 = z+10
filter = z+13
wavetab = z+14
waverep = z+17
notetab = z+20
noterep = z+23
tempd400 = z+26
tempd401 = z+29
voice = z+32
sfxplay jmp spp
clearsid jmp clesid
jmp entersound
sta kiesfx
stx kiesfx+1
sty kiesfx+2
rts
entersound
tax
lda stab1,x
sta kiesfx
lda stab2,x
sta kiesfx+1
lda stab3,x
sta kiesfx+2
rts

kiesfx .byte $7f,$7f,$7f
testbyte .byte 0,0,0
stokies .byte 0,0,0
hieng .byte 0
loeng .byte 0
gatebit .byte 0,0,0
lencount .byte 0,0,0

d4point .byte 0,7,14
counter .byte 0,0,0
testcoun .byte 0,0,0
sd404 .byte 0,0,0
location .byte 0,0,0
vreorig .byte 0,0,0
vrecopy .byte 0,0,0
vslorig .byte 0,0,0
vslcopy .byte 0,0,0
tx .byte 0
filcount .byte 0

spp
ldx #2
start
ldy d4point,x
sty voice
stx tx
lda kiesfx,x
bpl gofxdd
jmp gofx
gofxdd
cmp #$7f
bne noclear
lda #$ff
sta testbyte,x
lda #0
sta $d406,y
sta $d405,y
sta $d404,y
jmp realend
noclear
sta stokies,x
asl a
tax
lda fxtab,x
sta fxbase
lda fxtab+1,x
sta fxbase+1
ldx tx
lda #$ff
sta gatebit,x
lda #0
sta $d406,y
sta $d405,y
sta $d404,y
sta counter,x
sta testbyte,x
sta sd400,x
sta sd401,x
tay
lda #$ff
sta kiesfx,x
lda (fxbase),y
pha
ldx voice
and #$f0
sta $d402,x
pla
and #$0f
sta $d403,x
iny
ldx tx
lda (fxbase),y
sta sd404,x
ldy #5
lda (fxbase),y
sta lencount,x
iny
ldx voice
lda (fxbase),y
sta $d400,x
pha
iny
lda (fxbase),y
sta $d401,x
pha
ldy #2
lda (fxbase),y
sta $d405,x
iny
lda (fxbase),y
sta $d406,x
ldx tx
pla
sta sd401,x
pla
sta sd400,x
jmp theend

gofx
lda stokies,x
asl a
tay
lda fxtab,y
sta fxbase
lda fxtab+1,y
sta fxbase+1

lda testbyte,x
bpl gofx2
jmp theend
gofx2
inc counter,x
lda counter,x
bne theco
lda #3
sta counter,x
theco
cmp #$ff
bne theco2
dec counter,x
theco2
cmp #2
bcs clrteco
lda #1
bne setteco
clrteco
lda #0
setteco
sta testcoun,x

lda lencount,x
cmp #$ff
beq nogate
dec lencount,x
bne nooo
lda #$7f
sta kiesfx,x
jmp realend
nooo
ldy #4
lda lencount,x
cmp (fxbase),y
bcs gateopen
lda #$fe
bne gto
gateopen
lda #$ff
gto
sta gatebit,x
nogate

;@@@@@@@@@@@@@@@@@@@@@@@@@WAVE@@@@@@@@@@

ldy #10
lda (fxbase),y
bmi nowave
clc
lda fxbase
adc (fxbase),y
sta data
lda fxbase+1
adc #0
sta data+1

ldy testcoun,x
beq waveinit
ldy #1
sty wavetab,x
sty waverep,x

waveinit
ldy #0
lda counter,x
cmp (data),y
bcc nowave

ldy wavetab,x
inc wavetab,x
lda (data),y
cmp #$fd
bne nowrepset
iny
tya
sta waverep,x
jmp waveinit
nowrepset
cmp #$fe
bne nowend
dec wavetab,x
jmp nowave
nowend
cmp #$ff
bne nowendrep
lda waverep,x
sta wavetab,x
jmp waveinit

nowendrep
sta sd404,x
nowave

;@@@@@@@@@@@@@@@@@@@@@@@@@NOTE@@@@@@@@@@

ldy #11
lda (fxbase),y
bmi nonote
clc
lda fxbase
adc (fxbase),y
sta data
lda fxbase+1
adc #0
sta data+1

ldy testcoun,x
beq noteinit
ldy #1
sty notetab,x
sty noterep,x

noteinit
ldy #0
lda counter,x
cmp (data),y
bcc nonote

ldy notetab,x
inc notetab,x
lda (data),y
cmp #$fd
bne nonrepset
iny
tya
sta noterep,x
jmp noteinit
nonrepset
cmp #$fe
bne nonend
dec notetab,x
jmp nonote
nonend
cmp #$ff
bne nonendrep
lda noterep,x
sta notetab,x
jmp noteinit
nonendrep
clc
ldy #6
adc (fxbase),y
sta sd400,x
sta sd401,x

cpx #3
bne noeng
lda stokies,x
cmp #$00
bne noeng
lda sd400,x
clc
adc hieng
sta sd400,x
lda sd401,x
adc loeng
sta sd401,x
noeng
jmp novibby
nonote

;@@@@@@@@@@@@@@@@@@@@@@@@@VIBRATO@@@@@@@

ldy #8
lda (fxbase),y
bmi novibby

lda testcoun,x
beq vibinit
ldy #13
lda (fxbase),y
sta vslorig,x
sta vslcopy,x
dey
lda (fxbase),y
sta vreorig,x
sta vrecopy,x
lda sd400,x
sta tempd400,x
lda sd401,x
sta tempd401,x
vibinit
dec vslcopy,x
bpl novibby
lda vslorig,x
sta vslcopy,x
dec vrecopy,x
bpl vibop0
lda tempd400,x
sta sd400,x
lda tempd401,x
sta sd401,x
lda vreorig,x
sta vrecopy,x
jmp novib2
vibop0
ldy #15
clc
lda sd400,x
adc (fxbase),y
sta sd400,x
iny
lda sd401,x
adc (fxbase),y
sta sd401,x
novib2
ldy #14
lda (fxbase),y
beq novibby
asl a
sta data
lda (fxbase),y
bmi evcdown

lda tempd400,x
adc data
sta tempd400,x
lda tempd401,x
adc #0
jmp tvi
evcdown
lda tempd400,x
sbc data
sta tempd400,x
lda tempd401,x
sbc #0
tvi
sta tempd401,x
novibby

;@@@@@@@@@@@@@@@@@@@@@filter@@@@@

ldx tx
bne nofilter

ldy #9
lda (fxbase),y
bpl dofilter
lda #0
sta $d417
beq nofilter
dofilter
clc
lda fxbase
adc (fxbase),y
sta data
lda fxbase+1
adc #0
sta data+1

lda testcoun,x
beq filinit
ldy #0
lda (data),y
clc
adc #$0f
sta $d418
lda #%11110001
sta $d417
iny
lda (data),y
sta filcount
iny
lda (data),y
sta filter
jmp stofil
filinit

lda filter
clc
adc filcount
sta filter
stofil
sta $d416
nofilter


theend
ldx tx
ldy voice
lda sd400,x
sta $d400,y
lda sd401,x
sta $d401,y
lda sd404,x
and gatebit,x
sta $d404,y
realend
dex
bmi end
jmp start
end
rts

;@@@@@@@@@@@@@@@@@@@@@@@@@CLEARSID@@@@@@

clesid
lda #0
ldx #$14
cs1 sta $d400,x
dex
bpl cs1
lda #$7f
sta kiesfx
sta kiesfx+1
sta kiesfx+2
lda #$1f
sta $d418
lda #1
sta $d404
sta $d404+7
sta $d404+14
rts

fxtab
.word fx00
.word fx01
.word fx02
.word fx03
.word fx04
.word fx05
.word fx06
.word fx07
.word fx08
.word fx09
.word fx0a
.word fx0b
.word fx0c
.word fx0d
.word fx0e
.word fx0f
.word fx10
.word fx11
.word fx12
.word fx13
.word fx14
.word fx15
.word fx16
fx00 ;wave4
.byte $00,$81,$ca,$00    ;23,4,5,6
.byte $00,$00            ;gate,len
.word $3000              ;freq
.byte $ff,$ff,wa00-fx00,no00-fx00
      ;vib filter   wave      note
wa00
.byte $80        ;delay
.byte $80,$81,$fe
no00
.byte $80        ;delay
.byte $18,$fe
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx01 ;wave5
.byte $00,$81,$ba,$00    ;23,4,5,6
.byte $00,$00            ;gate,len
.word $2800              ;freq
.byte $ff,$ff,wa01-fx01,no01-fx01
      ;vib filter   wave      note
wa01
.byte $80        ;delay
.byte $80,$81,$fe
no01
.byte $80        ;delay
.byte $2e,$fe
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx02 ;wave6
.byte $00,$81,$bb,$00    ;23,4,5,6
.byte $00,$00            ;gate,len
.word $1200              ;freq
.byte $ff,$ff,wa02-fx02,no02-fx02
      ;vib filter   wave      note
wa02
.byte $80        ;delay
.byte $80,$81,$fe
no02
.byte $80        ;delay
.byte $14,$fe
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx03 ;fwoojii1
.byte $00,$81,$99,$f8    ;23,4,5,6
.byte $08,$20            ;gate,len
.word $f800              ;freq
.byte $00,$ff,$ff,$ff
      ;vib filter   wave      note
.byte $f8,$00,$7f;time,paus,extra-add
.word $4800        ;optel
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx04 ;vibra1
.byte $00,$81,$99,$20    ;23,4,5,6
.byte $00,$20            ;gate,len
.word $fe00              ;freq
.byte $00,$ff,wa04-fx04,$ff
      ;vib filter   wave      note
.byte $01,$00,$b0;time,paus,extra-add
.word $1000        ;optel
wa04
.byte $00        ;delay
.byte $fd,$11,$81,$81,$81,$ff
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx05 ;sword1
.byte $00,$81,$68,$09    ;23,4,5,6
.byte $00,$16            ;gate,len
.word $1000              ;freq
.byte $00,$ff,wa05-fx05,no05-fx05
      ;vib filter   wave      note
.byte $01,$02,$00;time,paus,extra-add
.word $0700        ;optel
wa05
.byte $0a        ;delay
.byte $00,$81,$fe
no05
.byte $0a        ;delay
.byte $fd,$28,$08,$ff
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx06 ;take'em1
.byte $80,$21,$89,$fa    ;23,4,5,6
.byte $00,$20            ;gate,len
.word $3000              ;freq
.byte $00,$ff,wa06-fx06,$ff
      ;vib filter   wave      note
.byte $03,$00,$00;time,paus,extra-add
.word $1000        ;optel
wa06
.byte $0a        ;delay
.byte $10,$fe
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx07 ;take'em2
.byte $8d,$11,$00,$f8    ;23,4,5,6
.byte $00,$20            ;gate,len
.word $5000              ;freq
.byte $00,$ff,wa07-fx07,$ff
      ;vib filter   wave      note
.byte $08,$08,$9f;time,paus,extra-add
.word $1100        ;optel
wa07
.byte $08        ;delay
.byte $fd,$11,$10,$10,$11,$ff
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx08 ;water1
.byte $00,$81,$69,$0f    ;23,4,5,6
.byte $00,$20            ;gate,len
.word $8000              ;freq
.byte $00,$ff,$ff,$ff
      ;vib filter   wave      note
.byte $03,$02,$00;time,paus,extra-add
.word $0800        ;optel
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx09 ;water2
.byte $00,$81,$69,$89    ;23,4,5,6
.byte $10,$20            ;gate,len
.word $1000              ;freq
.byte $ff,$ff,$ff,$ff
      ;vib filter   wave      note
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx0a ;water3
.byte $00,$81,$98,$20    ;23,4,5,6
.byte $00,$10            ;gate,len
.word $8000              ;freq
.byte $00,$ff,wa0a-fx0a,$ff
      ;vib filter   wave      note
.byte $01,$00,$b0;time,paus,extra-add
.word $1000        ;optel
wa0a
.byte $00        ;delay
.byte $fd,$81,$81,$81,$81,$ff
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx0b ;dizzy1
.byte $00,$11,$09,$fc    ;23,4,5,6
.byte $60,$f0            ;gate,len
.word $8000              ;freq
.byte $00,$ff,$ff,$ff
      ;vib filter   wave      note
.byte $03,$03,$00;time,paus,extra-add
.word $1000        ;optel
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx0c ;dizzy2
.byte $7f,$41,$09,$fc    ;23,4,5,6
.byte $60,$f0            ;gate,len
.word $9000              ;freq
.byte $00,$ff,$ff,$ff
      ;vib filter   wave      note
.byte $01,$03,$00;time,paus,extra-add
.word $1000        ;optel
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx0d ;dizzy3
.byte $04,$41,$09,$fc    ;23,4,5,6
.byte $60,$f0            ;gate,len
.word $7000              ;freq
.byte $00,$ff,$ff,$ff
      ;vib filter   wave      note
.byte $04,$04,$00;time,paus,extra-add
.word $1000        ;optel
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx0e ;tele.in
.byte $00,$81,$a0,$00    ;23,4,5,6
.byte $00,$20            ;gate,len
.word $1000              ;freq
.byte $00,$ff,$ff,$ff
      ;vib filter   wave      note
.byte $01,$00,$40;time,paus,extra-add
.word $00          ;optel
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx0f ;tele.out
.byte $00,$81,$a0,$00    ;23,4,5,6
.byte $00,$20            ;gate,len
.word $2000              ;freq
.byte $00,$ff,$ff,$ff
      ;vib filter   wave      note
.byte $01,$00,$c0;time,paus,extra-add
.word $00          ;optel
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx10 ;jump1
.byte $00,$11,$0f,$fa    ;23,4,5,6
.byte $10,$20            ;gate,len
.word $1000              ;freq
.byte $00,$ff,$ff,$ff
      ;vib filter   wave      note
.byte $01,$00,$30;time,paus,extra-add
.word $0180        ;optel
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx11 ;step1
.byte $00,$81,$10,$00    ;23,4,5,6
.byte $00,$01            ;gate,len
.word $1000              ;freq
.byte $ff,$ff,$ff,$ff
      ;vib filter   wave      note
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx12 ;dunk1
.byte $00,$81,$67,$00    ;23,4,5,6
.byte $00,$20            ;gate,len
.word $1000              ;freq
.byte $00,$ff,$ff,$ff
      ;vib filter   wave      note
.byte $01,$00,$7f;time,paus,extra-add
.word $0700        ;optel
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx13 ;wave1
.byte $00,$81,$bb,$00    ;23,4,5,6
.byte $00,$00            ;gate,len
.word $1000              ;freq
.byte $ff,$ff,wa13-fx13,no13-fx13
      ;vib filter   wave      note
wa13
.byte $80        ;delay
.byte $80,$81,$fe
no13
.byte $80        ;delay
.byte $18,$fe
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx14 ;wave2
.byte $00,$81,$ab,$00    ;23,4,5,6
.byte $00,$00            ;gate,len
.word $1a00              ;freq
.byte $ff,$ff,wa14-fx14,no14-fx14
      ;vib filter   wave      note
wa14
.byte $80        ;delay
.byte $80,$81,$fe
no14
.byte $80        ;delay
.byte $14,$fe
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx15 ;wave3
.byte $00,$81,$cc,$00    ;23,4,5,6
.byte $00,$00            ;gate,len
.word $1100              ;freq
.byte $ff,$ff,wa15-fx15,no15-fx15
      ;vib filter   wave      note
wa15
.byte $80        ;delay
.byte $80,$81,$fe
no15
.byte $80        ;delay
.byte $0e,$fe
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fx16 ;hit1
.byte $08,$41,$18,$0a    ;23,4,5,6
.byte $00,$50            ;gate,len
.word $1000              ;freq
.byte $ff,$ff,wa16-fx16,$ff
      ;vib filter   wave      note
wa16
.byte $02        ;delay
.byte $fd,$20,$80,$20,$20,$10
.byte $ff

stab1
.byte 0,3,5,6,7,8,11,14,15,16
.byte 17,18,19,22
stab2
.byte 1,4,$7f,$7f,$7f,9,12,$7f
.byte $7f,$7f,$7f,$7f,$14,$7f
stab3
.byte 2,$7f,$7f,$7f,$7f,$7f,$0d
.byte $7f,$7f,$7f,$7f,$7f,$15
.byte $7f
