    ; player_x / 8 * 32
    lda tmp
    and #$F8
    sta tmp

    asl tmp
    rol tmp+1
    asl tmp
    rol tmp+1