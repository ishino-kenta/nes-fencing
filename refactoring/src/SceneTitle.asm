SceneTitle:

    ; カメラの移動
    lda pad1
    and #PAD_RIGHT
    beq .NotRight
    lda camera_x
    clc
    adc #$02
    sta camera_x
    lda camera_x+1
    adc #$00
    sta camera_x+1
.NotRight:
    lda pad1
    eor pad1_pre
    and pad1
    and #PAD_UP
    beq .NotUp
    lda camera_x
    clc
    adc #$01
    sta camera_x
    lda camera_x+1
    adc #$00
    sta camera_x+1
.NotUp:

    lda pad1
    and #PAD_LEFT
    beq .NotLeft
    lda camera_x
    sec
    sbc #$02
    sta camera_x
    lda camera_x+1
    sbc #$00
    sta camera_x+1
.NotLeft:
    lda pad1
    eor pad1_pre
    and pad1
    and #PAD_DOWN
    beq .NotDown
    lda camera_x
    sec
    sbc #$01
    sta camera_x
    lda camera_x+1
    sbc #$00
    sta camera_x+1
.NotDown:

    ; カメラによってメインスクリーン変更
    lda camera_x+1
    and #$01
    sta title_tmp
    lda soft2000
    and #$FC
    ora title_tmp
    sta soft2000

    ; Aボタン
    ; ステージ情報をセット
    lda pad1
    eor pad1_pre
    and pad1
    and #PAD_A
    beq .NotA
    jsr SetStage
.NotA:

    ; Bボタン
    ; 左右を埋める
    lda pad1
    and #PAD_B
    beq .NotB

    ; 左右の更新

    lda camera_x
    clc
    adc #$7F
    sta fill_tile_cul
    sta fill_draw_cul
    lda camera_x+1
    adc #$01
    sta fill_tile_cul+1
    sta fill_draw_cul+1
    jsr FillTileBuffRow
    jsr FillDrawBuffRow

    lda camera_x
    sec
    sbc #$7F
    sta fill_tile_cul
    sta fill_draw_cul
    lda camera_x+1
    sbc #$00
    sta fill_tile_cul+1
    sta fill_draw_cul+1
    jsr FillTileBuffRow
    jsr FillDrawBuffRow
.NotB:


    ; STARTボタン
    ; エリアを2にする
    lda pad1
    eor pad1_pre
    and pad1
    and #PAD_START
    beq .NotStart
    ; エリア1にセット
    ldy #$00
    iny
    iny
    iny
    iny
    lda [stage_pointer], y
    sta area_pointer
    iny
    lda [stage_pointer], y
    sta area_pointer+1
.NotStart:

    jmp MainLoop
