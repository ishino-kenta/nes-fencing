COLLISION_RIGHT = 0
COLLISION_LEFT = 1
COLLISION_TOP = 2
COLLISION_BOTTOM = 3

;--------------------------------------------------
; 入力
;  variable_addr
;  collisiondetection_direction
CollisionDetection:


    ; ヒットボックスのオフセットのインデックス設定
    lda collisiondetection_direction
    asl a
    asl a
    sta collisiondetection_tmp
    asl a
    clc
    adc collisiondetection_tmp
    tax
    ldy #PLAYER_STAB_INDEX
    lda [variable_addr], y
    beq .NextHitbox
    txa
    clc
    adc #$30
    tax
    ldy #PLAYER_DIRECTION
    lda [variable_addr], y
    cmp #DIRECTION_LEFT
    bne .EndHitbox
    txa
    clc
    adc #$30
    tax
    jmp .EndHitbox
.NextHitbox:
    ldy #PLAYER_CROUCH
    lda [variable_addr], y
    cmp #CROUCH
    bne .EndHitbox
    txa
    clc
    adc #$90
    tax
.EndHitbox:
    stx collisiondetection_hitbox_offset

    ; variable_addrから変数を持ってきて
    ; CollisionDetectionの引数とする



    ; 1つめの判定
    lda #$00
    sta collisiondetection_end
.Loop1:

    ldy #PLAYER_X
    lda [variable_addr], y
    sta collisiondetection_x
    iny
    lda [variable_addr], y
    sta collisiondetection_x+1

    ldy #PLAYER_Y
    lda [variable_addr], y
    sta collisiondetection_y

    ; ヒットボックスのオフセット設定
    ldx collisiondetection_hitbox_offset
    lda collisiondetection_x
    clc
    adc hitboxOffcet, x
    sta collisiondetection_x
    inx
    lda collisiondetection_x+1
    adc hitboxOffcet, x
    sta collisiondetection_x+1
    inx
    lda collisiondetection_y
    clc
    adc hitboxOffcet, x
    sta collisiondetection_y

    jsr CollisionDetectionOnce

    lda collisiondetection_end
    beq .Loop1

    ; 2つめの判定
    lda #$00
    sta collisiondetection_end
.Loop2:

    ldy #PLAYER_X
    lda [variable_addr], y
    sta collisiondetection_x
    iny
    lda [variable_addr], y
    sta collisiondetection_x+1

    ldy #PLAYER_Y
    lda [variable_addr], y
    sta collisiondetection_y

    ; ヒットボックスのオフセット設定
    lda collisiondetection_hitbox_offset
    clc
    adc #$04
    tax
    lda collisiondetection_x
    clc
    adc hitboxOffcet, x
    sta collisiondetection_x
    inx
    lda collisiondetection_x+1
    adc hitboxOffcet, x
    sta collisiondetection_x+1
    inx
    lda collisiondetection_y
    clc
    adc hitboxOffcet, x
    sta collisiondetection_y

    jsr CollisionDetectionOnce

    lda collisiondetection_end
    beq .Loop2

    ; 3つめの判定
    lda #$00
    sta collisiondetection_end
.Loop3:

    ldy #PLAYER_X
    lda [variable_addr], y
    sta collisiondetection_x
    iny
    lda [variable_addr], y
    sta collisiondetection_x+1

    ldy #PLAYER_Y
    lda [variable_addr], y
    sta collisiondetection_y

    ; ヒットボックスのオフセット設定
    lda collisiondetection_hitbox_offset
    clc
    adc #$08
    tax
    lda collisiondetection_x
    clc
    adc hitboxOffcet, x
    sta collisiondetection_x
    inx
    lda collisiondetection_x+1
    adc hitboxOffcet, x
    sta collisiondetection_x+1
    inx
    lda collisiondetection_y
    clc
    adc hitboxOffcet, x
    sta collisiondetection_y

    jsr CollisionDetectionOnce

    lda collisiondetection_end
    beq .Loop3


    rts

