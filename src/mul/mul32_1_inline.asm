NUMBER_OF_TILE = $1E
    lda tmp
    and #$F8
    sta tmp
    lda tmp+1

    asl tmp
    rol tmp+1
    asl tmp
    rol tmp+1