player1_fall    .rs 1
player1_jump_speed    .rs 1
player2_fall    .rs 1
player2_jump_speed    .rs 1
Sandbox:

    lda #LOW(Sandbox)
    sta test+1
    lda #HIGH(Sandbox)
    sta test

    ; player1
    ; jump button processing
    lda pad1
    eor pad1_pre
    and pad1
    and #PAD_B
    beq .j1
    lda #$08
    sta player1_jump_speed
.j1:

    ; jump rise processing
    lda player1_y
    sec
    sbc player1_jump_speed
    sta player1_y

    ; gravity fall processing
    ldx player1_fall
    lda .table, x
    clc
    adc player1_y
    sta player1_y

    lda player1_fall
    clc
    adc #$01
    sta player1_fall
    cmp #$23
    bne .s1
    lda #$22
    sta player1_fall
.s1:

    ; floor hit processing
    ; left
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
    
.l1:
    lda player1_y
    lsr a
    lsr a
    lsr a
    tay

    lda [tmp], y
    cmp #$05
    beq .g1
    cmp #$01
    beq .g1
    jmp .e1
.g1:
    dec player1_y
    lda #$00
    sta player1_fall
    sta player1_jump_speed
    jmp .l1
.e1:

    ; right
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
    
.l2:
    lda player1_y
    lsr a
    lsr a
    lsr a
    tay

    lda [tmp], y
    cmp #$05
    beq .g2
    cmp #$01
    beq .g2
    jmp .e2
.g2:
    dec player1_y
    lda #$00
    sta player1_fall
    sta player1_jump_speed
    jmp .l2
.e2:







    ; player2
    ; jump button processing
    lda pad2
    eor pad2_pre
    and pad2
    and #PAD_B
    beq .j2
    lda #$08
    sta player2_jump_speed
.j2:

    ; jump rise processing
    lda player2_y
    sec
    sbc player2_jump_speed
    sta player2_y

    ; gravity fall processing
    ldx player2_fall
    lda .table, x
    clc
    adc player2_y
    sta player2_y

    lda player2_fall
    clc
    adc #$01
    sta player2_fall
    cmp #$23
    bne .s2
    lda #$22
    sta player2_fall
.s2:

    ; floor hit processing
    ; left
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
    
.l3:
    lda player2_y
    lsr a
    lsr a
    lsr a
    tay

    lda [tmp], y
    cmp #$05
    beq .g3
    cmp #$01
    beq .g3
    jmp .e3
.g3:
    dec player2_y
    lda #$00
    sta player2_fall
    sta player2_jump_speed
    jmp .l3
.e3:

    ; right
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
    
.l4:
    lda player2_y
    lsr a
    lsr a
    lsr a
    tay

    lda [tmp], y
    cmp #$05
    beq .g4
    cmp #$01
    beq .g4
    jmp .e4
.g4:
    dec player2_y
    lda #$00
    sta player2_fall
    sta player2_jump_speed
    jmp .l4
.e4:

    rts

.table:
    .db $01,$01,$01,$02,$02,$03,$03,$03,$04,$04,$05,$05,$05,$06,$06,$07,$07,$07
    .db $08,$08,$09,$09,$09,$0A,$0A,$0B,$0B,$0B,$0C,$0C,$0D,$0D,$0D,$0E,$0E,$0F