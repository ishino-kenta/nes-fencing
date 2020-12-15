HURT_RIGHT = $05
HURT_LEFT = $02

CheckHitAttack:

    ; change hit area depending on the direction
    lda player1_x+1
    cmp player2_x+1
    beq .eq
    bcc .p1_p2
    jmp .p2_p1
.eq:
    lda player1_x
    cmp player2_x
    bcc .p1_p2
    jmp .p2_p1
.p1_p2:
    ; player1
    lda player2_x
    clc
    adc #HURT_LEFT
    sta tmp
    lda player2_x+1
    adc #$00
    sta tmp+1

    lda tmp+1
    cmp player1_hit_back+1
    beq .eq1
    bcc .next1
    jmp .end1
.eq1:
    lda tmp
    cmp player1_hit_back
    bcc .next1
    jmp .end1
.next1:

    lda player2_x
    clc
    adc #HURT_RIGHT
    sta tmp
    lda player2_x+1
    adc #$00
    sta tmp+1

    lda player1_hit_front+1
    cmp tmp+1
    beq .eq12
    bcc .next12
    jmp .end1
.eq12:
    lda player1_hit_front
    cmp tmp
    bcc .next12
    jmp .end1
.next12:

    lda player2_y_top
    cmp player1_sword_y
    bcc .next13
    jmp .end1
.next13:
    lda player1_sword_y
    cmp player2_y
    bcc .do1
    jmp .end1
.do1:
    jsr DeadPlayer2
.end1:

    ; player2

    lda player1_x
    clc
    adc #HURT_RIGHT
    sta tmp
    lda player1_x+1
    adc #$00
    sta tmp+1

    lda player2_hit_back+1
    cmp tmp+1
    beq .eq2
    bcc .next2
    jmp .end2
.eq2:
    lda player2_hit_back
    cmp tmp
    bcc .next2
    jmp .end2
.next2:

    lda player1_x
    clc
    adc #HURT_LEFT
    sta tmp
    lda player1_x+1
    adc #$00
    sta tmp+1

    lda tmp+1
    cmp player2_hit_front+1
    beq .eq22
    bcc .next22
    jmp .end2
.eq22:
    lda tmp
    cmp player2_hit_front
    bcc .next22
    jmp .end2
.next22:

    lda player1_y_top
    cmp player2_sword_y
    bcc .next23
    jmp .end2
.next23:
    lda player2_sword_y
    cmp player1_y
    bcc .do2
    jmp .end2
.do2:
    jsr DeadPlayer1
.end2:

    jmp .end




.p2_p1:
    ; player1
    lda player2_x
    clc
    adc #HURT_RIGHT
    sta tmp
    lda player2_x+1
    adc #$00
    sta tmp+1

    lda player1_hit_back+1
    cmp tmp+1
    beq .eq3
    bcc .next3
    jmp .end3
.eq3:
    lda player1_hit_back
    cmp tmp
    bcc .next3
    jmp .end3
.next3:

    lda player2_x
    clc
    adc #HURT_LEFT
    sta tmp
    lda player2_x+1
    adc #$00
    sta tmp+1

    lda tmp+1
    cmp player1_hit_front+1
    beq .eq32
    bcc .next32
    jmp .end3
.eq32:
    lda tmp
    cmp player1_hit_front
    bcc .next32
    jmp .end3
.next32:

    lda player2_y_top
    cmp player1_sword_y
    bcc .next33
    jmp .end3
.next33:
    lda player1_sword_y
    cmp player2_y
    bcc .do3
    jmp .end3
.do3:
    jsr DeadPlayer2
.end3:

    ; player2
    lda player1_x
    clc
    adc #HURT_LEFT
    sta tmp
    lda player1_x+1
    adc #$00
    sta tmp+1

    lda tmp+1
    cmp player2_hit_back+1
    beq .eq4
    bcc .next4
    jmp .end4
.eq4:
    lda tmp
    cmp player2_hit_back
    bcc .next4
    jmp .end4
.next4:

    lda player1_x
    clc
    adc #HURT_RIGHT
    sta tmp
    lda player1_x+1
    adc #$00
    sta tmp+1

    lda player2_hit_front+1
    cmp tmp+1
    beq .eq42
    bcc .next42
    jmp .end4
.eq42:
    lda player2_hit_front
    cmp tmp
    bcc .next42
    jmp .end4
.next42:

    lda player1_y_top
    cmp player2_sword_y
    bcc .next43
    jmp .end4
.next43:
    lda player2_sword_y
    cmp player1_y
    bcc .do4
    jmp .end4
.do4:
    jsr DeadPlayer1
.end4:

.end:

    rts