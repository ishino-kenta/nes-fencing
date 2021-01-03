Reborn:

    lda player1_dead
    beq .Alive1
    dec player1_dead
    lda player1_dead
    bne .Alive1
    lda player2_x
    sec
    sbc #$C0
    sta player1_x
    lda player2_x+1
    sbc #$00
    sta player1_x+1
    lda #$90
    sta player1_y
.Alive1:

    lda player2_dead
    beq .Alive2
    dec player2_dead
    lda player2_dead
    bne .Alive2
    lda player1_x
    clc
    adc #$C0
    sta player2_x
    lda player1_x+1
    adc #$00
    sta player2_x+1
    lda #$90
    sta player2_y
.Alive2:

    rts