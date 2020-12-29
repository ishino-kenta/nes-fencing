;--------------------------------------------------
; TILE_BUFFから描画するデータを構成する．
; 入力したx位置の列を描画バッファに入れる．
; x位置$08ごとに変わっていく．
;
; 入力
;  fill_draw_cul
;   タイルを埋めたいところのx位置．
; 変更する変数
;  draw_buff_counter
;  fill_draw_raw
;  fill_draw_buff
;  fill_draw_nametable
;  fill_draw_counter
;  

NAMETABLE_ADDR = $2000
NAMETABLE_ATTR_ADDR = $23C0

DRAW_ROW_BUFF = $06C0
DRAW_ROW_ATTR_BUFF = $06F8

DrawTileBuff:

    ; 初めにtileを書き込み

    ; DRAW_BUFFへ書き込み ヘッダとフラグ
    ldy draw_buff_counter
    lda #$1C
    sta DRAW_BUFF, y
    iny
    lda #INC_32+DATA_BUFF
    sta DRAW_BUFF, y
    iny
    sty draw_buff_counter

    ; 入力を処理
    lda fill_draw_cul
    and #$18
    sta fill_draw_raw ; 2*2のタイルの左右どちらかの情報
    
    ; 前処理
    lda fill_draw_cul
    and #$F0
    sta fill_draw_cul
    lda fill_draw_cul+1
    and #$01 ; 画面2つ分にマスク
    sta fill_draw_cul+1

    ; TILE_BUFFから持ってくる位置と書き込むPPUの位置の計算
    ;  fill_draw_buff = (fill_draw_cul / 8 / 2 * 14) + TILE_BUFF
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
    adc #HIGH(TILE_BUFF)
    sta fill_draw_buff+1

    ;  fill_draw_nametable = (fill_draw_cul / 8 / 2) * 2 + NAMETABLE_ADDR + $40
    lda fill_draw_cul
    and #$1F
    clc
    adc #$40 ; yのスクロールと合わせてattrの調整をする
    sta fill_draw_nametable
    lda fill_draw_cul
    and #$20
    lsr a
    lsr a
    lsr a
    clc 
    adc #HIGH(NAMETABLE_ADDR)
    sta fill_draw_nametable+1
    lda fill_draw_raw
    and #$08
    lsr a
    lsr a
    lsr a
    clc
    adc fill_draw_nametable
    sta fill_draw_nametable

    ; DRAW_BUFFへ書き込み 書き込むアドレス
    ldy draw_buff_counter
    lda fill_draw_nametable
    sta DRAW_BUFF, y
    iny
    lda fill_draw_nametable+1
    sta DRAW_BUFF, y
    iny
    sty draw_buff_counter

    ; データ書き込みのループ
    lda #$00
    sta fill_draw_counter
.Loop:

    ldy fill_draw_counter
    lda [fill_draw_buff], y
    asl a
    asl a
    tax ; objectTileDataのオフセット
    lda fill_draw_raw
    and #$08
    cmp #$00
    beq .RawObjBrch
    inx
    inx
.RawObjBrch:

    ; DRAW_BUFFへ書き込み データ
    ldy draw_buff_counter
    lda objectTileData, x
    sta DRAW_BUFF, y
    inx
    iny
    lda objectTileData, x
    sta DRAW_BUFF, y
    iny
    sty draw_buff_counter

    inc fill_draw_counter
    lda fill_draw_counter
    cmp #$0E
    bne .Loop

    ; ここからattribute

    ; DRAW_BUFFへ書き込み ヘッダとフラグ
    ldy draw_buff_counter
    lda #$08
    sta DRAW_BUFF, y
    iny
    lda #INC_8+DATA_BUFF
    sta DRAW_BUFF, y
    iny
    sty draw_buff_counter

    ; 書き込むPPUの位置を計算
    lda fill_draw_nametable+1
    and #$04
    sta fill_draw_nametable+1
    lda fill_draw_nametable
    sec
    sbc #$40
    lsr a
    lsr a
    clc
    adc #LOW(NAMETABLE_ATTR_ADDR)
    sta fill_draw_nametable
    lda #HIGH(NAMETABLE_ATTR_ADDR)
    adc fill_draw_nametable+1
    sta fill_draw_nametable+1

    ; DRAW_BUFFへ書き込み 書き込むアドレス
    ldy draw_buff_counter
    lda fill_draw_nametable
    sta DRAW_BUFF, y
    iny
    lda fill_draw_nametable+1
    sta DRAW_BUFF, y
    iny
    sty draw_buff_counter

    ; DRAW_BUFF内のfill_draw_buffの左側を計算
    lda fill_draw_buff+1
    cmp #$05
    bne .Copy
    lda fill_draw_buff
    cmp #$00
    bne .Copy