CollisionDetectionOnce:

    ; TILE_BUFFから持ってくる位置の計算
    ;  collisiondetection_addr = (collisiondetection_x / 8 / 2 * 14) + TILE_BUFF

    ; 前処理
    ; 下位を保存
    lda collisiondetection_x
    sta collisiondetection_x+2

    lda collisiondetection_x
    and #$F0
    sta collisiondetection_x
    lda collisiondetection_x+1
    and #$03 ; 画面4つ分にマスク
    sta collisiondetection_x+1

    lsr collisiondetection_x+1
    ror collisiondetection_x
    
    lda collisiondetection_x
    sta collisiondetection_addr
    clc
    lda collisiondetection_x+1
    sta collisiondetection_addr+1

    lsr collisiondetection_x+1
    ror collisiondetection_x
    
    lda collisiondetection_x
    clc
    adc collisiondetection_addr
    sta collisiondetection_addr
    lda collisiondetection_x+1
    adc collisiondetection_addr+1
    sta collisiondetection_addr+1

    lda collisiondetection_x
    clc
    lda collisiondetection_x+1

    lsr collisiondetection_x+1
    ror collisiondetection_x
    
    lda collisiondetection_x
    clc
    adc collisiondetection_addr
    sta collisiondetection_addr
    lda collisiondetection_x+1
    adc collisiondetection_addr+1
    sta collisiondetection_addr+1

    lda collisiondetection_addr+1
    clc
    adc #HIGH(TILE_BUFF)
    sta collisiondetection_addr+1

    lda collisiondetection_y
    lsr a
    lsr a
    lsr a
    lsr a
    tay

    ; 指定した位置のオブジェクトのサブルーチンを呼び出し
    lda [collisiondetection_addr], y
    lsr a
    lsr a
    lsr a
    lsr a
    asl a
    tax
    lda collisionData, x
    sta collisiondetection_addr
    inx
    lda collisionData, x
    sta collisiondetection_addr+1

    lda #HIGH(.Return-1)
    pha
    lda #LOW(.Return-1)
    pha
    jmp [collisiondetection_addr]
.Return:

    rts

collisionData:
    .dw C1,C2

hitboxOffcet: ; x,y
    ; 普通
    .dw $0006,$0000, $0006,$FFF5, $0006,$FFEA ; 右
    .dw $FFFA,$0000, $FFFA,$FFF5, $FFFA,$FFEA ; 左
    .dw $FFFA,$FFEA, $0000,$FFEA, $0006,$FFEA ; 上
    .dw $FFFA,$0000, $0000,$0000, $0006,$0000 ; 下
    ; 突き 右
    .dw $000E,$0000, $000E,$FFF8, $000E,$FFEF
    .dw $FFFC,$0000, $FFFC,$FFF8, $FFFC,$FFEF
    .dw $FFFC,$FFEF, $0006,$FFEF, $000E,$FFEF
    .dw $FFFC,$0000, $0006,$0000, $000E,$0000
    ; 突き 左
    .dw $0004,$0000, $0004,$FFF8, $0004,$FFEF
    .dw $FFF2,$0000, $FFF2,$FFF8, $FFF2,$FFEF
    .dw $FFF2,$FFEF, $FFFB,$FFEF, $0004,$FFEF
    .dw $FFF2,$0000, $FFFB,$0000, $0004,$0000
    ; しゃがみ
    .dw $0006,$0000, $0006,$FFF4, $0006,$FFF4
    .dw $FFFA,$0000, $FFFA,$FFF4, $FFFA,$FFF4
    .dw $FFFA,$FFF4, $0006,$FFF4, $0006,$FFF4
    .dw $FFFA,$0000, $0006,$0000, $0006,$0000

C1:

    lda collisiondetection_direction
    cmp #COLLISION_TOP
    bne .NotTop
    ; 下に移動

    
    ldy #PLAYER_Y
    lda collisiondetection_y
    and #$0F
    eor #$FF
    clc
    adc #$01
    clc
    adc [variable_addr], y
    clc
    adc #$10
    sta [variable_addr], y
    ; 落下リセット
    ldy #PLAYER_FALL_INDEX
    lda #$01
    sta [variable_addr], y
    ; ジャンプ終了
    ldy #PLAYER_JUMP_SPEED
    lda #$00
    sta [variable_addr], y
.NotTop:

    lda collisiondetection_direction
    cmp #COLLISION_BOTTOM
    bne .NotBottom
    ; 上に移動
    ldy #PLAYER_Y
    lda collisiondetection_y
    and #$0F
    eor #$FF
    clc
    adc #$01
    clc
    adc [variable_addr], y
    sec
    sbc #$01
    sta [variable_addr], y
    ; 落下リセット
    ldy #PLAYER_FALL_INDEX
    lda #$00
    sta [variable_addr], y
    ; ジャンプ終了
    ldy #PLAYER_JUMP_SPEED
    lda #$00
    sta [variable_addr], y
.NotBottom:

    lda collisiondetection_direction
    cmp #COLLISION_RIGHT
    bne .NotRight
    ; 左に移動
    ldy #PLAYER_X
    lda collisiondetection_x+2
    and #$0F
    eor #$FF
    clc
    adc #$01
    clc
    adc [variable_addr], y
    sec
    sbc #$01
    sta [variable_addr], y
.NotRight:

    lda collisiondetection_direction
    cmp #COLLISION_LEFT
    bne .NotLeft
    ; 右に移動
    ldy #PLAYER_X
    lda collisiondetection_x+2
    and #$0F
    eor #$FF
    clc
    adc #$01
    clc
    adc [variable_addr], y
    clc
    adc #$10
    sta [variable_addr], y
.NotLeft:

    rts

C2:
    ; 衝突判定を終わる
    inc collisiondetection_end

    rts
