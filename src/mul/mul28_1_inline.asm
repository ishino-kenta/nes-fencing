NUMBER_OF_TILE = $1C

    asl tmp
    rol tmp+1
    asl tmp
    rol tmp+1

    lda tmp
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