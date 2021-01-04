ChangeArea:

    lda leadplayer
    cmp #LEAD_PLAYER1
    bne .Lead2
.Lead1:
    lda player1_x+1
    sec
    sbc #$01
    cmp nrof_page
    beq .Do1
    jmp .EndLead
.Do1:
    
    ; エリア変更
    lda area_num
    clc
    adc #$01
    sta area_num

    ; 勝利判定
    lda area_num
    cmp nrof_area
    bne .NotWin1
    lda #LOW(SceneResult)
    sta scene
    lda #HIGH(SceneResult)
    sta scene+1
    pla
    pla
    jsr SetWin
    lda #$00
    sta camera_x
    lda soft2000
    and #$FC
    sta soft2000
    jmp MainLoop
.NotWin1:

    lda #DEAD_TIME
    sta player2_dead

    jsr SetArea

    lda #$00
    sta camera_x
    sta camera_x_pre
    lda #$00
    sec
    sbc nrof_page
    sta camera_x+1
    sta camera_x_pre+1
    sta draw_area_x
    sta player1_x+1
    lda #$00
    sta player1_x

    jsr DrawArea

.Lead2:
    lda player2_x+1
    eor #$FF
    cmp nrof_page
    beq .Do2
    jmp .EndLead
.Do2:

    ; エリア変更
    lda area_num
    sec
    sbc #$01
    sta area_num

    ; 勝利判定
    lda area_num
    eor #$FF
    clc
    adc #$01
    cmp nrof_area
    bne .NotWin2
    lda #LOW(SceneResult)
    sta scene
    lda #HIGH(SceneResult)
    sta scene+1
    pla
    pla
    jsr SetWin
    lda #$00
    sta camera_x
    lda soft2000
    and #$FC
    sta soft2000
    jmp MainLoop
.NotWin2:

    lda #DEAD_TIME
    sta player1_dead

    jsr SetArea

    lda #$00
    sta camera_x
    sta camera_x_pre
    lda nrof_page
    sta camera_x+1
    sta camera_x_pre+1
    sta draw_area_x
    sta player2_x+1
    lda #$FF
    sta player2_x

    jsr DrawArea
    
.EndLead:

    

    rts