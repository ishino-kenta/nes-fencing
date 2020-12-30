
STAB_MAX = $10

Stab:

    ; インデックスをSTAB_MAXまで1ずつ進める
    ldy #PLAYER_STAB_INDEX
    lda [variable_addr], y
    beq .StabIterate
    lda [variable_addr], y
    clc
    adc #$01
    sta [variable_addr], y
    lda [variable_addr], y
    cmp #STAB_MAX
    bne .StabIterate
    lda #$00
    sta [variable_addr], y
.StabIterate:

    ldy #PAD
    lda [variable_addr], y
    iny
    eor [variable_addr], y
    dey
    and [variable_addr], y
    and #PAD_B
    beq .EndStab
    ldy #PLAYER_STAB_INDEX
    lda [variable_addr], y
    bne .EndStab
    ldy #PLAYER_FALL_INDEX
    lda [variable_addr], y
    bne .EndStab
    ldy #PLAYER_STAB_INDEX
    lda #$01
    sta [variable_addr], y
.EndStab:

    rts