.NotCopy:
    lda #$06
    sta fill_draw_cul+2
    lda #$B2
    sta fill_draw_cul+1
    jmp .EndCopy
.Copy:
    lda fill_draw_buff
    sec
    sbc #$0E
    sta fill_draw_cul+1
    lda fill_draw_buff+1
    sbc #$00
    sta fill_draw_cul+2
.EndCopy:

    ; データの書き込み
    lda #$00
    sta fill_draw_cul

    lda fill_draw_raw
    and #$10
    cmp #$00
    beq .AttrBrch01
    jmp .AttrBrch02

.AttrBrch01:
    ldy #$00
    lda [fill_draw_buff], y
    tax
    lda objectAttributeData, x
    asl a
    asl a
    asl a
    asl a
    and #$30
    sta fill_draw_cul

    tya
    clc
    adc #$0E
    tay
    lda [fill_draw_buff], y
    tax
    lda objectAttributeData, x
    asl a
    asl a
    asl a
    asl a
    asl a
    asl a
    and #$C0
    ora fill_draw_cul
    sta fill_draw_cul
    jmp .EndAttrBrch0

.AttrBrch02:

    ldy #$00
    lda [fill_draw_buff], y
    tax
    lda objectAttributeData, x
    asl a
    asl a
    asl a
    asl a
    asl a
    asl a
    and #$C0
    sta fill_draw_cul

    ldy #$00
    lda [fill_draw_cul+1], y
    tax
    lda objectAttributeData, x
    asl a
    asl a
    asl a
    asl a
    and #$30
    ora fill_draw_cul
    sta fill_draw_cul

.EndAttrBrch0:

    ; DRAW_BUFFへ書き込み データ 1
    ldy draw_buff_counter
    lda fill_draw_cul
    sta DRAW_BUFF, y
    iny
    sty draw_buff_counter

    ; DRAW_BUFFへ書き込みループ
    lda #$01
    sta fill_draw_counter
.AttrLoop:
    lda #$00
    sta fill_draw_cul

    lda fill_draw_raw
    and #$10
    cmp #$00
    beq .AttrBrch1
    jmp .AttrBrch2

.AttrBrch1:
    lda fill_draw_counter
    asl a
    tay
    dey
    lda [fill_draw_buff], y
    tax
    lda objectAttributeData, x
    and #$03
    sta fill_draw_cul

    iny
    lda [fill_draw_buff], y
    tax
    lda objectAttributeData, x
    asl a
    asl a
    asl a
    asl a
    and #$30
    ora fill_draw_cul
    sta fill_draw_cul

    tya
    clc
    adc #$0D
    tay
    lda [fill_draw_buff], y
    tax
    lda objectAttributeData, x
    asl a
    asl a
    and #$0C
    ora fill_draw_cul
    sta fill_draw_cul

    iny
    lda [fill_draw_buff], y
    tax
    lda objectAttributeData, x
    asl a
    asl a
    asl a
    asl a
    asl a
    asl a
    and #$C0
    ora fill_draw_cul
    sta fill_draw_cul
    jmp .EndAttrBrch

.AttrBrch2:

    lda fill_draw_counter
    asl a
    tay
    dey
    lda [fill_draw_buff], y
    tax
    lda objectAttributeData, x
    asl a
    asl a
    and #$0C
    sta fill_draw_cul

    iny
    lda [fill_draw_buff], y
    tax
    lda objectAttributeData, x
    asl a
    asl a
    asl a
    asl a
    asl a
    asl a
    and #$C0
    ora fill_draw_cul
    sta fill_draw_cul

    lda fill_draw_counter
    asl a
    tay
    dey
    lda [fill_draw_cul+1], y
    tax
    lda objectAttributeData, x
    and #$03
    ora fill_draw_cul
    sta fill_draw_cul

    iny
    lda [fill_draw_cul+1], y
    tax
    lda objectAttributeData, x
    asl a
    asl a
    asl a
    asl a
    and #$30
    ora fill_draw_cul
    sta fill_draw_cul

.EndAttrBrch:
    ; DRAW_BUFFへ書き込み データ 2-8
    ldy draw_buff_counter
    lda fill_draw_cul
    sta DRAW_BUFF, y
    iny
    sty draw_buff_counter

    inc fill_draw_counter
    lda fill_draw_counter
    cmp #$08
    beq .EndAttrLoop
    jmp .AttrLoop
.EndAttrLoop:


    ldy draw_buff_counter
    lda #$00
    sta DRAW_BUFF, y

    rts