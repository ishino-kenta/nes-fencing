player1_jump_speed    .rs 1
player2_jump_speed    .rs 1

Jump1:

    ; jump button processing
    lda pad1
    eor pad1_pre
    and pad1
    and #PAD_A
    beq .j1
    lda player1_atttack_index
    bne .j1
    lda player1_crouch
    cmp #CROUCH
    bne .c
    lda #$06
    sta player1_jump_speed
    jmp .j1
.c:
    lda #$08
    sta player1_jump_speed
.j1:

    ; jump rise processing
    lda player1_y
    sec
    sbc player1_jump_speed
    sta player1_y

    rts
Jump2:

    ; jump button processing
    lda pad2
    eor pad2_pre
    and pad2
    and #PAD_A
    beq .j2
    lda player2_atttack_index
    bne .j2
    lda player2_crouch
    cmp #CROUCH
    bne .c
    lda #$06
    sta player2_jump_speed
    jmp .j2
.c:
    lda #$08
    sta player2_jump_speed
.j2:

    ; jump rise processing
    lda player2_y
    sec
    sbc player2_jump_speed
    sta player2_y

    rts