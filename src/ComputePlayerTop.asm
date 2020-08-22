player1_y_top .rs 1
player2_y_top .rs 1


ComputePlayerTop:
    ; player 1
    lda player1_y
    sec
    sbc #$17
    sta tmp
    lda player1_crouch
    cmp #CROUCH
    bne .stand1
    lda tmp
    clc
    adc #$0D
    sta tmp
.stand1:
    lda tmp
    sta player1_y_top

    ; player 2
    lda player2_y
    sec
    sbc #$17
    sta tmp
    lda player2_crouch
    cmp #CROUCH
    bne .stand2
    lda tmp
    clc
    adc #$0D
    sta tmp
.stand2:
    lda tmp
    sta player2_y_top

    rts