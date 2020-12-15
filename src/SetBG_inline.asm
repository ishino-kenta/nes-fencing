NUMBER_OF_TILE = $1C

SetBG:
    ldx ppu_counter

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
    adc #$20 ; top line not drawn
    sta DRAW_BUFFER, x ; addr low
    inx
    

    lda direction_scroll
    cmp #DIRECTION_RIGHT
    bne .3
    lda scroll_x
    clc
    adc #$F8
    sta tmp ; col
    lda #$00
    adc #$00
    sta tmp+4 ; bank
    lda scroll_x
    clc
    adc #$F8
    lda scroll_x+1
    adc #$00
    sta tmp+1 ; num
.3:
    lda direction_scroll
    cmp #DIRECTION_LEFT
    bne .4
    lda scroll_x
    sec
    sbc #$07
    sta tmp
    lda #$00
    sbc #$00
    sta tmp+4
    lda scroll_x
    sec
    sbc #$07
    lda scroll_x+1
    sbc #$00
    sta tmp+1
.4:

    lda tmp+4
    and #$01
    asl a
    asl a
    asl a
    asl a
    asl a
    sta tmp+4 ; bank(+2000)

    ldy tmp+1
    lda testData, y
    and #$07
    asl a
    asl a
    asl a
    asl a
    asl a
    sta tmp+1 ; num*32

    lda tmp
    lsr a
    lsr a
    lsr a
    sta tmp ; col

    lda tmp
    clc
    adc tmp+1
    sta tmp
    lda #$00
    adc #$00
    sta tmp+1

    inline mul/mul28_1

    lda tmp+1
    clc
    adc #$80
    clc
    adc tmp+4
    sta tmp+1

    lda tmp
    sta DRAW_BUFFER, x ; data low
    sta test+3
    inx
    lda tmp+1
    sta DRAW_BUFFER, x ; data high
    sta test+2
    inx

    ; attribute
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
    sec
    sbc #$08
    lsr a
    lsr a
    lsr a
    lsr a
    lsr a
    and #$07
    clc
    adc #$C0
    sta DRAW_BUFFER, x ; addr low
    inx
    
    lda scroll_x
    sta tmp
    lda scroll_x+1
    sta tmp+1

    lda scroll_x
    clc
    adc #$F8
    sta tmp
    lda scroll_x+1
    adc #$00
    sta tmp+1 ; right

    lda scroll_x
    sec
    sbc #$07
    sta tmp+2
    lda scroll_x+1
    sbc #$00
    sta tmp+3 ; left
    
    inline mul/mul8_1

    lda #$00
    sta tmp+4
.lp:
    lda direction_scroll
    cmp #DIRECTION_RIGHT
    bne .r

    ldy #$00
    lda [tmp], y
    sta tmp+5

    lda scroll_x
    and #$10
    lsr a
    sta tmp+6
    lda scroll_x
    and #$08
    eor tmp+6
    beq .r
    lda tmp+5
    and #$33
    sta tmp+5
    lda [tmp+2], y
    and #$CC
    ora tmp+5
    sta tmp+5

.r:
    lda direction_scroll
    cmp #DIRECTION_LEFT
    bne .l

    ldy #$00
    lda [tmp+2], y
    sta tmp+5

    lda scroll_x
    and #$10
    lsr a
    sta tmp+6
    lda scroll_x
    and #$08
    eor tmp+6
    bne .l
    lda tmp+5
    and #$CC
    sta tmp+5
    lda [tmp], y
    and #$33
    ora tmp+5
    sta tmp+5
.l:

    lda tmp+5
    sta DRAW_BUFFER, x ; data
    inx

    lda tmp
    clc
    adc #$01
    sta tmp
    lda tmp+1
    adc #$00
    sta tmp+1

    lda tmp+2
    clc
    adc #$01
    sta tmp+2
    lda tmp+3
    adc #$00
    sta tmp+3

    inc tmp+4
    lda tmp+4
    cmp #NUMBER_OF_ATTR
    beq .elp
    jmp .lp
.elp:

    lda #$00
    sta DRAW_BUFFER, x ; end

    stx ppu_counter

