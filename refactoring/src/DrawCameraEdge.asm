DrawCameraEdge:

    ; カメラの位置によってタイルを更新する

    lda camera_x
    and #$80
    bne .LeftFill
.RightFill:
    lda camera_x+1
    clc
    adc #$02
    sta fill_tile_x
    jsr FillTileBuff

    jmp .EndFill
.LeftFill:
    lda camera_x+1
    sec
    sbc #$01
    sta fill_tile_x
    jsr FillTileBuff

.EndFill:

    ; カメラが移動する方向の背景を更新する

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
    sta fill_draw_cul
    lda camera_x+1
    adc #$01
    sta fill_draw_cul+1

    jsr DrawTileBuff
    jmp .End
.Left:

    lda camera_x
    sec
    sbc #$79
    sta fill_draw_cul
    lda camera_x+1
    sbc #$00
    sta fill_draw_cul+1

    jsr DrawTileBuff
.End:

    rts