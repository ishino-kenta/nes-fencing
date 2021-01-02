Reborn:

    lda player1_dead
    beq .Alive1
    dec player1_dead
.Alive1:

    lda player2_dead
    beq .Alive2
    dec player2_dead
.Alive2:

    rts