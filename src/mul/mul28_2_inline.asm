    ; (scroll_x / 8 + tmp) * 28
    lda scroll_x
    sta tmp+1
    lda scroll_x+1
    sta tmp+2

    lsr tmp+2
    ror tmp+1
    lsr tmp+2
    ror tmp+1
    lsr tmp+2
    ror tmp+1

    lda tmp+1
    clc
    adc tmp
    sta tmp+1
    lda tmp+2
    adc #$00
    sta tmp+2

    lda tmp+1
    and #$1F
    sta tmp+1
    lda #$00
    sta tmp+2

    lda tmp+1
    cmp #$00
    bne .skip
    inc tmp+7
.skip:

    lda scroll_x+1
    clc
    adc tmp+7
    tay
    lda testData, y
    and #$07
    asl a
    asl a
    asl a
    asl a
    asl a
    clc
    adc tmp+1
    sta tmp+1
    lda tmp+2
    adc #$00
    sta tmp+2

    asl tmp+1
    rol tmp+2
    asl tmp+1
    rol tmp+2
    lda tmp+1
    sta tmp+3
    lda tmp+2
    sta tmp+4

    asl tmp+3
    rol tmp+4

    lda tmp+1
    clc
    adc tmp+3
    sta tmp+1
    lda tmp+2
    adc tmp+4
    sta tmp+2

    asl tmp+3
    rol tmp+4

    lda tmp+1
    clc
    adc tmp+3
    sta tmp+1
    lda tmp+2
    adc tmp+4
    sta tmp+2