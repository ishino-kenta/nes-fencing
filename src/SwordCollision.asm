SwordCollision:

    lda player1_sword_y
    cmp player2_sword_y
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
    lda player1_hit_back+1
    cmp player2_hit_back+1
    beq .6
    bcc .end1
    jmp .7
.6:
    lda player1_hit_back
    cmp player2_hit_back
    bcc .end1
.7:
    lda player2_hit_front+1
    cmp player1_hit_front+1
    beq .10
    bcc .end1
    jmp .11
.10:
    lda player2_hit_front
    cmp player1_hit_front
    bcc .end1
.11:

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
.end1:
    jmp .end

.p2_p1:
    lda player2_hit_back+1
    cmp player1_hit_back+1
    beq .8
    bcc .end
    jmp .9
.8:
    lda player2_hit_back
    cmp player1_hit_back
    bcc .end
.9:
    lda player1_hit_front+1
    cmp player2_hit_front+1
    beq .13
    bcc .end
    jmp .14
.13:
    lda player1_hit_front
    cmp player2_hit_front
    bcc .end
.14:

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
