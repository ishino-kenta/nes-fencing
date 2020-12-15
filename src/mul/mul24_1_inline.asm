NUMBER_OF_TILE = $18
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