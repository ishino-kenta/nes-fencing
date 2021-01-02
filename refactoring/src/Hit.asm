;--------------------------------------------------
; 入力
;  variable_addr

hit_hitbox_offset .rs 1
hit_sword_offset .rs 1
hit_player_x    .rs 2
hit_player_y    .rs 1
hit_sword_x    .rs 2
hit_sword_y    .rs 1

DEAD_TIME = $F0

LEAD_VACANT = 0
LEAD_PLAYER1 = 1
LEAD_PLAYER2 = 2

Hit:

    ; 走り中かつ突いていないなら判定しない
    ldy #PLAYER_SPEED_INDEX
    lda [variable_addr], y
    cmp #SPEED_RUN
    bcc .Next
    ldy #PLAYER_STAB_INDEX
    lda [variable_addr], y
    beq .Not
.Next:
    ; しゃがみ中は判定しない
    ldy #PLAYER_CROUCH
    lda [variable_addr], y
    cmp #CROUCH
    beq .Not
    ; 空中では判定しない
    ldy #PLAYER_FALL_INDEX
    lda [variable_addr], y
    bne .Not
    ; 死亡中は判定しない
    ldy #PLAYER_DEAD
    lda [variable_addr], y
    bne .Not
    jmp .Do
.Not:
    jmp .End
.Do:

    ; ヒットボックスのオフセットのインデックス設定
    ldx #$00
    ldy #PLAYER_STAB_INDEX
    lda [variable_addr+2], y
    beq .NextHitbox
    txa
    clc
    adc #$08
    tax
    ldy #PLAYER_DIRECTION
    lda [variable_addr+2], y
    cmp #DIRECTION_LEFT
    bne .EndHitbox
    txa
    clc
    adc #$08
    tax
    jmp .EndHitbox
.NextHitbox:
    ldy #PLAYER_CROUCH
    lda [variable_addr+2], y
    cmp #CROUCH
    bne .EndHitbox
    txa
    clc
    adc #$18
    tax
.EndHitbox:
    stx hit_hitbox_offset

    ; 上下の判定

    ; プレイヤーの上端の位置をセット
    lda hit_hitbox_offset
    clc
    adc #$04
    tax
    ldy #PLAYER_Y
    lda [variable_addr+2], y
    adc hitbox, x
    sta hit_player_y

    ; 剣の高さをセット
    ldy #PLAYER_POSTURE
    lda [variable_addr], y
    asl a
    asl a
    eor #$FF
    clc
    adc #$01
    clc
    adc #$F4
    ldy #PLAYER_Y
    clc
    adc [variable_addr], y
    sta hit_sword_y

    ; 高さを比較
    lda hit_sword_y
    cmp hit_player_y
    bcc .NotHeight

    ; プレイヤーの下端の位置をセット
    lda hit_hitbox_offset
    clc
    adc #$06
    tax
    ldy #PLAYER_Y
    lda [variable_addr+2], y
    adc hitbox, x
    sta hit_player_y

    lda hit_player_y
    cmp hit_sword_y
    bcc .NotHeight
    jmp .DoHeight
.NotHeight:
    jmp .End
.DoHeight:

    ; 左右の判定

    ; プレイヤーの左端の位置をセット
    ldy #PLAYER_X
    lda [variable_addr+2], y
    clc
    adc hitbox, x
    sta hit_player_x
    inx
    iny
    lda [variable_addr+2], y
    adc hitbox, x
    clc
    adc #$80 ; 中心を$8000にする
    sta hit_player_x+1

    ; 剣のオフセットのインデックスを設定
    ldy #PLAYER_DIRECTION
    lda [variable_addr], y
    asl a
    sta hit_sword_offset
    ldy #PLAYER_STAB_INDEX
    lda [variable_addr], y
    beq .NotStab
    lda hit_sword_offset
    clc
    adc #$04
    sta hit_sword_offset
.NotStab:
    ; 剣の左端の位置をセット
    ldx hit_sword_offset
    ldy #PLAYER_X
    lda [variable_addr], y
    clc
    adc swordOffcet, x
    sta hit_sword_x
    iny
    inx
    lda [variable_addr], y
    adc swordOffcet, x
    clc
    adc #$80 ; 中心を$8000にする
    sta hit_sword_x+1

    ; 剣の左端とプレイヤーの判定
    ; P左 <= 剣左 <= P右
    lda hit_sword_x+1
    cmp hit_player_x+1
    beq .NextPlSl
    bcc .NotPlSlPr
    jmp .PlSl
.NextPlSl:
    lda hit_sword_x
    cmp hit_player_x
    bcc .NotPlSlPr
.PlSl:
    ; P左 <= 剣左

    ; プレイヤーの右端の位置をセット
    ldx hit_hitbox_offset
    inx
    inx
    ldy #PLAYER_X
    lda [variable_addr+2], y
    clc
    adc hitbox, x
    sta hit_player_x
    inx
    iny
    lda [variable_addr+2], y
    adc hitbox, x
    clc
    adc #$80 ; 中心を$8000にする
    sta hit_player_x+1

    lda hit_player_x+1
    cmp hit_sword_x+1
    beq .NextSlPr
    bcc .NotPlSlPr
    jmp .PlSlPr
.NextSlPr:
    lda hit_player_x
    cmp hit_sword_x
    bcc .NotPlSlPr
    jmp .PlSlPr
.NotPlSlPr:
    jmp .EndPlSlPr
.PlSlPr:
    ; 剣左 <= P右
    ; ヒット
    ldy #PLAYER_DEAD_PRE
    lda #DEAD_TIME
    sta [variable_addr+2], y

    jmp .End
