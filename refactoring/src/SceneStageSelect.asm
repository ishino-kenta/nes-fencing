SceneStageSelect:

    ; UPボタン
    lda pad1
    eor pad1_pre
    and pad1
    and #PAD_UP
    beq .NotUp

    inc stage

.NotUp:
    ; Downボタン
    lda pad1
    eor pad1_pre
    and pad1
    and #PAD_DOWN
    beq .NotDown

    dec stage

.NotDown:

    ; STARTボタン
    ; ステージ情報をセット
    lda pad1
    eor pad1_pre
    and pad1
    and #PAD_START
    beq .NotStart

    ldx #$00
    lda #$FE
    sta OAM, x
    inx
    sta OAM, x
    inx
    sta OAM, x
    inx
    sta OAM, x
    inx

    jsr SetStage

    lda #LOW(SceneBattle)
    sta scene
    lda #HIGH(SceneBattle)
    sta scene+1

    lda #$00
    sta player1_dead
    sta player2_dead
    sta player1_fall_index
    sta player2_fall_index
    sta player1_speed_index
    sta player2_speed_index
    sta player1_crouch
    sta player2_crouch
    sta player1_jump_speed
    sta player2_jump_speed
    sta player1_stab_index
    sta player2_stab_index
    lda #POSTURE_MID
    sta player1_posture
    sta player2_posture
    lda #LEAD_VACANT
    sta leadplayer
    lda #$00
    sta player1_x+1
    sta player2_x+1
    lda #$40
    sta player1_x
    lda #$C0
    sta player2_x
    lda #$80
    sta player1_y
    sta player2_y
    lda #$00
    sta camera_x
    sta camera_x+1
    sta camera_x_pre
    sta camera_x_pre+1

    jmp .EndStart
.NotStart:

    ldx oam_counter
    
    lda #$60
    sta OAM, x
    inx
    lda #$E0
    clc
    adc stage
    sta OAM, x
    inx
    lda #$00
    sta OAM, x
    inx
    lda #$80
    sta OAM, x
    inx

    lda #$00
    sta OAM, x
    stx oam_counter

.EndStart:


    jmp MainLoop

