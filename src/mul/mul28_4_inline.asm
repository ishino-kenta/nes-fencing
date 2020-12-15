    ; player_x / 8 * 28
    lsr tmp+1
    ror tmp

    lda tmp
    and #$FC
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

    asl tmp+2
    rol tmp+3

    lda tmp
    clc
    adc tmp+2
    sta tmp
    lda tmp+1
    adc tmp+3
    sta tmp+1