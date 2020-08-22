player1_crouch  .rs 1
player2_crouch  .rs 1
CROUCH = $08

Crouch1:

    lda pad1
    and #PAD_DOWN
    beq .n1
    lda player1_crouch
    clc
    adc #$01
    sta player1_crouch
    cmp #CROUCH+1
    bne .end1
    dec player1_crouch
    jmp .end1
.n1:
    lda #$00
    sta player1_crouch
.end1:

    rts

Crouch2:

    lda pad2
    and #PAD_DOWN
    beq .n2
    lda player2_crouch
    clc
    adc #$01
    sta player2_crouch
    cmp #CROUCH+1
    bne .end2
    dec player2_crouch
    jmp .end2
.n2:
    lda #$00
    sta player2_crouch
.end2:
    rts