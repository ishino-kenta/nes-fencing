MoveScreen:
    ; compule screen scrolling from player position
    lda scroll_x
    sta scroll_x_pre
    lda scroll_x+1
    sta scroll_x_pre+1

    lda player1_x
    clc
    adc player2_x
    sta tmp
    lda player1_x+1
    adc player2_x+1
    sta tmp+1
    lda #$00
    adc #$00
    sta tmp+2
    lsr tmp+2
    ror tmp+1
    ror tmp
    lda tmp
    sec
    sbc #$80
    sta scroll_x
    lda tmp+1
    sbc #$00
    sta scroll_x+1

    lda scroll_x_pre+1
    cmp #$00
    bne .e
    lda scroll_x+1
    cmp #$FF
    bne .e
    lda #$00
    sta scroll_x
    sta scroll_x+1
.e:

    and #$01
    sta nt_base

    ; compule screen scrolling direction
    lda scroll_x+1
    cmp scroll_x_pre+1
    beq .1
    bcc .left
    jmp .right
.1:
    lda scroll_x
    cmp scroll_x_pre
    bcc .left
    jmp .right
.left:
    lda #DIRECTION_LEFT
    jmp .end
.right:
    lda #DIRECTION_RIGHT
.end:
    sta direction_scroll
    sta test
