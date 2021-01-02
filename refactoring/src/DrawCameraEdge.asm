DrawCameraEdge:

    ; カメラの移動方向判定
    ; 左右の更新

    lda camera_x+1
    cmp camera_x_pre+1
    beq .Next
    bcc .Left
    jmp .Right
.Next:
    lda camera_x
    cmp camera_x_pre
    bcc .Left
.Right:

    lda camera_x
    clc
    adc #$78
    sta fill_tile_cul
    sta fill_draw_cul
    lda camera_x+1
    adc #$01
    sta fill_tile_cul+1
    sta fill_draw_cul+1
    jsr FillTileBuff
    jsr DrawTileBuff
    jmp .End
.Left:

    lda camera_x
    sec
    sbc #$79
    sta fill_tile_cul
    sta fill_draw_cul
    lda camera_x+1
    sbc #$00
    sta fill_tile_cul+1
    sta fill_draw_cul+1
    jsr FillTileBuff
    jsr DrawTileBuff
.End:

    rts