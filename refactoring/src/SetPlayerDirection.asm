SetPlayerDirection:

    lda player1_x+1
    cmp player2_x+1
    beq .Next
    bcc .Direction12
    jmp .Direction21
.Next:
    lda player1_x
    cmp player2_x
    bcc .Direction12
.Direction21:
    lda #DIRECTION_LEFT
    sta player1_direction
    lda #DIRECTION_RIGHT
    sta player2_direction
    jmp .End
.Direction12:
    lda #DIRECTION_RIGHT
    sta player1_direction
    lda #DIRECTION_LEFT
    sta player2_direction
.End:
    rts