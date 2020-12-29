DIRECTION_RIGHT = 0
DIRECTION_LEFT = 1

sprite_x    .rs 3
sprite_y    .rs 1
sprite_tile    .rs 2
sprite_attr  .rs 1

DrawPlayer:

    ; プレイヤー1

    ; Draw の呼び出しのために値を入れておく

    ; 向きごとのスプライトのタイルのアドレス
    lda player1_direction
    asl a
    tax
    lda spriteData, x
    sta sprite_tile
    inx
    lda spriteData, x
    sta sprite_tile+1

    lda player1_direction
    asl a
    tax
    lda centerX, x
    clc
    adc player1_x
    sta sprite_x
    inx
    lda player1_x+1
    adc centerX, x
    sta sprite_x+1
    
    lda player1_y
    sta sprite_y

    lda player1_direction
    asl a
    asl a
    asl a
    asl a
    asl a
    asl a
    ora #PLAYER1
    sta sprite_attr

    jsr Draw

    ; プレイヤー2

    ; Draw の呼び出しのために値を入れておく
    
    ; 向きごとのスプライトのタイルのアドレス
    lda player2_direction
    asl a
    tax
    lda spriteData, x
    sta sprite_tile
    inx
    lda spriteData, x
    sta sprite_tile+1

    lda player2_direction
    asl a
    tax
    lda centerX, x
    clc
    adc player2_x
    sta sprite_x
    inx
    lda player2_x+1
    adc centerX, x
    sta sprite_x+1
    
    lda player2_y
    sta sprite_y

    lda player2_direction
    asl a
    asl a
    asl a
    asl a
    asl a
    asl a
    ora #PLAYER2
    sta sprite_attr

    jsr Draw
    
    rts

Draw:

    ; 1列目の書き込み
    ldx oam_counter

    lda sprite_x
    sec
    sbc camera_x
    sta sprite_x+2
    lda sprite_x+1
    sbc camera_x+1
    beq .Show11
    jsr Hide
    jmp .End11
.Show11:
    ldy #$00
    jsr Show
.End11:
    ; 2列目の書き込み
    lda sprite_x
    clc
    adc #$08
    sta sprite_x
    lda sprite_x+1
    adc #$00
    sta sprite_x+1
    lda sprite_x
    sec
    sbc camera_x
    sta sprite_x+2
    lda sprite_x+1
    sbc camera_x+1
    beq .Show12
    jsr Hide
    jmp .End12
.Show12:
    ldy #$03
    jsr Show
.End12:

    ; 3列目の書き込み
    lda sprite_x
    clc
    adc #$08
    sta sprite_x
    lda sprite_x+1
    adc #$00
    sta sprite_x+1
    lda sprite_x
    sec
    sbc camera_x
    sta sprite_x+2
    lda sprite_x+1
    sbc camera_x+1
    beq .Show13
    jsr Hide
    jmp .End13
.Show13:
    ldy #$06
    jsr Show
.End13:

    stx oam_counter

    rts


Show:

    tya
    clc
    adc #$03
    sta sprite_tmp
.Loop:
    lda spriteY, y
    clc
    adc sprite_y
    sta OAM, x
    inx
    lda [sprite_tile], y
    sta OAM, x
    inx
    lda sprite_attr
    sta OAM, x
    inx
    lda sprite_x+2
    sta OAM, x
    inx

    iny
    cpy sprite_tmp
    bne .Loop

    rts

Hide:

    txa
    clc
    adc #$0C
    sta sprite_tmp
    lda #$FE
.Loop:
    sta OAM, x
    inx

    cpx sprite_tmp
    bne .Loop

    rts



spriteData:
    .dw spriteRight,spriteLeft

spriteRight:
    .db $04,$14,$24,$05,$15,$25,$06,$16,$26
spriteLeft:
    .db $06,$16,$26,$05,$15,$25,$04,$14,$24
spriteY:
    .db $F0,$F8,$00,$F0,$F8,$00,$F0,$F8,$00

centerX:
    .db $F4,$FF,$F5,$FF