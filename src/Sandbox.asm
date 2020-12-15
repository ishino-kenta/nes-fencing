Sandbox:

    lda scroll_x
    sta test+1
    sec
    sbc #$08
    sta tmp
    lda scroll_x+1
    sta test
    sbc #$00
    sta tmp+1
    ; number
    ldx tmp+1
    cpx #$FF
    bne .aaa
    ldx #$00
.aaa:
    lda testData, x
    sta tmp+2
    inx
    lda testData, x
    sta tmp+3
    ; bank
    lsr tmp+2
    lsr tmp+2
    lsr tmp+2

    lsr tmp+3
    lsr tmp+3
    lsr tmp+3

    ; bank change
    lda #$06
    sta $8000
    lda tmp+2
    sta $8001

    lda #$07
    sta $8000
    lda tmp+3
    sta $8001


    rts

Sandbox3:

    lda pad1
    and #PAD_RIGHT
    beq .r
    lda direction_scroll
    cmp #DIRECTION_RIGHT
    bne .r2
    lda scroll_x
    clc
    adc #$01
    sta scroll_x
    lda scroll_x+1
    adc #$00
    sta scroll_x+1
.r2:
    lda #DIRECTION_RIGHT
    sta direction_scroll
.r:

    lda pad1
    and #PAD_LEFT
    beq .l
    lda direction_scroll
    cmp #DIRECTION_LEFT
    bne .l2
    lda scroll_x
    sec
    sbc #$01
    sta scroll_x
    lda scroll_x+1
    sbc #$00
    sta scroll_x+1
.l2:
    lda #DIRECTION_LEFT
    sta direction_scroll
.l:

    rts