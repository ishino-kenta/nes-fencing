player1_sword_x .rs 2
player2_sword_x .rs 2
player1_sword_offset    .rs 1
player2_sword_offset    .rs 1

CollisionDetectionSword:

    ; 走り中かつ突いていないなら判定しない
    lda player1_speed_index
    cmp #SPEED_RUN
    bcc .Next1
    lda player1_stab_index
    beq .Not
.Next1:
    lda player2_speed_index
    cmp #SPEED_RUN
    bcc .Next2
    lda player2_stab_index
    beq .Not
.Next2:
    ; しゃがみ中は判定しない
    lda player1_crouch
    bne .Not
    lda player2_crouch
    bne .Not
    ; ジャンプ中は判定しない
    lda player1_jump_speed
    bne .Not
    lda player2_jump_speed
    bne .Not
    ; 構えた位置が違うなら判定しない
    lda player1_posture
    cmp player2_posture
    bne .Not
    jmp .Do
.Not:
    jmp .End
.Do:

    ; 剣の左端の位置をセット

    lda player1_direction
    asl a
    sta player1_sword_offset
    lda player1_stab_index
    beq .NotStab1
    lda player1_sword_offset
    clc
    adc #$04
    sta player1_sword_offset
.NotStab1:
    lda player2_direction
    asl a
    sta player2_sword_offset
    lda player2_stab_index
    beq .NotStab2
    lda player2_sword_offset
    clc
    adc #$04
    sta player2_sword_offset
.NotStab2:

    ldx player1_sword_offset
    lda player1_x
    clc
    adc swordOffcet, x
    sta player1_sword_x
    inx
    lda player1_x+1
    adc swordOffcet, x
    sta player1_sword_x+1

    ldx player2_sword_offset
    lda player2_x
    clc
    adc swordOffcet, x
    sta player2_sword_x
    inx
    lda player2_x+1
    adc swordOffcet, x
    sta player2_sword_x+1

    ; プレイヤー1の剣の左端か右端が
    ; プレイヤー2の剣の間にあれば剣同士の衝突

    ; 左2 <= 左1 <= 右2
    lda player1_sword_x+1
    cmp player2_sword_x+1
    beq .NextL2L1
    bcc .NotL2L1R2
    jmp .L2L1
.NextL2L1:
    lda player1_sword_x
    cmp player2_sword_x
    bcc .NotL2L1R2
.L2L1:
    ; 左2 <= 左1
    lda player2_sword_x
    clc
    adc #$0F
    sta player2_sword_x
    lda player2_sword_x+1
    adc #$00
    sta player2_sword_x+1

    lda player2_sword_x+1
    cmp player1_sword_x+1
    beq .NextL1R2
    bcc .NotL2L1R2Pre
    jmp .L2L1R2
.NextL1R2:
    lda player2_sword_x
    cmp player1_sword_x
    bcc .NotL2L1R2Pre
    jmp .L2L1R2
.NotL2L1R2Pre:
    lda player2_sword_x
    sec
    sbc #$0F
    sta player2_sword_x
    lda player2_sword_x+1
    sbc #$00
    sta player2_sword_x+1
.NotL2L1R2:
    jmp .EndL2L1R2
.L2L1R2:
    ; 左1 <= 右2
    lda player2_sword_x
    sec
    sbc player1_sword_x
    sta player1_sword_x
    lda player2_sword_x+1
    sbc player1_sword_x+1
    sta player1_sword_x+1

    lsr player1_sword_x
    lda player1_sword_x
    clc
    adc #$04
    sta player1_sword_x

    lda player1_x
    clc
    adc player1_sword_x
    sta player1_x
    lda player1_x+1
    adc #$00
    sta player1_x+1

    lda player2_x
    sec
    sbc player1_sword_x
    sta player2_x
    lda player2_x+1
    sbc #$00
    sta player2_x+1

    jmp .End
.EndL2L1R2:

    ; 左2 <= 左2 <= 右2

    lda player1_sword_x
    clc
    adc #$0F
    sta player1_sword_x
    lda player1_sword_x+1
    adc #$00
    sta player1_sword_x+1

    lda player1_sword_x+1
    cmp player2_sword_x+1
    beq .NextL2R1
    bcc .NotL2R1R2
    jmp .L2R1
.NextL2R1:
    lda player1_sword_x
    cmp player2_sword_x
    bcc .NotL2R1R2
.L2R1:
    ; 左2 <= 左1
    lda player2_sword_x
    clc
    adc #$0F
    sta player2_sword_x
    lda player2_sword_x+1
    adc #$00
    sta player2_sword_x+1

    lda player2_sword_x+1
    cmp player1_sword_x+1
    beq .NextR1R2
    bcc .NotL2R1R2
    jmp .L2R1R2
.NextR1R2:
    lda player2_sword_x
    cmp player1_sword_x
    bcc .NotL2R1R2
    jmp .L2R1R2
.NotL2R1R2:
    jmp .End
.L2R1R2:
    ; 左1 <= 右2

    lda player2_sword_x
    sec
    sbc #$0F
    sta player2_sword_x
    lda player2_sword_x+1
    sbc #$00
    sta player2_sword_x+1

    lda player1_sword_x
    sec
    sbc player2_sword_x
    sta player2_sword_x
    lda player1_sword_x+1
    sbc player2_sword_x+1
    sta player2_sword_x+1

    lsr player2_sword_x
    lda player2_sword_x
    clc
    adc #$04
    sta player2_sword_x

    lda player2_x
    clc
    adc player2_sword_x
    sta player2_x
    lda player2_x+1
    adc #$00
    sta player2_x+1

    lda player1_x
    sec
    sbc player2_sword_x
    sta player1_x
    lda player1_x+1
    sbc #$00
    sta player1_x+1

.End:
    rts

swordOffcet: ; x,y
    ; 普通 右,左
    .dw $000A,$FFE7
    ; 突き 右,左
    .dw $0014,$FFDD