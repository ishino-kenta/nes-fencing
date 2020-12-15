;--------------------------------------------------
; 入力したx位置の列を描画バッファに入れる．
; x位置$08ごとに変わっていく．
;
; 入力
; fill_draw_cul
;  タイルを埋めたいところのx位置．
;               
;

NAMETABLE_ADDR = $2000

DRAW_ROW_BUFF = $06C0



FillDrawBuffRow:
    ; 入力を処理

    lda fill_draw_cul
    and #$08
    sta fill_draw_raw ; 2つあるDRAW_ROW_BUFFのどっちを使うか．
    
    ;  fill_draw_cul+1を画面2つ分にマスク
    lda fill_draw_cul
    and #$F0
    sta fill_draw_cul
    lda fill_draw_cul+1
    and #$01
    sta fill_draw_cul+1

    ; 書き込むPPUの位置とTILE_BUFFから持ってくる位置の計算
    ;  fill_draw_buff = (fill_tile_cul / 8 / 2 * 14) + TILE_BUFFER
    ;  fill_draw_nametable = (fill_tile_cul / 8 / 2) * 2 + NAMETABLE_ADDR + $20

    lda fill_draw_cul
    lda fill_draw_cul+1

    lsr fill_draw_cul+1
    ror fill_draw_cul
    
    lda fill_draw_cul
    sta fill_draw_buff
    clc
    lda fill_draw_cul+1
    sta fill_draw_buff+1

    lsr fill_draw_cul+1
    ror fill_draw_cul
    
    lda fill_draw_cul
    clc
    adc fill_draw_buff
    sta fill_draw_buff
    lda fill_draw_cul+1
    adc fill_draw_buff+1
    sta fill_draw_buff+1

    lda fill_draw_cul
    clc
    lda fill_draw_cul+1

    lsr fill_draw_cul+1
    ror fill_draw_cul
    
    lda fill_draw_cul
    clc
    adc fill_draw_buff
    sta fill_draw_buff
    lda fill_draw_cul+1
    adc fill_draw_buff+1
    sta fill_draw_buff+1

    lda fill_draw_buff+1
    clc
    adc #HIGH(TILE_BUFFER)
    sta fill_draw_buff+1

    lda fill_draw_cul
    and #$1F
    clc
    adc #$20
    sta fill_draw_nametable
    lda fill_draw_cul
    and #$20
    lsr a
    lsr a
    lsr a
    clc 
    adc #HIGH(NAMETABLE_ADDR)
    sta fill_draw_nametable+1

    ; DRAW_ROW_BUFFに書き込み
    ; 書き込むのは1列だけ
    
    lda #LOW(DRAW_ROW_BUFF)
    sta fill_draw_raw_buff
    lda #HIGH(DRAW_ROW_BUFF)
    sta fill_draw_raw_buff+1

    lda fill_draw_raw
    cmp #$00
    beq .RawBrch
    lda fill_draw_raw_buff
    clc
    adc #$1C
    sta fill_draw_raw_buff
.RawBrch:

    lda #$00
    sta fill_draw_counter
.Loop:

    ldy fill_draw_counter
    lda [fill_draw_buff], y
    asl a
    asl a
    tax ; objectDataのオフセット
    lda fill_draw_raw
    cmp #$00
    beq .RawObjBrch
    inx
    inx
.RawObjBrch:

    lda fill_draw_counter
    asl a
    tay ; fill_draw_raw_buffのオフセット

    lda objectData, x
    sta [fill_draw_raw_buff], y
    inx
    iny
    lda objectData, x
    sta [fill_draw_raw_buff], y

    inc fill_draw_counter
    lda fill_draw_counter
    cmp #$0E
    bne .Loop

    ; DRAW_BUFFに書き込み
    ; 描画するのは1列だけ

    ldy ppu_counter

    lda fill_draw_raw
    cmp #$00
    beq .RawBrch2

    inc fill_draw_nametable
.RawBrch2:

    lda #$1C
    sta DRAW_BUFF, y
    iny
    lda #INC_32+DATA_ROM
    sta DRAW_BUFF, y
    iny
    lda fill_draw_nametable+1
    sta DRAW_BUFF, y
    iny
    lda fill_draw_nametable
    sta DRAW_BUFF, y
    iny
    lda fill_draw_raw_buff
    sta DRAW_BUFF, y
    iny
    lda fill_draw_raw_buff+1
    sta DRAW_BUFF, y
    iny

    lda #$00
    sta DRAW_BUFF, y

    sty ppu_counter

    rts