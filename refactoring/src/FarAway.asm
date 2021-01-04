far_away    .rs 2

FarAway:

    lda leadplayer
    cmp #LEAD_PLAYER1
    bne .Lead2
.Lead1:
    lda #LOW(VARIABLE_PLAYER1)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER1)
    sta variable_addr+1
    lda #LOW(VARIABLE_PLAYER2)
    sta variable_addr+2
    lda #HIGH(VARIABLE_PLAYER2)
    sta variable_addr+3
    jmp .EndLead
.Lead2:
    lda #LOW(VARIABLE_PLAYER2)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER2)
    sta variable_addr+1
    lda #LOW(VARIABLE_PLAYER1)
    sta variable_addr+2
    lda #HIGH(VARIABLE_PLAYER1)
    sta variable_addr+3
.EndLead:

    ldy #PLAYER_X
    lda [variable_addr], y
    sec
    sbc [variable_addr+2], y
    sta far_away
    iny
    lda [variable_addr], y
    sbc [variable_addr+2], y
    sta far_away+1

    lda far_away+1
    and #$80
    beq .Right
    lda far_away
    eor #$FF
    sta far_away
    lda far_away+1
    eor #$FF
    sta far_away+1
    lda far_away
    clc
    adc #$01
    sta far_away
    lda far_away
    adc #$00
    sta far_away
.Right:

    lda far_away+1
    beq .NotDead
    ldy #PLAYER_DEAD
    lda [variable_addr+2], y
    bne .NotDead
    lda #DEAD_TIME
    sta [variable_addr+2], y
.NotDead:

    rts