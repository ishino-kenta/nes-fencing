SetBG:
    ldx ppu_counter

    lda #$18
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
    sta tmp+2
    lda tmp+1
    sta tmp+3

    asl tmp+2
    rol tmp+3

    lda tmp
    clc
    adc tmp+2
    sta tmp
    lda tmp+1
    adc tmp+3
    sta tmp+1

    lda tmp
    clc
    adc #LOW(tile1)
    sta DRAW_BUFFER, x ; data high
    inx
    lda tmp+1
    adc #HIGH(tile1)
    sta DRAW_BUFFER, x ; data low
    inx

    ; attribute
    lda #$06
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
    
    ; scroll_x / 32 * 6
    ; right
    lsr tmp+1
    ror tmp
    lsr tmp+1
    ror tmp
    lsr tmp+1
    ror tmp
    lsr tmp+1
    ror tmp
    lsr tmp+1
    ror tmp

    asl tmp
    rol tmp+1
    lda tmp
    sta tmp+4
    lda tmp+1
    sta tmp+5

    asl tmp
    rol tmp+1
    lda tmp
    clc
    adc tmp+4
    sta tmp
    lda tmp+1
    adc tmp+5
    sta tmp+1

    lda tmp
    clc
    adc attr_addr
    sta tmp
    lda tmp+1
    adc attr_addr+1
    sta tmp+1
    ; left
    lsr tmp+3
    ror tmp+2
    lsr tmp+3
    ror tmp+2
    lsr tmp+3
    ror tmp+2
    lsr tmp+3
    ror tmp+2
    lsr tmp+3
    ror tmp+2

    asl tmp+2
    rol tmp+3
    lda tmp+2
    sta tmp+4
    lda tmp+3
    sta tmp+5

    asl tmp+2
    rol tmp+3
    lda tmp+2
    clc
    adc tmp+4
    sta tmp+2
    lda tmp+3
    adc tmp+5
    sta tmp+3

    lda tmp+2
    clc
    adc attr_addr
    sta tmp+2
    lda tmp+3
    adc attr_addr+1
    sta tmp+3

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
    cmp #$06
    beq .elp
    jmp .lp
.elp:

    lda #$00
    sta DRAW_BUFFER, x ; end

    stx ppu_counter

