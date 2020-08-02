; Don't use
; 32 tiles in one row
InitBG:
    lda #$00
    sta tmp
.loop:
    ldx #$00
    lda #$1E
    sta DRAW_BUFFER, x ; lenght
    inx

    lda #FLAG_INC32+FLAG_MODE_TILE_ROM
    sta DRAW_BUFFER, x ; flag
    inx

    lda #$20
    sta DRAW_BUFFER, x ; addr high
    inx

    lda scroll_x
    lsr a
    lsr a
    lsr a
    clc
    adc tmp
    clc
    adc #$01 ; left clip correction
    and #$1F
    sta DRAW_BUFFER, x ; addr low
    inx

    lda scroll_x
    sta tmp+1
    lda scroll_x+1
    sta tmp+2 

    lda tmp+1
    and #$F8
    sta tmp+1
    asl tmp+1
    rol tmp+2
    asl tmp+1
    rol tmp+2

    lda #$00
    sta tmp+3
    lda tmp
    rol a
    rol tmp+3
    rol a
    rol tmp+3
    rol a
    rol tmp+3
    rol a
    rol tmp+3
    rol a
    rol tmp+3
    clc
    adc tmp+1
    sta tmp+1
    lda tmp+2
    adc tmp+3
    sta tmp+2

    lda tmp+1
    clc
    adc #LOW(tile1)
    sta DRAW_BUFFER, x ; data high
    inx
    lda tmp+2
    adc #HIGH(tile1)
    sta DRAW_BUFFER, x ; data low
    inx

    lda #$00
    sta DRAW_BUFFER, x
    inx
    jsr DrawBG

    inc tmp
    lda tmp
    cmp #$1F
    beq .end
    jmp .loop
.end: