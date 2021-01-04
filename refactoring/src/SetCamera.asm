camera_direction_pre    .rs 1

SetCamera:

    lda camera_x
    sta camera_x_pre
    lda camera_x+1
    sta camera_x_pre+1

    lda leadplayer
    cmp #LEAD_VACANT
    bne .Do
    jmp .End
.Do:

    lda player2_dead
    beq .Alive1
    lda player1_x
    sec
    sbc #$40
    sta camera_x
    lda player1_x+1
    sbc #$00
    sta camera_x+1
    jmp .EndSet
.Alive1:
    lda player1_dead
    beq .Alive2
    lda player2_x
    sec
    sbc #$C0
    sta camera_x
    lda player2_x+1
    sbc #$00
    sta camera_x+1
    jmp .EndSet
.Alive2:

    ; カメラ位置 = ((player1_x + $8000) + (player1_x + $8000)) / 2 - $8000 - $80
    ; 背景の中心が $0000 のため， +$8000 してから計算し， -$8000 する

    lda #$00
    sta camera_x
    sta camera_x+1

    lda player1_x
    sta camera_x
    lda player1_x+1
    eor #$80
    sta camera_x+1

    lda player2_x
    clc
    adc camera_x
    sta camera_x
    lda player2_x+1
    eor #$80
    adc camera_x+1
    sta camera_x+1

    lda #$00
    adc #$00
    sta camera_tmp

    lsr camera_tmp
    ror camera_x+1
    ror camera_x

    lda camera_x+1
    eor #$80
    sta camera_x+1

    lda camera_x
    sec
    sbc #$80
    sta camera_x
    lda camera_x+1
    sbc #$00
    sta camera_x+1
.EndSet:

    ; カメラの移動量計算
    lda camera_x
    sec
    sbc camera_x_pre
    sta camera_x
    lda camera_x+1
    sbc camera_x_pre+1
    sta camera_x+1

    ; 1フレームでのカメラの移動量を7に制限
    lda camera_x+1
    and #$80
    bne .Neg

    lda #$00
    sta camera_x+1
    lda camera_x
    and #$F8
    beq .EndLimit
    lda #$07
    sta camera_x
    jmp .EndLimit

.Neg:
    lda #$FF
    sta camera_x+1
    lda camera_x
    eor #$FF
    and #$F8
    beq .EndLimit
    lda #$F9
    sta camera_x
.EndLimit:

    ; カメラを移動
    lda camera_x_pre
    clc
    adc camera_x
    sta camera_x
    lda camera_x_pre+1
    adc camera_x+1
    sta camera_x+1

    ; エリアのページ数でカメラを制限
    lda camera_x+1
    and #$80
    bne .PageLeft
.PageRight:
    lda camera_x+1
    cmp nrof_page
    bne .EndPage
    lda #$00
    sta camera_x
    jmp .EndPage
.PageLeft:
    lda camera_x+1
    eor #$FF
    cmp nrof_page
    bne .EndPage
    lda #$00
    sta camera_x
    inc camera_x+1
.EndPage:

    ; カメラによってメインスクリーン変更
    lda camera_x+1
    and #$01
    sta camera_tmp
    lda soft2000
    and #$FC
    ora camera_tmp
    sta soft2000

.End:

    rts