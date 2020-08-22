NMI:

    lda do_draw
    beq .not_draw
    jsr DrawBG
    lda #$00
    sta do_draw
.not_draw:

    lda do_dma
    beq .not_dma
    lda #$00
    sta $2003
    lda #HIGH(OAM)
    sta $4014
.not_dma:

    bit $20
    lda scroll_x
    sta $2005
    lda scroll_y
    sta $2005

    lda soft2000
    sta $2000
    lda soft2001
    sta $2001

    lda #$00
    sta wait_nmi

    rti
