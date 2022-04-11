

;undwarf.r.asm          *= $1000
 ;unpacker-routine for DWARFERV1.37
 ; Rasmus Wernersson, 4/5 1992.

         jsr initget
         ldy #$00
loop1
         jsr get
         sei
         inc $01
         sta buffer,y
         dec $01
         cli
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
         sei
         inc $01
         sta ($fe),y
         dec $01
         cli
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
         sta $fe
         lda place+1
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
         ldx #$01
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

place    .word $6800
from     .word $4800
to       .word $4ddc
temp     .byte $00
buffer   = $0a00


