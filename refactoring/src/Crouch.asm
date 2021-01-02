CROUCH = $08

;--------------------------------------------------
; 入力
;  variable_addr

Crouch:

    ldy #PAD
    lda [variable_addr], y
    and #PAD_DOWN
    beq .NotCrouch
    ; 突き中はしゃがまない
    ldy #PLAYER_STAB_INDEX
    lda [variable_addr], y
    bne .NotCrouch
    ; 空中では処理しない
    ldy #PLAYER_FALL_INDEX
    lda [variable_addr], y
    bne .EndCrouch
    ldy #PLAYER_CROUCH
    lda [variable_addr], y
    clc
    adc #$01
    sta [variable_addr], y
    cmp #CROUCH+1
    bne .EndCrouch
    lda #CROUCH
    sta [variable_addr], y
    jmp .EndCrouch
.NotCrouch:
    ldy #PLAYER_CROUCH
    lda #$00
    sta [variable_addr], y
.EndCrouch:


    rts