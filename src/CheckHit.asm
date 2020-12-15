CHECK_TOP = $00
CHECK_BOTTOM = $01
CHECK_RIGHT = $02
CHECK_LEFT = $03
;--------------------------------------------------
; a: player
; tmp+6: check direction
;
; used: a, x, y, tmp ~ tmp+6
;
; (Code that saves code instead of time)
CheckHit:
    ; player
    asl a
    sta tmp+4
    asl a
    asl a
    clc
    adc tmp+4
    sta tmp+4

    ; first loop
.l1:
    ; set y
    ldx tmp+4
    lda tmp+6
    cmp #CHECK_BOTTOM
    beq .aaa1
    inx
    inx
.aaa1:
    lda hitCheckTable, x
    sta source_addr
    inx
    lda hitCheckTable, x
    sta source_addr+1
    inx

    ldy #$00
    lda [source_addr], y
    sec
    sbc #$08 ; top one line
    lsr a
    lsr a
    lsr a
    sta tmp+5 ; player_y

    ; set x
    ldx tmp+4
    inx
    inx
    inx
    inx
    lda hitCheckTable, x
    sta source_addr
    inx
    lda hitCheckTable, x
    sta source_addr+1

    ldy #$00
    lda tmp+6
    cmp #CHECK_LEFT
    beq .aaa3
    lda [source_addr], y
    clc
    adc #$07
    sta tmp ; player_x
    iny
    lda [source_addr], y
    adc #$00
    sta tmp+1 ; player_x+1
    jmp .aaa4
.aaa3:
    lda [source_addr], y
    sta tmp ; player_x
    iny
    lda [source_addr], y
    sta tmp+1 ; player_x+1
.aaa4:

    lda #LOW(.l1)
    sta source_addr+2
    lda #HIGH(.l1)
    sta source_addr+3
    jsr .sub

    ; second loop
.l2:
    ; set y
    ldx tmp+4
    lda tmp+6
    cmp #CHECK_TOP
    bne .aaa2
    inx
    inx
.aaa2:
    lda hitCheckTable, x
    sta source_addr
    inx
    lda hitCheckTable, x
    sta source_addr+1
    inx

    ldy #$00
    lda [source_addr], y
    sec
    sbc #$08 ; top one line
    lsr a
    lsr a
    lsr a
    sta tmp+5

    ; set x
    ldx tmp+4
    inx
    inx
    inx
    inx
    lda hitCheckTable, x
    sta source_addr
    inx
    lda hitCheckTable, x
    sta source_addr+1

    ldy #$00
    lda tmp+6
    cmp #CHECK_RIGHT
    bne .aaa5
    lda [source_addr], y
    clc
    adc #$07
    sta tmp
    iny
    lda [source_addr], y
    adc #$00
    sta tmp+1
    jmp .aaa6
.aaa5:
    lda [source_addr], y
    sta tmp
    iny
    lda [source_addr], y
    sta tmp+1
.aaa6:

    lda #LOW(.l2)
    sta source_addr+2
    lda #HIGH(.l2)
    sta source_addr+3
    jsr .sub

    rts


.sub:
    inline mul/mul28_4
    
    lda #LOW(tile1)
    clc
    adc tmp
    sta tmp
    lda #HIGH(tile1)
    adc tmp+1
    sta tmp+1

    ldy tmp+5
    lda [tmp], y
    cmp #$05
    beq .g1
    cmp #$01
    beq .g1
    jmp .e1
.g1:

    lda tmp+6
    cmp #CHECK_RIGHT
    bne .nr1

    ldx tmp+4
    inx
    inx
    inx
    inx
    lda hitCheckTable, x
    sta source_addr
    inx
    lda hitCheckTable, x
    sta source_addr+1
    inx

    ldy #$00
    lda [source_addr], y
    sec
    sbc #$01
    sta [source_addr], y
    iny
    lda [source_addr], y
    sbc #$00
    sta [source_addr], y

    pla
    pla
    jmp [source_addr+2]
.nr1:
    cmp #CHECK_LEFT
    bne .nl1

    ldx tmp+4
    inx
    inx
    inx
    inx
    lda hitCheckTable, x
    sta source_addr
    inx
    lda hitCheckTable, x
    sta source_addr+1
    inx

    ldy #$00
    lda [source_addr], y
    clc
    adc #$01
    sta [source_addr], y
    iny
    lda [source_addr], y
    adc #$00
    sta [source_addr], y

    pla
    pla
    jmp [source_addr+2]
.nl1:

    cmp #CHECK_TOP
    bne .nd1

    ldx tmp+4
    lda hitCheckTable, x
    sta source_addr
    inx
    lda hitCheckTable, x
    sta source_addr+1
    inx
    ldy #$00
    lda [source_addr], y
    clc
    adc #$01
    sta [source_addr], y
    iny
    lda [source_addr], y
    adc #$00
    sta [source_addr], y ; y = y + 1

    lda hitCheckTable, x
    sta source_addr
    inx
    lda hitCheckTable, x
    sta source_addr+1
    inx
    ldy #$00
    lda [source_addr], y
    clc
    adc #$01
    sta [source_addr], y
    iny
    lda [source_addr], y
    adc #$00
    sta [source_addr], y ; y_top = y_top + 1
    
    ldy #$00
    inx
    inx
    lda hitCheckTable, x
    sta source_addr
    inx
    lda hitCheckTable, x
    sta source_addr+1
    inx
    lda #FALL_INDEX_HALF
    sta [source_addr], y ; player_fall_index

    pla
    pla
    jmp [source_addr+2]
.nd1:

    cmp #CHECK_BOTTOM
    bne .nb1

    ldx tmp+4
    lda hitCheckTable, x
    sta source_addr
    inx
    lda hitCheckTable, x
    sta source_addr+1
    inx

    ldy #$00
    lda [source_addr], y
    sec
    sbc #$01
    sta [source_addr], y
    iny
    lda [source_addr], y
    sbc #$00
    sta [source_addr], y
    

    ldy #$00
    inx
    inx
    inx
    inx
    lda hitCheckTable, x
    sta source_addr
    inx
    lda hitCheckTable, x
    sta source_addr+1
    inx
    lda #$00
    sta [source_addr], y ; player_fall

    lda hitCheckTable, x
    sta source_addr
    inx
    lda hitCheckTable, x
    sta source_addr+1
    inx
    lda #$00
    sta [source_addr], y ; player_jump_speed

    pla
    pla
    jmp [source_addr+2]
.nb1:
    pla
    pla
    jmp [source_addr+2]
.e1:

    rts

hitCheckTable:
    .dw player1_y, player1_y_top, player1_x, player1_fall_index, player1_jump_speed
    .dw player2_y, player2_y_top, player2_x, player2_fall_index, player2_jump_speed