WallHit1Right:
    lda player1_y
    lsr a
    lsr a
    lsr a
    tay
.l1:

    lda player1_x
    clc
    adc #$07
    sta tmp
    lda player1_x+1
    adc #$00
    sta tmp+1

    lda tmp
    and #$F8
    sta tmp
    sta tmp+2
    lda tmp+1
    sta tmp+3

    asl tmp
    rol tmp+1

    lda tmp+2
    clc
    adc tmp
    sta tmp
    lda tmp+3
    adc tmp+1
    sta tmp+1
    
    lda #LOW(tile1)
    clc
    adc tmp
    sta tmp
    lda #HIGH(tile1)
    adc tmp+1
    sta tmp+1

    lda [tmp], y
    cmp #$05
    beq .g1
    cmp #$01
    beq .g1
    jmp .e1
.g1:
    lda player1_x
    sec
    sbc #$01
    sta player1_x
    lda player1_x+1
    sbc #$00
    sta player1_x+1
    jmp .l1
.e1:

    lda player1_y_top
    lsr a
    lsr a
    lsr a
    tay
.l2:

    lda player1_x
    clc
    adc #$07
    sta tmp
    lda player1_x+1
    adc #$00
    sta tmp+1

    lda tmp
    and #$F8
    sta tmp
    sta tmp+2
    lda tmp+1
    sta tmp+3

    asl tmp
    rol tmp+1

    lda tmp+2
    clc
    adc tmp
    sta tmp
    lda tmp+3
    adc tmp+1
    sta tmp+1
    
    lda #LOW(tile1)
    clc
    adc tmp
    sta tmp
    lda #HIGH(tile1)
    adc tmp+1
    sta tmp+1

    lda [tmp], y
    cmp #$05
    beq .g2
    cmp #$01
    beq .g2
    jmp .e2
.g2:
    lda player1_x
    sec
    sbc #$01
    sta player1_x
    lda player1_x+1
    sbc #$00
    sta player1_x+1
    jmp .l2
.e2:

    rts
    
WallHit1Left:
    lda player1_y
    lsr a
    lsr a
    lsr a
    tay
.l1:

    lda player1_x
    sta tmp
    lda player1_x+1
    sta tmp+1

    lda tmp
    and #$F8
    sta tmp
    sta tmp+2
    lda tmp+1
    sta tmp+3

    asl tmp
    rol tmp+1

    lda tmp+2
    clc
    adc tmp
    sta tmp
    lda tmp+3
    adc tmp+1
    sta tmp+1
    
    lda #LOW(tile1)
    clc
    adc tmp
    sta tmp
    lda #HIGH(tile1)
    adc tmp+1
    sta tmp+1

    lda [tmp], y
    cmp #$05
    beq .g1
    cmp #$01
    beq .g1
    jmp .e1
.g1:
    lda player1_x
    clc
    adc #$01
    sta player1_x
    lda player1_x+1
    adc #$00
    sta player1_x+1
    jmp .l1
.e1:

    lda player1_y_top
    lsr a
    lsr a
    lsr a
    tay
.l2:

    lda player1_x
    sta tmp
    lda player1_x+1
    sta tmp+1

    lda tmp
    and #$F8
    sta tmp
    sta tmp+2
    lda tmp+1
    sta tmp+3

    asl tmp
    rol tmp+1

    lda tmp+2
    clc
    adc tmp
    sta tmp
    lda tmp+3
    adc tmp+1
    sta tmp+1
    
    lda #LOW(tile1)
    clc
    adc tmp
    sta tmp
    lda #HIGH(tile1)
    adc tmp+1
    sta tmp+1

    lda [tmp], y
    cmp #$05
    beq .g2
    cmp #$01
    beq .g2
    jmp .e2
.g2:
    lda player1_x
    clc
    adc #$01
    sta player1_x
    lda player1_x+1
    adc #$00
    sta player1_x+1
    jmp .l2
.e2:

    rts

