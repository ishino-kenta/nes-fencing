;--------------------------------------------------
; 入力
;  variable_addr

Jump:

    ldy #PAD
    lda [variable_addr], y
    iny
    eor [variable_addr], y
    dey
    and [variable_addr], y
    and #PAD_A
    beq .EndJump

    ldy #PLAYER_FALL_INDEX
    lda [variable_addr], y
    bne .EndJump

    ldy #PLAYER_CROUCH
    lda [variable_addr], y
    beq .NotCrouch

    ldy #PLAYER_JUMP_SPEED
    lda #$06
    sta [variable_addr], y
    jmp .EndJump
.NotCrouch:

    ldy #PLAYER_JUMP_SPEED
    lda #$08
    sta [variable_addr], y
.EndJump:

    ; 上昇
    ldy #PLAYER_Y
    lda [variable_addr], y
    sec
    ldy #PLAYER_JUMP_SPEED
    sbc [variable_addr], y
    ldy #PLAYER_Y
    sta [variable_addr], y

    rts