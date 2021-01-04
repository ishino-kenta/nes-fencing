set_title_counter   .rs 2

SetTitle:

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

    ; タイトル

    ldx #$00
    
    lda #$09
    sta DRAW_BUFF, x
    inx
    lda #INC_1+DATA_ROM
    sta DRAW_BUFF, x
    inx
    lda #$0B
    sta DRAW_BUFF, x
    inx
    lda #$23
    sta DRAW_BUFF, x
    inx
    lda #LOW(pushstartTile)
    sta DRAW_BUFF, x
    inx
    lda #HIGH(pushstartTile)
    sta DRAW_BUFF, x
    inx
    lda #$00
    sta DRAW_BUFF, x

    jsr DrawBG

    lda #$02
    sta set_title_counter
    lda #$00
    sta set_title_counter+1
.TitleLoop:
    ldx #$00
    lda #$1D
    sta DRAW_BUFF, x
    inx
    lda #INC_1+DATA_ROM
    sta DRAW_BUFF, x
    inx
    lda set_title_counter
    sta DRAW_BUFF, x
    inx
    lda #$21
    sta DRAW_BUFF, x
    inx

    lda #LOW(titleTile)
    clc
    adc set_title_counter+1
    sta DRAW_BUFF, x
    inx
    lda #HIGH(titleTile)
    adc #$00
    sta DRAW_BUFF, x
    inx

    lda #$00
    sta DRAW_BUFF, x

    jsr DrawBG

    lda set_title_counter
    clc
    adc #$20
    sta set_title_counter
    lda set_title_counter+1
    clc
    adc #$1D
    sta set_title_counter+1

    lda set_title_counter
    cmp #$C2
    bne .TitleLoop


    lda #$00
    sta draw_buff_counter

    rts

titleTile:
    .incbin "./res/title_hor.tile"
pushstartTile:    
    .incbin "./res/pushstart_hor.tile"

tileIint:
    .dw $2000,$20F0,$21E0,$22D0