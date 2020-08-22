selected_stage  .rs 1
NUM_OF_STAGE = $01 ; (number of stages)-1

SelectStage:

    lda pad1
    eor pad1_pre
    and pad1
    and #PAD_UP
    beq .5
    lda selected_stage
    cmp #$00
    bne .2
    lda #NUM_OF_STAGE
    jmp .1
.2:
    sec
    sbc #$01
.1:
    sta selected_stage
.5:

    lda pad1
    eor pad1_pre
    and pad1
    and #PAD_DOWN
    beq .6
    lda selected_stage
    cmp #NUM_OF_STAGE
    bne .4
    lda #$00
    jmp .3
.4:
    clc
    adc #$01
.3:
    sta selected_stage
.6:


    lda pad1
    eor pad1_pre
    and pad1
    and #PAD_A
    beq .7

    jsr InitSceneBattle

    lda #LOW(SceneBattle)
    sta game_scene
    lda #HIGH(SceneBattle)
    sta game_scene+1

    lda soft2000
    and #$7F
    sta soft2000
    sta $2000
    lda soft2001
    and #$E7
    sta soft2001
    sta $2001

    jsr ReloadBG

    lda soft2000
    ora #$80
    sta soft2000
    sta $2000
    lda soft2001
    ora #$18
    sta soft2001

.7:

    rts