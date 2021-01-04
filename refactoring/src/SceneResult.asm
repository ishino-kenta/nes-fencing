SceneResult:

    lda pad1
    and #PAD_START
    bne .DoResult
    jmp .NotResult
.DoResult:

    ; 大量に描画するのでグラフィックをオフ
    lda soft2000
    and #$7F
    sta soft2000
    lda soft2001
    and #$E7
    sta soft2001

    inc wait_nmi
.Wn1:
    lda wait_nmi
    bne .Wn1

    ; タイル初期化
    ldx #$00
    ldy #$00
.TileInitLoop:
    lda #$F0
    sta DRAW_BUFF, x
    inx
    lda #INC_1+DATA_ONE
    sta DRAW_BUFF, x
    inx
    lda tileIint, y
    sta DRAW_BUFF, x
    inx
    iny
    lda tileIint, y
    sta DRAW_BUFF, x
    inx
    iny
    lda #$00
    sta DRAW_BUFF, x
    inx

    cpy #$08
    bne .TileInitLoop

    lda #$00
    sta DRAW_BUFF, x

    jsr DrawBG

    ; 属性初期化
    ldx #$00
    lda #$40
    sta DRAW_BUFF, x
    inx
    lda #INC_1+DATA_ONE
    sta DRAW_BUFF, x
    inx
    lda #$C0
    sta DRAW_BUFF, x
    inx
    iny
    lda #$23
    sta DRAW_BUFF, x
    inx
    iny
    lda #$00
    sta DRAW_BUFF, x
    inx
    lda #$00
    sta DRAW_BUFF, x
    jsr DrawBG

    ; スプライト削除
    ldx #$00
.SprLoop:
    lda #$FE
    sta OAM, x
    inx
    cpx #$58
    bne .SprLoop

    lda $2002
    lda soft2000
    ora #$80
    sta soft2000
    sta $2000

    inc wait_nmi
.Wn2:
    lda wait_nmi
    bne .Wn2

    lda soft2001
    ora #$18
    sta soft2001

    lda #LOW(SceneStageSelect)
    sta scene
    lda #HIGH(SceneStageSelect)
    sta scene+1

.NotResult:

    jmp MainLoop