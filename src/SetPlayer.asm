ATTACK_TABLE1 = $00
ATTACK_TABLE2 = $28
SPRITE_TABLE1 = $00
SPRITE_TABLE2 = $0C

SetPlayer:
    ; set sprite data
    ; player1
    ldx oam_counter

    lda player1_y_top
    sec
    sbc #$01
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
    
    ;
    lda player1_crouch
    cmp #CROUCH
    beq .crouch1

    lda player1_y
    sec
    sbc #$10
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
    jmp .end1
.crouch1:
    lda #$FE
    sta OAM, x
    inx

    lda #$FE
    sta OAM, x
    inx

    lda #$FE
    sta OAM, x
    inx

    lda #$FE
    sta OAM, x
    inx
.end1:
    ;
    lda player1_y
    sec
    sbc #$08
    sta OAM, x
    inx

    lda #03
    sta OAM, x
    inx

    lda #$00
    sta OAM, x
    inx

    lda player1_screen_x
    sta OAM, x
    inx


    ; sword

    lda player1_crouch
    cmp #CROUCH
    beq .off1
    lda player1_fall_index
    bne .off1
    lda player1_speed
    cmp #RUN
    bcs .off1
    jmp .on1
.off1:
    ldy #$00
.loop12:
    lda #$FE
    sta OAM, x
    inx
    iny
    cpy #$08
    bne .loop12
    jmp .end12
.on1:
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
    lda player1_atttack_index
    asl a
    tay
    lda [source_addr], y
    sta tmp ; attack offset sword x

    lda #LOW(spriteSwordTable1)
    clc
    adc tmp+1
    sta source_addr
    lda #HIGH(spriteSwordTable1)
    adc #$00
    sta source_addr+1
    ldy #$00

    lda #$00
    sta tmp+1
.loop1:
    lda player1_sword_height
    clc
    adc [source_addr], y
    clc
    adc player1_y
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
    cmp #$02
    bne .loop1

.end12:

    ; player2
    ;
    lda player2_y_top
    sec
    sbc #$01
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
    ;

    lda player2_crouch
    cmp #CROUCH
    beq .crouch2
    lda player2_y
    sec
    sbc #$10
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
    jmp .end2
.crouch2:
    lda #$FE
    sta OAM, x
    inx

    lda #$FE
    sta OAM, x
    inx

    lda #$FE
    sta OAM, x
    inx

    lda #$FE
    sta OAM, x
    inx
.end2:
    ;
    lda player2_y
    sec
    sbc #$08
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

    lda player2_crouch
    cmp #CROUCH
    beq .off2
    lda player2_fall_index
    bne .off2
    lda player2_speed
    cmp #RUN
    bcs .off2
    jmp .on2
.off2:
    ldy #$00
.loop22:
    lda #$FE
    sta OAM, x
    inx
    iny
    cpy #$08
    bne .loop22
    jmp .end22
.on2:
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
    lda player2_atttack_index
    asl a
    tay
    lda [source_addr], y
    sta tmp

    lda #LOW(spriteSwordTable2)
    clc
    adc tmp+1
    sta source_addr
    lda #HIGH(spriteSwordTable2)
    adc #$00
    sta source_addr+1
    ldy #$00

    lda #$00
    sta tmp+1
.loop2:
    lda player2_sword_height
    clc
    adc [source_addr], y
    clc
    adc player2_y
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
    cmp #$02
    bne .loop2
.end22:

    stx oam_counter

    rts

spriteSwordTable1:
;   .db offset_y, sprite_number, attribute, offset_x
    .db $E6,$04,$00,$08, $E6,$05,$00,$10, $E6,$05,$00,$18 ; right
    .db $E6,$04,$40,$F8, $E6,$05,$40,$F0, $E6,$05,$40,$E8 ; left
spriteSwordTable2:
    .db $E6,$04,$01,$08, $E6,$05,$01,$10, $E6,$05,$01,$18 ; right
    .db $E6,$04,$41,$F8, $E6,$05,$41,$F0, $E6,$05,$41,$E8 ; left
