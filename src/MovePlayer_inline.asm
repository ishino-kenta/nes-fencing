MovePlayer:
    ; move player1
    lda player1_x
    sta player1_x_pre
    lda player1_x+1
    sta player1_x_pre+1
    lda pad1
    and #PAD_RIGHT
    beq .end_right1
    lda player1_x
    clc
    adc #$02
    sta player1_x
    lda player1_x+1
    adc #$00
    sta player1_x+1
.end_right1:
    lda pad1
    and #PAD_LEFT
    beq .end_left1
    lda player1_x
    sec
    sbc #$02
    sta player1_x
    lda player1_x+1
    sbc #$00
    sta player1_x+1
    lda player1_x+1 ; boundary check
    cmp #$00
    bne .end_left1
    lda player1_x_pre
    cmp #$08
    bcc .end_left1
    lda player1_x
    cmp #$08
    bcs .end_left1
    lda #$08
    sta player1_x
.end_left1:

    ; move player2
    lda player2_x
    sta player2_x_pre
    lda player2_x+1
    sta player2_x_pre+1
    lda pad2
    and #PAD_RIGHT
    beq .end_right2
    lda player2_x
    clc
    adc #$02
    sta player2_x
    lda player2_x+1
    adc #$00
    sta player2_x+1
.end_right2:
    lda pad2
    and #PAD_LEFT
    beq .end_left2
    lda player2_x
    sec
    sbc #$02
    sta player2_x
    lda player2_x+1
    sbc #$00
    sta player2_x+1
    lda player2_x+1 ; boundary check
    cmp #$00
    bne .end_left2
    lda player2_x_pre
    cmp #$08
    bcc .end_left2
    lda player2_x
    cmp #$08
    bcs .end_left2
    lda #$08
    sta player2_x
.end_left2:
