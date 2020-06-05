LoadPalettes:
    lda $2002   ; reset high/low latch
    lda #$3F
    sta $2006
    lda #$00
    sta $2006
    ldx #$00
.loop:
    lda palette, x
    sta $2007
    inx
    cpx #$20
    bne .loop