SetArea:

    ; すべての行の分TILE_BUFFをタイルで埋めて描画する

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

    ; すべての行の分TILE_BUFFをタイルで埋めて描画する
    lda #$80
    sta stage_counter
    lda #$FF
    sta stage_counter+1
.DrawLoop:
    lda stage_counter+1
    sta fill_tile_cul+1
    sta fill_draw_cul+1
    lda stage_counter
    sta fill_tile_cul
    sta fill_draw_cul
    jsr FillTileBuff
    jsr DrawTileBuff

    lda stage_counter
    clc
    adc #$08
    sta stage_counter

    lda stage_counter+1
    sta fill_draw_cul+1
    lda stage_counter
    sta fill_draw_cul
    jsr DrawTileBuff

    jsr DrawBG
    lda #$00
    sta draw_buff_counter ; とりあえず0にするけど修正が必要かも

    lda stage_counter
    clc
    adc #$08
    sta stage_counter
    lda stage_counter+1
    adc #$00
    sta stage_counter+1
    
    lda stage_counter+1
    cmp #$01
    bne .DrawLoop
    lda stage_counter
    cmp #$80
    bne .DrawLoop

    lda #$00
    sta DRAW_BUFF

    lda $2002
    lda soft2000
    ora #$80
    sta soft2000
    sta $2000
    lda soft2001
    ora #$18
    sta soft2001

    inc wait_nmi
.Wn2:
    lda wait_nmi
    bne .Wn2

    rts