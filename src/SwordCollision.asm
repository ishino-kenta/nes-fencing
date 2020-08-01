SwordCollision:

    lda player1_sword_height
    cmp player2_sword_height
    beq .start
    jmp .end
.start:
    lda player1_x+1
    cmp player2_x+1
    beq .5
    bcc .p1_p2
    jmp .p2_p1
.5:
    lda player1_x
    cmp player2_x
    bcc .p1_p2
    jmp .p2_p1
    
.p1_p2:
    lda player1_tip_x+1
    cmp player2_tip_x+1
    beq .6
    bcc .end
    jmp .7
.6:
    lda player1_tip_x
    cmp player2_tip_x
    bcc .end
.7:
    lda player1_x
    sec
    sbc #$05
    sta player1_x
    lda player1_x+1
    sbc #$00
    sta player1_x+1

    lda player2_x
    clc
    adc #$05
    sta player2_x
    lda player2_x+1
    adc #$00
    sta player2_x+1
    jmp .end

.p2_p1:
    lda player1_tip_x+1
    cmp player2_tip_x+1
    beq .8
    bcs .end
    jmp .9
.8:
    lda player2_tip_x
    cmp player1_tip_x
    bcc .end
.9:
    lda player2_x
    sec
    sbc #$05
    sta player2_x
    lda player2_x+1
    sbc #$00
    sta player2_x+1

    lda player1_x
    clc
    adc #$05
    sta player1_x
    lda player1_x+1
    adc #$00
    sta player1_x+1
.end:
    rts
