player1_sword_y .rs 1
player2_sword_y .rs 1

ComputeSwordY:
    ; player1
    lda player1_y
    sec
    sbc #$16
    clc
    adc player1_sword_height
    sta player1_sword_y

    ; player2
    lda player2_y
    sec
    sbc #$16
    clc
    adc player2_sword_height
    sta player2_sword_y

    rts


