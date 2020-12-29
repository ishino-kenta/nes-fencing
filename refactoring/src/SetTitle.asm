set_title_counter   .rs 2

SetTitle:

    ldx draw_buff_counter
    
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