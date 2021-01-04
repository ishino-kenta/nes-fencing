;--------------------------------------------------
; ベースとコマンドからオブジェクトを構成する．
; 入力したx位置の列のタイルでタイルバッファを埋める．
; x位置$10ごとに変わっていく．
;
; 入力
;  fill_tile_x
;   タイルを埋めたいところのx位置の上位．
;  stage_base
;   ベースのタイル



TILE_BUFF = $0400

SIDE_CENTER = 0
SIDE_RIGHT = 1
SIDE_LEFT = 2

fill_tile_x_pre   .rs 1
fill_tile_phase   .rs 3
fill_tile_x .rs 1
fill_tile_mask  .rs 1

base_offset .rs 1


FillTileBuff:

    ; 4段階に分けてタイルを埋めていく

    lda fill_tile_x
    cmp fill_tile_x_pre
    beq .NextPhase
    lda #$00
    sta fill_tile_phase
.NextPhase:

    lda fill_tile_x
    sta fill_tile_x_pre

    lda fill_tile_phase
    asl a
    tax
    lda fillTileBuff, x
    sta fill_tile_phase+1
    inx
    lda fillTileBuff, x
    sta fill_tile_phase+2

    jmp [fill_tile_phase+1]

.EndFill:

    rts

fillTileBuff:
    .dw FillTileBuffPhase1, FillTileBuffPhase2, FillTileBuffPhase3, FillTileBuffPhase4

FillTileBuffPhase1:



    ; 埋める場所を計算
    ; fill_tile_buff = ((fill_tile_x & $03) * $E0) + TILE_BUFF
    lda #$00
    sta fill_tile_buff
    sta fill_tile_buff+1
    sta fill_tile_cul
    
    lda fill_tile_x
    and #$03
    sta fill_tile_cul+1

    lsr fill_tile_cul+1
    ror fill_tile_cul

    lda fill_tile_buff
    clc
    adc fill_tile_cul
    sta fill_tile_buff
    lda fill_tile_buff+1
    adc fill_tile_cul+1
    sta fill_tile_buff+1

    lsr fill_tile_cul+1
    ror fill_tile_cul

    lda fill_tile_buff
    clc
    adc fill_tile_cul
    sta fill_tile_buff
    lda fill_tile_buff+1
    adc fill_tile_cul+1
    sta fill_tile_buff+1

    lsr fill_tile_cul+1
    ror fill_tile_cul

    lda fill_tile_buff
    clc
    adc fill_tile_cul
    sta fill_tile_buff
    lda fill_tile_buff+1
    adc fill_tile_cul+1
    clc
    adc #HIGH(TILE_BUFF)
    sta fill_tile_buff+1

    lda #$01
    sta fill_tile_phase

    rts

FillTileBuffPhase2:

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
    sta base_offset
    clc
    adc #$0E
    sta fill_tile_cul

    ldy #$00
.Looop:
    ldx base_offset
.Loop:
    lda baseTile, x
    sta [fill_tile_buff], y
    inx
    iny
    cpx fill_tile_cul
    bne .Loop
    cpy #$70
    bne .Looop

    lda #$02
    sta fill_tile_phase

    rts

FillTileBuffPhase3:

    lda base_offset
    clc
    adc #$0E
    sta fill_tile_cul

    ldy #$70
.Looop:
    ldx base_offset
.Loop:
    lda baseTile, x
    sta [fill_tile_buff], y
    inx
    iny
    cpx fill_tile_cul
    bne .Loop
    cpy #$E0
    bne .Looop

    lda #$03
    sta fill_tile_phase

    rts

FillTileBuffPhase4:

    ; ページを計算
    lda fill_tile_x
    and #$80
    bne .Side1
    jmp .Side2
.Side1:
    lda fill_tile_x
    eor #$FF
    and #$7F
    clc
    adc #$01
    sta page_num
    lda #$0F
    sta fill_tile_mask
    jmp .SideEnd
.Side2:
    lda fill_tile_x
    and #$7F
    sta page_num
    lda #$00
    sta fill_tile_mask
.SideEnd:

    ; オブジェクトの設置
    
    ldy #$00
    lda [area_pointer], y
    sta page_offset
    inc page_offset

    ; 範囲外のページでは終了
    lda nrof_page
    cmp page_num
    bcs .DoSetObject
    jmp .EndFill
.DoSetObject:
    ; ページのオフセット設定
    ; オブジェ数の保持
    ldy #$00
.PageLoop:
    cpy page_num
    beq .EndPageLoop
    iny
    lda [area_pointer], y
    asl a
    clc
    adc page_offset
    sta page_offset
    jmp .PageLoop
.EndPageLoop:
    iny
    lda [area_pointer], y
    sta nrof_object

    ; オブジェクトを置くループ

.SetObjLoop:

    ldy page_offset
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

    lda page_offset
    clc
    adc #$02
    sta page_offset

    dec nrof_object
    beq .EndSetObjLoop
    jmp .SetObjLoop
.EndSetObjLoop:

.EndFill:

    rts

    ; エリアコマンド
    ; yは呼び出し元から引継ぎ
Command1:

    lda [area_pointer], y
    and #$0F
    sta object

    lda #$00
    sta fill_tile_cul

    iny
    lda [area_pointer], y
    and #$0F
    eor fill_tile_mask
    asl a
    sta fill_tile_cul

    asl fill_tile_cul
    clc
    adc fill_tile_cul

    asl fill_tile_cul
    clc
    adc fill_tile_cul
    sta fill_tile_cul

    lda [area_pointer], y
    lsr a
    lsr a
    lsr a
    lsr a
    clc
    adc fill_tile_cul
    tay
    lda object
    sta [fill_tile_buff], y

    rts

areaCommand:
    .dw Command1