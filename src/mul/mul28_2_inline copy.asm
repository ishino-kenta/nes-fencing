    ; scroll_x / 8 * 28
    lda scroll_x
    sta tmp+1
    lda scroll_x+1
    sta tmp+2

    lsr tmp+2
    ror tmp+1
    lda tmp+1
    and #$FC
    sta tmp+3
    lda tmp+2
    sta tmp+4

    asl tmp+1
    rol tmp+2
    lda tmp+1
    clc
    adc tmp+3
    sta tmp+3
    lda tmp+2
    adc tmp+4
    sta tmp+4

    asl tmp+1
    rol tmp+2
    lda tmp+1
    clc
    adc tmp+3
    sta tmp+1
    lda tmp+2
    adc tmp+4
    sta tmp+2

    ; tmp * 28
    lda tmp
    sta tmp+3
    lda #$00
    sta tmp+4

    asl tmp+3
    rol tmp+4
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

    asl tmp+3
    rol tmp+4
    
    lda tmp+1
    clc
    adc tmp+3
    sta tmp+1
    lda tmp+2
    adc tmp+4
    sta tmp+2