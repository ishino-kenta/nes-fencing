TIP_TABLE1 = $00
TIP_TABLE2 = $08

player1_hit_back   .rs 2
player1_hit_front   .rs 2
player2_hit_back   .rs 2
player2_hit_front   .rs 2

ComputeTip:

    ; Table setting
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
    lda player1_atttack_index
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
    lda player2_atttack_index
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

    lda player1_crouch
    cmp #CROUCH
    beq .off1
    lda player1_fall_index
    bne .off1
    lda player1_speed_index
    cmp #RUN
    bcs .off1
    jmp .on1
.off1:
    lda #$FF
    sta player1_hit_back
    sta player1_hit_back+1
    sta player1_hit_front
    sta player1_hit_front+1
    jmp .end1
.on1:
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
    sta player1_hit_back
    iny
    lda tmp+1
    adc [source_addr], y
    sta player1_hit_back+1
    iny
    lda tmp
    clc
    adc [source_addr], y
    sta player1_hit_front
    iny
    lda tmp+1
    adc [source_addr], y
    sta player1_hit_front+1
.end1:

    ; compute player2 tip position

    lda player2_crouch
    cmp #CROUCH
    beq .off2
    lda player2_fall_index
    bne .off2
    lda player2_speed_index
    cmp #RUN
    bcs .off2
    jmp .on2
.off2:
    lda #$FF
    sta player2_hit_back
    sta player2_hit_back+1
    sta player2_hit_front
    sta player2_hit_front+1
    jmp .end2
.on2:

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
    sta player2_hit_back
    iny
    lda tmp+3
    adc [source_addr], y
    sta player2_hit_back+1
    iny
    lda tmp+2
    clc
    adc [source_addr], y
    sta player2_hit_front
    iny
    lda tmp+3
    adc [source_addr], y
    sta player2_hit_front+1
.end2:
    rts

tipTable:
    .db $17,$00, $0A,$00, $F0,$FF, $FD,$FF 
    .db $F0,$FF, $FD,$FF, $17,$00, $0A,$00