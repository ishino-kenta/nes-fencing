;--------------------------------------------------
; in
; source_addr: palette's address
; used register
; a,y
LoadPalette:
    lda $2002   ; reset high/low latch
    lda #$3F
    sta $2006
    lda #$00
    sta $2006
    ldy #$00
.loop:
    lda [source_addr], y
    sta $2007
    iny
    cpy #$20
    bne .loop
    rts