WallHit2Right:
    lda player2_y
    lsr a
    lsr a
    lsr a
    tay
.l1:

    lda player2_x
    clc
    adc #$07
    sta tmp
    lda player2_x+1
    adc #$00
    sta tmp+1

    lda tmp
    and #$F8
    sta tmp
    sta tmp+2
    lda tmp+1
    sta tmp+3

    asl tmp
    rol tmp+1

    lda tmp+2
    clc
    adc tmp
    sta tmp
    lda tmp+3
    adc tmp+1
    sta tmp+1
    
    lda #LOW(tile1)
    clc
    adc tmp
    sta tmp
    lda #HIGH(tile1)
    adc tmp+1
    sta tmp+1

    lda [tmp], y
    cmp #$05
    beq .g1
    cmp #$01
    beq .g1
    jmp .e1
.g1:
    lda player2_x
    sec
    sbc #$01
    sta player2_x
    lda player2_x+1
    sbc #$00
    sta player2_x+1
    jmp .l1
.e1:

    lda player2_y_top
    lsr a
    lsr a
    lsr a
    tay
.l2:

    lda player2_x
    clc
    adc #$07
    sta tmp
    lda player2_x+1
    adc #$00
    sta tmp+1

    lda tmp
    and #$F8
    sta tmp
    sta tmp+2
    lda tmp+1
    sta tmp+3

    asl tmp
    rol tmp+1

    lda tmp+2
    clc
    adc tmp
    sta tmp
    lda tmp+3
    adc tmp+1
    sta tmp+1
    
    lda #LOW(tile1)
    clc
    adc tmp
    sta tmp
    lda #HIGH(tile1)
    adc tmp+1
    sta tmp+1

    lda [tmp], y
    cmp #$05
    beq .g2
    cmp #$01
    beq .g2
    jmp .e2
.g2:
    lda player2_x
    sec
    sbc #$01
    sta player2_x
    lda player2_x+1
    sbc #$00
    sta player2_x+1
    jmp .l2
.e2:

    rts
    
WallHit2Left:
    lda player2_y
    lsr a
    lsr a
    lsr a
    tay
.l1:

    lda player2_x
    sta tmp
    lda player2_x+1
    sta tmp+1

    lda tmp
    and #$F8
    sta tmp
    sta tmp+2
    lda tmp+1
    sta tmp+3

    asl tmp
    rol tmp+1

    lda tmp+2
    clc
    adc tmp
    sta tmp
    lda tmp+3
    adc tmp+1
    sta tmp+1
    
    lda #LOW(tile1)
    clc
    adc tmp
    sta tmp
    lda #HIGH(tile1)
    adc tmp+1
    sta tmp+1

    lda [tmp], y
    cmp #$05
    beq .g1
    cmp #$01
    beq .g1
    jmp .e1
.g1:
    lda player2_x
    clc
    adc #$01
    sta player2_x
    lda player2_x+1
    adc #$00
    sta player2_x+1
    jmp .l1
.e1:

    lda player2_y_top
    lsr a
    lsr a
    lsr a
    tay
.l2:

    lda player2_x
    sta tmp
    lda player2_x+1
    sta tmp+1

    lda tmp
    and #$F8
    sta tmp
    sta tmp+2
    lda tmp+1
    sta tmp+3

    asl tmp
    rol tmp+1

    lda tmp+2
    clc
    adc tmp
    sta tmp
    lda tmp+3
    adc tmp+1
    sta tmp+1
    
    lda #LOW(tile1)
    clc
    adc tmp
    sta tmp
    lda #HIGH(tile1)
    adc tmp+1
    sta tmp+1

    lda [tmp], y
    cmp #$05
    beq .g2
    cmp #$01
    beq .g2
    jmp .e2
.g2:
    lda player2_x
    clc
    adc #$01
    sta player2_x
    lda player2_x+1
    adc #$00
    sta player2_x+1
    jmp .l2
.e2:

    rts