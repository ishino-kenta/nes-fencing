SetArea:

    ; エリアポインタを設定

    ; 左サイドなら反転
    lda area_num
    and #$80
    bne .Left
.Right:
    lda area_num
    jmp .End
.Left:
    lda area_num
    eor #$FF
    clc
    adc #$01
.End:
    asl a
    clc
    adc #$02
    tay
    lda [stage_pointer], y
    sta area_pointer
    iny
    lda [stage_pointer], y
    sta area_pointer+1

    ; ページ数をバッファリングしておく

    ldy #$00
    lda [area_pointer], y
    sta nrof_page
    dec nrof_page

    rts

draw_area_x .rs 1

DrawArea:

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

    lda draw_area_x
    sec
    sbc #$01
    sta fill_tile_x
    lda #$00
    sta fill_tile_phase
    jsr FillTileBuff
    jsr FillTileBuff
    jsr FillTileBuff
    jsr FillTileBuff

    lda draw_area_x
    sta fill_tile_x
    lda #$00
    sta fill_tile_phase
    jsr FillTileBuff
    jsr FillTileBuff
    jsr FillTileBuff
    jsr FillTileBuff

    lda draw_area_x
    clc
    adc #$01
    sta fill_tile_x
    lda #$00
    sta fill_tile_phase
    jsr FillTileBuff
    jsr FillTileBuff
    jsr FillTileBuff
    jsr FillTileBuff

    lda draw_area_x
    clc
    adc #$02
    sta fill_tile_x
    lda #$00
    sta fill_tile_phase
    jsr FillTileBuff
    jsr FillTileBuff
    jsr FillTileBuff
    jsr FillTileBuff

    ; すべての行の分TILE_BUFFをタイルで埋めて描画する
    dec draw_area_x

    lda #$80
    sta stage_counter
    lda draw_area_x
    sta stage_counter+1
    inc draw_area_x
    inc draw_area_x
.DrawLoop:
    lda stage_counter+1
    sta fill_draw_cul+1
    lda stage_counter
    sta fill_draw_cul
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
    cmp draw_area_x
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

    inc wait_nmi
.Wn2:
    lda wait_nmi
    bne .Wn2

    lda soft2001
    ora #$18
    sta soft2001

    rts