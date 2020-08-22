player1_sword_height    .rs 1
player2_sword_height    .rs 1

SWORD_UP = $00
SWORD_MID = $06
SWORD_LOW = $0C

ChangeSwordHeight1:
    ; player1
    lda pad1
    eor pad1_pre
    and pad1
    cmp #PAD_DOWN
    bne .end_down1
    lda player1_sword_height
    cmp #SWORD_MID
    bne .1
    lda #SWORD_LOW
    sta player1_sword_height
.1:
    cmp #SWORD_UP
    bne .end_down1
    lda #SWORD_MID
    sta player1_sword_height
.end_down1:

    lda pad1
    eor pad1_pre
    and pad1
    cmp #PAD_UP
    bne .end_up1
    lda player1_sword_height
    cmp #SWORD_MID
    bne .2
    lda #SWORD_UP
    sta player1_sword_height
.2:
    cmp #SWORD_LOW
    bne .end_up1
    lda #SWORD_MID
    sta player1_sword_height
.end_up1:

    rts

ChangeSwordHeight2:

    ; player2
    lda pad2
    eor pad2_pre
    and pad2
    cmp #PAD_DOWN
    bne .end_down2
    lda player2_sword_height
    cmp #SWORD_MID
    bne .3
    lda #SWORD_LOW
    sta player2_sword_height
.3:
    cmp #SWORD_UP
    bne .end_down2
    lda #SWORD_MID
    sta player2_sword_height
.end_down2:

    lda pad2
    eor pad2_pre
    and pad2
    cmp #PAD_UP
    bne .end_up2
    lda player2_sword_height
    cmp #SWORD_MID
    bne .4
    lda #SWORD_UP
    sta player2_sword_height
.4:
    cmp #SWORD_LOW
    bne .end_up2
    lda #SWORD_MID
    sta player2_sword_height
.end_up2:

    rts