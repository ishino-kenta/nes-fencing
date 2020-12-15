ReloadBG:
    lda #$00
    sta tmp
.loop:
    ldx #$00

    lda #NUMBER_OF_TILE
    sta DRAW_BUFFER, x ; lenght
    inx

    lda #FLAG_INC32+FLAG_DATA_ROM
    sta DRAW_BUFFER, x ; flag
    inx

    lda #$20
    sta DRAW_BUFFER, x ; addr high
    inx

    lda scroll_x
    sec
    sbc #$08
    lsr a
    lsr a
    lsr a
    clc
    adc tmp
    clc
    adc #$01 ; left clip correction
    and #$1F
    clc
    adc #$20 ; top line not drawn
    sta DRAW_BUFFER, x ; addr low
    inx

    inline mul/mul28_2

    lda tmp+1
    clc
    adc source_addr
    sta DRAW_BUFFER, x ; data high
    inx

    lda tmp+2
    adc source_addr+1
    sta DRAW_BUFFER, x ; data low
    inx

    lda #$00
    sta DRAW_BUFFER, x
    inx
    jsr DrawBG

    inc tmp
    lda tmp
    cmp #$20
    beq .end
    jmp .loop
.end:

    ; attribute
    inline mul/mul8_2

    lda tmp+1
    clc
    adc source_addr+2
    sta tmp+5
    lda tmp+2
    adc source_addr+3
    sta tmp+6

    lda #$00
    sta tmp
.loop2:

    ldx #$00

    lda #NUMBER_OF_ATTR
    sta DRAW_BUFFER, x ; lenght
    inx

    lda #FLAG_DATA_BUFF+FLAG_ATTR_COL
    sta DRAW_BUFFER, x ; flag
    inx

    lda #$23
    sta DRAW_BUFFER, x ; addr high
    inx

    lda scroll_x
    lsr a
    lsr a
    lsr a
    lsr a
    lsr a
    clc
    adc tmp
    and #$07
    clc
    adc #$C0
    sta DRAW_BUFFER, x ; addr low
    inx

    inline mul/mul8_3

    lda #$00
    sta tmp+4
.looop:

    ldy #$00
    lda [tmp+1], y
    sta tmp+3

    lda tmp
    cmp #$00
    bne .not
    lda scroll_x
    and #$10
    beq .not
    
    lda tmp+3
    and #$CC
    sta tmp+3
    ldy #$30
    lda [tmp+1], y
    and #$33
    ora tmp+3
    sta tmp+3
.not:

    lda tmp+3
    sta DRAW_BUFFER, x
    inx

    lda tmp+1
    clc
    adc #$01
    sta tmp+1
    lda tmp+2
    adc #$00
    sta tmp+2
    
    inc tmp+4
    lda tmp+4
    cmp #$08
    beq .endl
    jmp .looop
.endl:

    lda #$00
    sta DRAW_BUFFER, x
    inx
    
    jsr DrawBG

    inc tmp
    lda tmp
    cmp #$08
    beq .end2
    jmp .loop2
.end2:

    rts