SetPlayerDirection:

    inc clock

    ; プレイヤーの向きを位置関係によって変更

    ; 背景の中心が$0000のため， + $8000してから比較
    lda player1_x+1
    eor #$80
    sta player1_x+1
    lda player2_x+1
    eor #$80
    sta player2_x+1

    lda player1_x+1
    cmp player2_x+1
    beq .Next
    bcc .Direction12
    jmp .Direction21
.Next:
    lda player1_x
    cmp player2_x
    bcc .Direction12
.Direction21:
    ; 突き中は向きを変えない
    lda player1_stab_index
    bne .NotStab11
    lda #DIRECTION_LEFT
    sta player1_direction
.NotStab11:
    lda player2_stab_index
    bne .NotStab21
    lda #DIRECTION_RIGHT
    sta player2_direction
.NotStab21:
    jmp .End
.Direction12:
    lda player1_stab_index
    bne .NotStab12
    lda #DIRECTION_RIGHT
    sta player1_direction
.NotStab12:
    lda player2_stab_index
    bne .NotStab22
    lda #DIRECTION_LEFT
    sta player2_direction
.NotStab22:
.End:

    lda player1_x+1
    eor #$80
    sta player1_x+1
    lda player2_x+1
    eor #$80
    sta player2_x+1

    ; 走っている場合向きを移動方向にする
    ; 突き中は向きを変えない
    lda player1_stab_index
    bne .NotRun1
    lda player1_speed_index
    cmp #SPEED_RUN
    bcc .NotRun1
    lda pad1
    and #PAD_RIGHT
    beq .NotRight1
    lda #DIRECTION_RIGHT
    sta player1_direction
.NotRight1:
    lda pad1
    and #PAD_LEFT
    beq .NotLeft1
    lda #DIRECTION_LEFT
    sta player1_direction
.NotLeft1:
.NotRun1:

    lda player2_stab_index
    bne .NotRun2
    lda player2_speed_index
    cmp #SPEED_RUN
    bcc .NotRun2
    lda pad2
    and #PAD_RIGHT
    beq .NotRight2
    lda #DIRECTION_RIGHT
    sta player2_direction
.NotRight2:
    lda pad2
    and #PAD_LEFT
    beq .NotLeft2
    lda #DIRECTION_LEFT
    sta player2_direction
.NotLeft2:
.NotRun2:

    rts