.EndPlSlPr:

    ; 剣の中央とプレイヤーの判定

    ; 剣の中央の位置をセット
    lda hit_sword_x
    clc
    adc #$08
    sta hit_sword_x
    lda hit_sword_x+1
    adc #$00
    sta hit_sword_x+1

    ; プレイヤーの左端の位置をセット
    ldx hit_hitbox_offset
    ldy #PLAYER_X
    lda [variable_addr+2], y
    clc
    adc hitbox, x
    sta hit_player_x
    inx
    iny
    lda [variable_addr+2], y
    adc hitbox, x
    clc
    adc #$80 ; 中心を$8000にする
    sta hit_player_x+1

    ; P左 <= 剣中 <= P右
    lda hit_sword_x+1
    cmp hit_player_x+1
    beq .NextPlSc
    bcc .NotPlScPr
    jmp .PlSc
.NextPlSc:
    lda hit_sword_x
    cmp hit_player_x
    bcc .NotPlScPr
.PlSc:
    ; P左 <= 剣中

    ; プレイヤーの右端の位置をセット
    ldx hit_hitbox_offset
    inx
    inx
    ldy #PLAYER_X
    lda [variable_addr+2], y
    clc
    adc hitbox, x
    sta hit_player_x
    inx
    iny
    lda [variable_addr+2], y
    adc hitbox, x
    clc
    adc #$80
    sta hit_player_x+1

    lda hit_player_x+1
    cmp hit_sword_x+1
    beq .NextScPr
    bcc .NotPlScPr
    jmp .PlScPr
.NextScPr:
    lda hit_player_x
    cmp hit_sword_x
    bcc .NotPlScPr
    jmp .PlScPr
.NotPlScPr:
    jmp .EndPlScPr
.PlScPr:
    ; 剣中 <= P右
    ; ヒット
    ldy #PLAYER_DEAD_PRE
    lda #DEAD_TIME
    sta [variable_addr+2], y

    jmp .End
.EndPlScPr:


    ; 剣の右端とプレイヤーの判定

    ; 剣の右端の位置をセット
    lda hit_sword_x
    clc
    adc #$07
    sta hit_sword_x
    lda hit_sword_x+1
    adc #$00
    sta hit_sword_x+1

    ; プレイヤーの左端の位置をセット
    ldx hit_hitbox_offset
    ldy #PLAYER_X
    lda [variable_addr+2], y
    clc
    adc hitbox, x
    sta hit_player_x
    inx
    iny
    lda [variable_addr+2], y
    adc hitbox, x
    clc
    adc #$80 ; 中心を$8000にする
    sta hit_player_x+1

    ; P左 <= 剣右 <= P右
    lda hit_sword_x+1
    cmp hit_player_x+1
    beq .NextPlSr
    bcc .NotPlSrPr
    jmp .PlSr
.NextPlSr:
    lda hit_sword_x
    cmp hit_player_x
    bcc .NotPlSrPr
.PlSr:
    ; P左 <= 剣右

    ; プレイヤーの右端の位置をセット
    ldx hit_hitbox_offset
    inx
    inx
    ldy #PLAYER_X
    lda [variable_addr+2], y
    clc
    adc hitbox, x
    sta hit_player_x
    inx
    iny
    lda [variable_addr+2], y
    adc hitbox, x
    clc
    adc #$80
    sta hit_player_x+1

    lda hit_player_x+1
    cmp hit_sword_x+1
    beq .NextSrPr
    bcc .NotPlSrPr
    jmp .PlSrPr
.NextSrPr:
    lda hit_player_x
    cmp hit_sword_x
    bcc .NotPlSrPr
    jmp .PlSrPr
.NotPlSrPr:
    jmp .EndPlSrPr
.PlSrPr:
    ; 剣右 <= P右
    ; ヒット
    ldy #PLAYER_DEAD_PRE
    lda #DEAD_TIME
    sta [variable_addr+2], y

    jmp .End
.EndPlSrPr:

.End:
    rts

HitCheck:

    ; 同時に死亡できるようにする
    lda player1_dead_pre
    cmp #DEAD_TIME
    bne .P1Alive
    lda player2_dead_pre
    cmp #DEAD_TIME
    bne .P2Alive
    lda #DEAD_TIME
    sta player1_dead
    sta player2_dead
    jmp .End
.P2Alive:
    lda #DEAD_TIME
    sta player1_dead
    jmp .End
.P1Alive:
    lda player2_dead_pre
    cmp #DEAD_TIME
    bne .End
    lda #DEAD_TIME
    sta player2_dead
.End:

    lda #$00
    sta player1_dead_pre
    sta player2_dead_pre

    ; リードを決定
    lda player1_dead
    beq .P1AliveLead
    lda player2_dead
    beq .P2AliveLead
    lda #LEAD_VACANT
    sta leadplayer
    jmp .EndLead
.P2AliveLead:
    lda #LEAD_PLAYER2
    sta leadplayer
    jmp .EndLead
.P1AliveLead:
    lda player2_dead
    beq .EndLead
    lda #LEAD_PLAYER1
    sta leadplayer
.EndLead:

    rts

hitbox:; x,y
    ; 普通
    .dw $FFFA,$0006,$FFEA,$0000 ; 左,右,上,下
    ; 突き 右
    .dw $FFFC,$0006,$FFEF,$0000
    ; 突き 左
    .dw $FFFA,$0004,$FFEF,$0000
    ; しゃがみ
    .dw $FFFA,$0006,$FFF4,$0000

; swordOffcet: ; x,y
;     ; 普通 右,左
;     .dw $000A,$FFE7
;     ; 突き 右,左
;     .dw $0014,$FFDD