Fall1:

    ; 落下処理
    ldx player1_fall_index
    lda fallTable, x
    clc
    adc player1_y
    sta player1_y

    lda player1_fall_index
    clc
    adc #$01
    sta player1_fall_index
    cmp #$23
    bne .End
    lda #$22
    sta player1_fall_index
.End:

    rts

Fall2:

    ; 落下処理
    ldx player2_fall_index
    lda fallTable, x
    clc
    adc player2_y
    sta player2_y

    lda player2_fall_index
    clc
    adc #$01
    sta player2_fall_index
    cmp #$23
    bne .End
    lda #$22
    sta player2_fall_index
.End:

    rts

fallTable:
    .db $01,$01,$01,$02,$02,$03,$03,$03,$04,$04,$05,$05,$05,$06,$06,$07,$07,$07
    .db $08,$08,$09,$09,$09,$0A,$0A,$0B,$0B,$0B,$0C,$0C,$0D,$0D,$0D,$0E,$0E,$0F