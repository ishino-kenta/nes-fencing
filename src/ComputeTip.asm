TIP_TABLE1 = $00
TIP_TABLE2 = $08

player1_tip_x   .rs 2
player1_grip_x   .rs 2
player2_tip_x   .rs 2
player2_grip_x   .rs 2

ComputeTip:
    lda player1_direction
    cmp #DIRECTION_RIGHT
    bne .1
    lda #ATTACK_TABLE2
    sta tmp
    lda #ATTACK_TABLE1
    sta tmp+2
    lda #TIP_TABLE1
    sta tmp+4
.1:
    lda player1_direction
    cmp #DIRECTION_LEFT
    bne .2
    lda #ATTACK_TABLE1
    sta tmp
    lda #ATTACK_TABLE2
    sta tmp+2
    lda #TIP_TABLE2
    sta tmp+4
.2:

    lda #LOW(attackTable)
    clc
    adc tmp
    sta source_addr
    lda #HIGH(attackTable)
    adc #$00
    sta source_addr+1
    lda player1_atttack_counter
    asl a
    tay
    lda [source_addr], y
    sta tmp
    iny
    lda [source_addr], y
    sta tmp+1 ; low:tmp, high:tmp+1

    lda #LOW(attackTable)
    clc
    adc tmp+2
    sta source_addr
    lda #HIGH(attackTable)
    adc #$00
    sta source_addr+1
    lda player2_atttack_counter
    asl a
    tay
    lda [source_addr], y
    sta tmp+2
    iny
    lda [source_addr], y
    sta tmp+3 ; low:tmp+2, high:tmp+3

    lda #LOW(tipTable)
    clc
    adc tmp+4
    sta source_addr
    lda #HIGH(tipTable)
    adc #$00
    sta source_addr+1

    ; compute player1 tip position
    lda player1_x
    clc
    adc tmp
    sta tmp
    lda player1_x+1
    adc tmp+1
    sta tmp+1
    ldy #$00
    lda tmp
    clc
    adc [source_addr], y
    sta player1_tip_x
    iny
    lda tmp+1
    adc [source_addr], y
    sta player1_tip_x+1
    iny
    lda tmp
    clc
    adc [source_addr], y
    sta player1_grip_x
    iny
    lda tmp+1
    adc [source_addr], y
    sta player1_grip_x+1
    
    ; compute player2 tip position
    lda player2_x
    clc
    adc tmp+2
    sta tmp+2
    lda player2_x+1
    adc tmp+3
    sta tmp+3
    ldy #$04
    lda tmp+2
    clc
    adc [source_addr], y
    sta player2_tip_x
    iny
    lda tmp+3
    adc [source_addr], y
    sta player2_tip_x+1
    iny
    lda tmp+2
    clc
    adc [source_addr], y
    sta player2_grip_x
    iny
    lda tmp+3
    adc [source_addr], y
    sta player2_grip_x+1

    rts

tipTable:
    .db $1F,$00, $0B,$00, $E8,$FF, $FC,$FF 
    .db $E8,$FF, $FC,$FF, $1F,$00, $0B,$00