    ; player_x / 8 * 24
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