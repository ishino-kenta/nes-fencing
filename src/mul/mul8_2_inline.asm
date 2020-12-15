    ; scroll_x / 32 * 8
    lda scroll_x
    sta tmp+1
    lda scroll_x+1
    sta tmp+2

    lsr tmp+2
    ror tmp+1
    lsr tmp+2
    ror tmp+1
    
    lda tmp+1
    and #$FC
    sta tmp+1