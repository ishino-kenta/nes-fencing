ATTACK_TABLE1 = $00
ATTACK_TABLE2 = $28
SPRITE_TABLE1 = $00
SPRITE_TABLE2 = $0C

SetSprite:
    ; set sprite data
    ; player1
    ldx oam_counter
    lda #$8F
    sta OAM, x
    inx
    lda #$01
    sta OAM, x
    inx
    lda #$00
    sta OAM, x
    inx
    lda player1_screen_x
    sta OAM, x
    inx

    lda #$97
    sta OAM, x
    inx
    lda #$02
    sta OAM, x
    inx
    lda #$00
    sta OAM, x
    inx
    lda player1_screen_x
    sta OAM, x
    inx

    lda #$9F
    sta OAM, x
    inx
    lda #$03
    sta OAM, x
    inx
    lda #$00
    sta OAM, x
    inx
    lda player1_screen_x
    sta OAM, x
    inx

    ; sword
    lda player1_direction
    cmp #DIRECTION_RIGHT
    bne .3
    lda #ATTACK_TABLE1
    sta tmp
    lda #SPRITE_TABLE1
    sta tmp+1
.3:
    lda player1_direction
    cmp #DIRECTION_LEFT
    bne .4
    lda #ATTACK_TABLE2
    sta tmp
    lda #SPRITE_TABLE2
    sta tmp+1
.4:

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
    sta tmp ; attack offset sword x

    lda #LOW(spriteTable1)
    clc
    adc tmp+1
    sta source_addr
    lda #HIGH(spriteTable1)
    adc #$00
    sta source_addr+1
    ldy #$00

    lda #$00
    sta tmp+1
.loop1:
    lda player1_sword_height
    asl a
    asl a
    asl a
    clc
    adc [source_addr], y
    sta OAM, x
    inx
    iny
    lda [source_addr], y
    sta OAM, x
    inx
    iny
    lda [source_addr], y
    sta OAM, x
    inx
    iny
    lda player1_screen_x
    beq .6
    clc
    adc [source_addr], y
    sec
    sbc tmp
.6:
    sta OAM, x
    inx
    iny

    inc tmp+1
    lda tmp+1
    cmp #$03
    bne .loop1

    ; player2
    lda #$8F
    sta OAM, x
    inx
    lda #$01
    sta OAM, x
    inx
    lda #$01
    sta OAM, x
    inx
    lda player2_screen_x
    sta OAM, x
    inx
    lda #$97
    sta OAM, x
    inx
    lda #$02
    sta OAM, x
    inx
    lda #$01
    sta OAM, x
    inx
    lda player2_screen_x
    sta OAM, x
    inx
    lda #$9F
    sta OAM, x
    inx
    lda #$03
    sta OAM, x
    inx
    lda #$01
    sta OAM, x
    inx
    lda player2_screen_x
    sta OAM, x
    inx

    ; sword
    lda player2_direction
    cmp #DIRECTION_RIGHT
    bne .1
    lda #ATTACK_TABLE1
    sta tmp
    lda #SPRITE_TABLE1
    sta tmp+1
.1:
    lda player2_direction
    cmp #DIRECTION_LEFT
    bne .2
    lda #ATTACK_TABLE2
    sta tmp
    lda #SPRITE_TABLE2
    sta tmp+1
.2:

    lda #LOW(attackTable)
    clc
    adc tmp
    sta source_addr
    lda #HIGH(attackTable)
    adc #$00
    sta source_addr+1
    lda player2_atttack_counter
    asl a
    tay
    lda [source_addr], y
    sta tmp

    lda #LOW(spriteTable2)
    clc
    adc tmp+1
    sta source_addr
    lda #HIGH(spriteTable2)
    adc #$00
    sta source_addr+1
    ldy #$00

    lda #$00
    sta tmp+1
.loop2:
    lda player2_sword_height
    asl a
    asl a
    asl a
    clc
    adc [source_addr], y
    sta OAM, x
    inx
    iny
    lda [source_addr], y
    sta OAM, x
    inx
    iny
    lda [source_addr], y
    sta OAM, x
    inx
    iny

    lda player2_screen_x
    beq .5
    clc
    adc [source_addr], y
    sec
    sbc tmp
.5:
    sta OAM, x
    inx
    iny

    inc tmp+1
    lda tmp+1
    cmp #$03
    bne .loop2

    stx oam_counter

    rts

spriteTable1:
;   .db offset_y, sprite_number, attribute, offset_x
    .db $8F,$04,$00,$08, $8F,$05,$00,$10, $8F,$05,$00,$18
    .db $8F,$04,$40,$F8, $8F,$05,$40,$F0, $8F,$05,$40,$E8
spriteTable2:
    .db $8F,$04,$01,$08, $8F,$05,$01,$10, $8F,$05,$01,$18
    .db $8F,$04,$41,$F8, $8F,$05,$41,$F0, $8F,$05,$41,$E8
