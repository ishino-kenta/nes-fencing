HitCheck:

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
    adc #$03
    sta tmp
    lda player2_x+1
    adc #$00
    sta tmp+1

    lda tmp+1
    cmp player1_tip_x+1
    beq .eq1
    bcc .next1
    jmp .end1
.eq1:
    lda tmp
    cmp player1_tip_x
    bcc .next1
    jmp .end1
.next1:
    lda player1_grip_x+1
    cmp tmp+1
    bcc .do1
    lda player1_grip_x
    cmp tmp
    bcc .do1
    jmp .end1
.do1:
    jsr DeadPlayer2
.end1:

    ; player2

    lda player1_x
    clc
    adc #$04
    sta tmp
    lda player1_x+1
    adc #$00
    sta tmp+1

    lda player2_tip_x+1
    cmp tmp+1
    beq .eq2
    bcc .next2
    jmp .end2
.eq2:
    lda player2_tip_x
    cmp tmp
    bcc .next2
    jmp .end2
.next2:

    lda tmp+1
    cmp player2_grip_x+1
    bcc .do2
    lda tmp
    cmp player2_grip_x
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
    adc #$04
    sta tmp
    lda player2_x+1
    adc #$00
    sta tmp+1

    lda player1_tip_x+1
    cmp tmp+1
    beq .eq3
    bcc .next3
    jmp .end3
.eq3:
    lda player1_tip_x
    cmp tmp
    bcc .next3
    jmp .end3
.next3:
    lda tmp+1
    cmp player1_grip_x+1
    bcc .do3
    lda tmp
    cmp player1_grip_x
    bcc .do3
    jmp .end3
.do3:
    jsr DeadPlayer2
.end3:

    ; player2
    lda player1_x
    clc
    adc #$03
    sta tmp
    lda player1_x+1
    adc #$00
    sta tmp+1

    lda tmp+1
    cmp player2_tip_x+1
    beq .eq4
    bcc .next4
    jmp .end4
.eq4:
    lda tmp
    cmp player2_tip_x
    bcc .next4
    jmp .end4
.next4:
    lda player2_grip_x+1
    cmp tmp+1
    bcc .do4
    lda player2_grip_x
    cmp tmp
    bcc .do4
    jmp .end4
.do4:
    jsr DeadPlayer1

.end4:

.end:



    rts