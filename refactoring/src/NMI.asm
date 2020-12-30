NMI:

    lda do_draw
    beq .NotDraw
    jsr DrawBG
    lda #$00
    sta do_draw
.NotDraw:

    lda do_dma
    beq .NotDma
    lda #$00
    sta $2003
    lda #HIGH(OAM)
    sta $4014
.NotDma:

    bit $2002 ; スクロールいじる前に必要
    lda camera_x
    sta $2005
    lda #$08 ; attrの調整のために+8
    sta $2005

    lda soft2000
    sta $2000
    lda soft2001
    sta $2001

    dec wait_nmi

    rti
