SetArea:

    ; すべての行の分TILE_BUFFをタイルで埋めて描画する
    lda soft2000
    and #$7F
    sta soft2000
    sta $2000 ; 大量に描画するのでグラフィックをオフにする
    lda soft2001
    and #$E7
    sta soft2001
    sta $2001

    lda #$80
    sta stage_counter
    lda #$FF
    sta stage_counter+1
.Loop:
    lda stage_counter+1
    sta fill_tile_cul+1
    sta fill_draw_cul+1
    lda stage_counter
    sta fill_tile_cul
    sta fill_draw_cul
    jsr FillTileBuffRow
    lda #$00
    sta fill_draw_raw
    jsr FillDrawBuffRow

    lda stage_counter
    clc
    adc #$08
    sta stage_counter

    lda stage_counter+1
    sta fill_draw_cul+1
    lda stage_counter
    sta fill_draw_cul
    lda #$01
    sta fill_draw_raw
    jsr FillDrawBuffRow

    jsr DrawBG
    lda #$00
    sta ppu_counter ; とりあえず0にするけど修正が必要かも

    lda stage_counter
    clc
    adc #$08
    sta stage_counter
    lda stage_counter+1
    adc #$00
    sta stage_counter+1
    
    lda stage_counter+1
    cmp #$01
    bne .Loop
    lda stage_counter
    cmp #$80
    bne .Loop

    lda soft2000
    ora #$80
    sta soft2000
    sta $2000
    lda soft2001
    ora #$18
    sta soft2001

    rts