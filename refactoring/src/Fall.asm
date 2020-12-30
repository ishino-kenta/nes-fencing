FALL_TABLE_MAX = $22

;--------------------------------------------------
; 入力
;  variable_addr
Fall:

    ; 落下処理
    ldy #PLAYER_FALL_INDEX
    lda [variable_addr], y
    tax
    ldy #PLAYER_Y
    lda fallTable, x
    clc
    adc [variable_addr], y
    sta [variable_addr], y

    ldy #PLAYER_FALL_INDEX
    lda [variable_addr], y
    clc
    adc #$01
    sta [variable_addr], y
    cmp #FALL_TABLE_MAX+1
    bne .End
    lda #FALL_TABLE_MAX
    sta [variable_addr], y
.End:

    rts

fallTable:
    .db $01,$01,$01,$02,$02,$03,$03,$03,$04,$04,$05,$05,$05,$06,$06,$07,$07,$07
    .db $08,$08,$09,$09,$09,$0A,$0A,$0B,$0B,$0B,$0C,$0C,$0D,$0D,$0D,$0E,$0E,$0F