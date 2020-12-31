POSTURE_LOW = $00
POSTURE_MID = $01
POSTURE_HIGH = $02

ChangePosture:

    ; 突き中は構えを変更しない
    ldy #PLAYER_STAB_INDEX
    lda [variable_addr], y
    beq .Do
    jmp .End
.Do:
    ldy #PAD
    lda [variable_addr], y
    iny
    eor [variable_addr], y
    dey
    and [variable_addr], y
    cmp #PAD_DOWN
    bne .EndDown
    ldy #PLAYER_POSTURE
    lda [variable_addr], y
    cmp #POSTURE_MID
    bne .NextDown
    lda #POSTURE_LOW
    sta [variable_addr], y
.NextDown:
    cmp #POSTURE_HIGH
    bne .EndDown
    lda #POSTURE_MID
    sta [variable_addr], y
.EndDown:

    ldy #PAD
    lda [variable_addr], y
    iny
    eor [variable_addr], y
    dey
    and [variable_addr], y
    cmp #PAD_UP
    bne .EndUp
    ldy #PLAYER_POSTURE
    lda [variable_addr], y
    cmp #POSTURE_MID
    bne .NextUp
    lda #POSTURE_HIGH
    sta [variable_addr], y
.NextUp:
    cmp #POSTURE_LOW
    bne .EndUp
    lda #POSTURE_MID
    sta [variable_addr], y
.EndUp:
.End:
    rts