;--------------------------------------------------
; 入力
;  variable_addr

Crouch:

    ldy #PLAYER_CROUCH
    lda #$00
    sta [variable_addr], y

    ldy #PAD
    lda [variable_addr], y
    and #PAD_DOWN
    beq .NotCrouch
    ldy #PLAYER_CROUCH
    lda #$01
    sta [variable_addr], y
.NotCrouch:


    rts