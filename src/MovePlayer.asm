SPEED = $01
speed   .rs 1

MovePlayer1:

    ; test code ---
    lda #$01
    sta speed
    lda pad1
    and #PAD_SELECT
    beq .aaa
    lda #$04
    sta speed
.aaa:
    ; test code ---


    ; move player1
    lda player1_atttack_counter
    bne .end1

    lda player1_x
    sta player1_x_pre
    lda player1_x+1
    sta player1_x_pre+1
    
    lda pad1
    and #PAD_RIGHT
    beq .end_right1
    ; test code======
    ; lda pad1
    ; eor pad1_pre
    ; and pad1
    ; and #PAD_RIGHT
    ; beq .end_right1
    ;================
    lda player1_x
    clc
    adc speed
    sta player1_x
    lda player1_x+1
    adc #$00
    sta player1_x+1
.end_right1:
    lda pad1
    and #PAD_LEFT
    beq .end_left1
    ; test code======
    ; lda pad1
    ; eor pad1_pre
    ; and pad1
    ; and #PAD_LEFT
    ; beq .end_left1
    ;================
    lda player1_x
    sec
    sbc speed
    sta player1_x
    lda player1_x+1
    sbc #$00
    sta player1_x+1
    
.end_left1:
.end1:

    rts

MovePlayer2:

    ; move player2
    lda player2_atttack_counter
    bne .end2

    lda player2_x
    sta player2_x_pre
    lda player2_x+1
    sta player2_x_pre+1

    lda pad2
    and #PAD_RIGHT
    beq .end_right2

    lda player2_x
    clc
    adc speed
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
    sbc speed
    sta player2_x
    lda player2_x+1
    sbc #$00
    sta player2_x+1

.end_left2:
.end2:
    rts