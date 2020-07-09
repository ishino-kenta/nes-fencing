SetTile:
    ; first
    ldx ppu_counter
    lda #$1E
    sta DRAW_BUFFER, x ; lenght
    inx
    
    lda #FLAG_INC32+FLAG_MODE_TILE_ROM
    sta DRAW_BUFFER, x ; flag
    inx
    
    lda #$20
    sta DRAW_BUFFER, x ; addr high
    inx
    
    lda scroll_x_pre
    lsr a
    lsr a
    lsr a
    sta DRAW_BUFFER, x ; addr low
    inx
    
    lda scroll_x_pre
    sta tmp
    lda scroll_x_pre+1
    sta tmp+1

    lda direction_scroll
    cmp #DIRECTION_RIGHT
    bne .1
    lda tmp
    clc
    adc #$F8
    sta tmp
    lda tmp+1
    adc #$00
    sta tmp+1
.1:
    lda direction_scroll
    cmp #DIRECTION_LEFT
    bne .2
    lda tmp
    sec
    sbc #$07
    sta tmp
    lda tmp+1
    sbc #$00
    sta tmp+1
.2:

    lda tmp
    and #$F8
    sta tmp
    asl tmp
    rol tmp+1
    asl tmp
    rol tmp+1

    lda tmp
    clc
    adc #LOW(tile1)
    sta DRAW_BUFFER, x ; data high
    inx
    lda tmp+1
    adc #HIGH(tile1)
    sta DRAW_BUFFER, x ; data low
    inx
    
    ; second
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
    sta DRAW_BUFFER, x ; addr low
    inx
    
    lda scroll_x
    sta tmp
    lda scroll_x+1
    sta tmp+1

    lda direction_scroll
    cmp #DIRECTION_RIGHT
    bne .3
    lda tmp
    clc
    adc #$F8
    sta tmp
    lda tmp+1
    adc #$00
    sta tmp+1
.3:
    lda direction_scroll
    cmp #DIRECTION_LEFT
    bne .4
    lda tmp
    sec
    sbc #$07
    sta tmp
    lda tmp+1
    sbc #$00
    sta tmp+1
.4:

    lda tmp
    and #$F8
    sta tmp
    asl tmp
    rol tmp+1
    asl tmp
    rol tmp+1

    lda tmp
    clc
    adc #LOW(tile1)
    sta DRAW_BUFFER, x ; data high
    inx
    lda tmp+1
    adc #HIGH(tile1)
    sta DRAW_BUFFER, x ; data low
    inx
    
    lda #$00
    sta DRAW_BUFFER, x ; end
    stx ppu_counter