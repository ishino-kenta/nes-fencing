Pause:

    lda pad1
    eor pad1_pre
    and pad1
    and #PAD_START
    beq .EndSwitchPause

    lda pause
    eor #$01
    sta pause
    beq .Off

    ldx #$58
    ldy #$00
.Loop:
    lda #$50
    sta OAM, x
    inx
    lda pauseTile, y
    sta OAM, x
    inx
    lda #$02
    sta OAM, x
    inx
    lda pauseX, y
    sta OAM, x
    inx

    iny
    cpy #$05
    bne .Loop

    jmp .EndSwitchPause
.Off:

    ldx #$58
    ldy #$00
.LoopOff:
    lda #$FE
    sta OAM, x
    inx
    iny
    cpy #$14
    bne .LoopOff

.EndSwitchPause:

    rts

pauseTile:
    .db $F0,$F1,$F2,$F3,$F4
pauseX:
    .db $70,$78,$80,$88,$90
