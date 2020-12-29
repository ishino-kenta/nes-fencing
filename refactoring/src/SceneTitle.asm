SceneTitle:

    ; STARTボタン
    ; ステージ情報をセット
    lda pad1
    eor pad1_pre
    and pad1
    and #PAD_START
    bne .DoStart
    jmp .NotStart
.DoStart:
    ; タイトル画面を消す
    
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

    ldx draw_buff_counter
    
    lda #$0A
    sta DRAW_BUFF, x
    inx
    lda #INC_1+DATA_ONE
    sta DRAW_BUFF, x
    inx
    lda #$0B
    sta DRAW_BUFF, x
    inx
    lda #$23
    sta DRAW_BUFF, x
    inx
    lda #$00
    sta DRAW_BUFF, x
    inx
    lda #$00
    sta DRAW_BUFF, x

    jsr DrawBG

    lda #$02
    sta set_title_counter
.TitleLoop:
    ldx #$00
    lda #$1D
    sta DRAW_BUFF, x
    inx
    lda #INC_1+DATA_ONE
    sta DRAW_BUFF, x
    inx
    lda set_title_counter
    sta DRAW_BUFF, x
    inx
    lda #$21
    sta DRAW_BUFF, x
    inx
    lda #$00
    sta DRAW_BUFF, x
    inx

    lda #$00
    sta DRAW_BUFF, x

    jsr DrawBG

    lda set_title_counter
    clc
    adc #$20
    sta set_title_counter

    lda set_title_counter
    cmp #$C2
    bne .TitleLoop

    bit $2002
    lda soft2000
    ora #$80
    sta soft2000
    sta $2000
    lda soft2001
    ora #$18
    sta soft2001

    lda #LOW(SceneStageSelect)
    sta scene
    lda #HIGH(SceneStageSelect)
    sta scene+1

.NotStart:

    jmp MainLoop