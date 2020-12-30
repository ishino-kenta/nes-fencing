;--------------------------------------------------
; ベースとコマンドからオブジェクトを構成する．
; 入力したx位置の列のタイルでタイルバッファを埋める．
; x位置$10ごとに変わっていく．
;
; 入力
;  fill_tile_cul
;   タイルを埋めたいところのx位置．
;  stage_base
;   ベースのタイル



TILE_BUFF = $0400

SIDE_CENTER = 0
SIDE_RIGHT = 1
SIDE_LEFT = 2



FillTileBuff:

    ; 位置でページを反転
    lda fill_tile_cul+1
    and #$80
    bne .Side1
    jmp .Side2
.Side1:
    lda fill_tile_cul
    eor #$FF
    lsr a
    lsr a
    lsr a
    lsr a
    sta page_x
    lda fill_tile_cul+1
    eor #$FF
    and #$7F
    clc
    adc #$01
    sta area_page
    jmp .SideEnd
.Side2:
    lda fill_tile_cul
    lsr a
    lsr a
    lsr a
    lsr a
    sta page_x
    lda fill_tile_cul+1
    and #$7F
    sta area_page
.SideEnd:


    ; 入力から TILE_BUFF の位置を求める．
    ;  fill_tile_buff = (fill_tile_cul / 8 / 2 * 14) + TILE_BUFF

    lda fill_tile_cul
    and #$F0
    sta fill_tile_cul
    lda fill_tile_cul+1
    and #$01
    sta fill_tile_cul+1


    lsr fill_tile_cul+1
    ror fill_tile_cul
    lda fill_tile_cul
    sta fill_tile_buff
    lda fill_tile_cul+1
    sta fill_tile_buff+1
    lsr fill_tile_cul+1
    ror fill_tile_cul
    lda fill_tile_cul
    clc
    adc fill_tile_buff
    sta fill_tile_buff
    lda fill_tile_cul+1
    adc fill_tile_buff+1
    sta fill_tile_buff+1
    lsr fill_tile_cul+1
    ror fill_tile_cul
    lda fill_tile_cul
    clc
    adc fill_tile_buff
    sta fill_tile_buff
    lda fill_tile_cul+1
    adc fill_tile_buff+1
    sta fill_tile_buff+1

    lda fill_tile_buff+1
    clc
    adc #HIGH(TILE_BUFF)
    sta fill_tile_buff+1

    ; ベースで埋める
    ;  (利用するベースタイル) = stage_base * 14
    ldy #$00
    lda stage_base
    asl a
    sta fill_tile_cul
    asl a
    clc
    adc fill_tile_cul
    sta fill_tile_cul
    lda stage_base
    asl a
    asl a
    asl a
    clc
    adc fill_tile_cul
    tax
.Loop:
    lda baseTile, x
    sta [fill_tile_buff], y
    inx
    iny
    cpy #$0E
    bne .Loop

    ; オブジェクトの設置
    
    ldy #$00
    lda [area_pointer], y
    sta area_offset
    inc area_offset

    ; ページのオフセット設定
    ; オブジェ数の保持
    ldy #$00
.PageLoop:
    cpy area_page
    beq .EndPageLoop
    iny
    lda [area_pointer], y
    asl a
    clc
    adc area_offset
    sta area_offset
    jmp .PageLoop
.EndPageLoop:
    iny
    lda [area_pointer], y
    sta nrof_object

    ; オブジェクトを置くループ

.SetObjLoop:

    ldy area_offset
    lda [area_pointer], y
    and #$F0
    lsr a
    lsr a
    lsr a
    tax
    lda areaCommand, x
    sta area_command
    inx
    lda areaCommand, x
    sta area_command+1

    lda #HIGH(.Return-1)
    pha
    lda #LOW(.Return-1)
    pha
    jmp [area_command]
.Return:

    lda area_offset
    clc
    adc #$02
    sta area_offset

    dec nrof_object
    beq .EndSetObjLoop
    jmp .SetObjLoop
.EndSetObjLoop:

    rts

    ; エリアコマンド
    ; yは呼び出し元から引継ぎ
Command1:

    lda [area_pointer], y
    and #$0F
    sta object

    iny
    lda [area_pointer], y
    and #$0F
    cmp page_x
    bne .SkipSetObj
    lda [area_pointer], y
    lsr a
    lsr a
    lsr a
    lsr a
    tay
    lda object
    sta [fill_tile_buff], y
.SkipSetObj:

    rts

areaCommand:
    .dw Command1