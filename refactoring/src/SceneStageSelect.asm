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

    lda #$80
    sta player1_x
    sta player2_x
    sta player1_y
    sta player2_y
    lda #$00
    sta player1_x+1
    sta player2_x+1

    jmp .EndStart
.NotStart:

    ldx oam_counter
    
    lda #$20
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
    lda #$20
    sta OAM, x
    inx

    lda #$00
    sta OAM, x
    stx oam_counter

.EndStart:


    jmp MainLoop