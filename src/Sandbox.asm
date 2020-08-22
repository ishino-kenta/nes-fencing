Sandbox:

    lda #CHECK_RIGHT
    sta tmp+6
    lda #PLAYER1
    asl a
    sta tmp+4
    asl a
    asl a
    clc
    adc tmp+4
    sta tmp+4

    ; first loop
.l1:
    ; set y
    ldx tmp+4
    lda tmp+6
    cmp #CHECK_BOTTOM
    beq .aaa1
    inx
    inx
.aaa1:
    lda hitCheckTable, x
    sta source_addr
    inx
    lda hitCheckTable, x
    sta source_addr+1
    inx

    ldy #$00
    lda [source_addr], y
    lsr a
    lsr a
    lsr a
    sta tmp+5

    ; set x
    ldx tmp+4
    inx
    inx
    inx
    inx
    lda hitCheckTable, x
    sta source_addr
    inx
    lda hitCheckTable, x
    sta source_addr+1

    ldy #$00
    lda tmp+6
    cmp #CHECK_LEFT
    beq .aaa3
    lda [source_addr], y
    clc
    adc #$07
    sta tmp
    iny
    lda [source_addr], y
    adc #$00
    sta tmp+1
    jmp .aaa4
.aaa3:
    lda [source_addr], y
    sta tmp
    iny
    lda [source_addr], y
    sta tmp+1
.aaa4:

    lda tmp
    and #$F8
    sta tmp
    sta tmp+2
    lda tmp+1
    sta tmp+3

    asl tmp
    rol tmp+1

    lda tmp+2
    clc
    adc tmp
    sta tmp
    lda tmp+3
    adc tmp+1
    sta tmp+1
    
    lda #LOW(tile1)
    clc
    adc tmp
    sta tmp
    lda #HIGH(tile1)
    adc tmp+1
    sta tmp+1

    ldy tmp+5
    lda [tmp], y
    sta test
    rts