Move1:
    ; プレイヤー1の移動
    lda pad1
    and #PAD_RIGHT
    beq .NotRight1
    lda player1_x
    clc
    adc #$01
    sta player1_x
    lda player1_x+1
    adc #$00
    sta player1_x+1
.NotRight1:
    lda pad1
    and #PAD_LEFT
    beq .NotLeft1
    lda player1_x
    sec
    sbc #$01
    sta player1_x
    lda player1_x+1
    sbc #$00
    sta player1_x+1
.NotLeft1:

    lda pad1
    and #PAD_UP
    beq .NotUp1
    lda player1_y
    sec
    sbc #$01
    sta player1_y
.NotUp1:
    lda pad1
    and #PAD_DOWN
    beq .NotDown1
    lda player1_y
    clc
    adc #$01
    sta player1_y
.NotDown1:

    rts

Move2:

    ; プレイヤー2の移動
    lda pad2
    and #PAD_RIGHT
    beq .NotRight2
    lda player2_x
    clc
    adc #$02
    sta player2_x
    lda player2_x+1
    adc #$00
    sta player2_x+1
.NotRight2:
    lda pad2
    and #PAD_LEFT
    beq .NotLeft2
    lda player2_x
    sec
    sbc #$02
    sta player2_x
    lda player2_x+1
    sbc #$00
    sta player2_x+1
.NotLeft2:

    lda pad2
    and #PAD_UP
    beq .NotUp2
    lda player2_y
    sec
    sbc #$01
    sta player2_y
.NotUp2:
    lda pad2
    and #PAD_DOWN
    beq .NotDown2
    lda player2_y
    clc
    adc #$01
    sta player2_y
.NotDown2:

    rts