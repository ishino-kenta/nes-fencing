collisiondetection_x    .rs 3
collisiondetection_y    .rs 1
collisiondetection_addr    .rs 2
collisiondetection_direction    .rs 1
collisiondetection_player   .rs 1
collisiondetection_end   .rs 1

COLLISION_RIGHT = 0
COLLISION_LEFT = 1
COLLISION_TOP = 2
COLLISION_BOTTOM = 3

PLAYER1 = 0
PLAYER2 = 1

;--------------------------------------------------
; 入力
;  collisiondetection_x
;  collisiondetection_y
CollisionDetection:

    ; collisiondetection_playerから変数を持ってきて
    ; CollisionDetectionの引数とする

    ; 左下の判定
    lda #$00
    sta collisiondetection_end
.Loop1:
    lda collisiondetection_player
    asl a
    tax
    lda playerDataX, x
    sta collisiondetection_addr
    inx
    lda playerDataX, x
    sta collisiondetection_addr+1
    ldy #$00
    lda [collisiondetection_addr], y
    sta collisiondetection_x
    iny
    lda [collisiondetection_addr], y
    sta collisiondetection_x+1

    lda collisiondetection_player
    asl a
    tax
    lda playerDataY, x
    sta collisiondetection_addr
    inx
    lda playerDataY, x
    sta collisiondetection_addr+1
    ldy #$00
    lda [collisiondetection_addr], y
    sta collisiondetection_y

    lda collisiondetection_direction
    asl a
    asl a
    asl a
    tax
    lda collisiondetection_x
    clc
    adc directionOffcet, x
    sta collisiondetection_x
    inx
    lda collisiondetection_x+1
    adc directionOffcet, x
    sta collisiondetection_x+1
    inx
    lda collisiondetection_y
    clc
    adc directionOffcet, x
    sta collisiondetection_y

    jsr CollisionDetectionOnce

    lda collisiondetection_end
    beq .Loop1

    ; 右下の判定
    lda #$00
    sta collisiondetection_end
.Loop2:
    lda collisiondetection_player
    asl a
    tax
    lda playerDataX, x
    sta collisiondetection_addr
    inx
    lda playerDataX, x
    sta collisiondetection_addr+1
    ldy #$00
    lda [collisiondetection_addr], y
    sta collisiondetection_x
    iny
    lda [collisiondetection_addr], y
    sta collisiondetection_x+1

    lda collisiondetection_player
    asl a
    tax
    lda playerDataY, x
    sta collisiondetection_addr
    inx
    lda playerDataY, x
    sta collisiondetection_addr+1
    ldy #$00
    lda [collisiondetection_addr], y
    sta collisiondetection_y

    lda collisiondetection_direction
    asl a
    asl a
    asl a
    tax
    inx
    inx
    inx
    inx
    lda collisiondetection_x
    clc
    adc directionOffcet, x
    sta collisiondetection_x
    inx
    lda collisiondetection_x+1
    adc directionOffcet, x
    sta collisiondetection_x+1
    inx
    lda collisiondetection_y
    clc
    adc directionOffcet, x
    sta collisiondetection_y

    jsr CollisionDetectionOnce

    lda collisiondetection_end
    beq .Loop2

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
    and #$01 ; 画面2つ分にマスク
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
playerDataY:
    .dw player1_y,player2_y
playerDataX:
    .dw player1_x,player2_x
playerDataDirection:
    .dw player1_direction,player2_direction
directionOffcet:
    .dw $0006,$0000, $0006,$FFEA
    .dw $FFFA,$0000, $FFFA,$FFEA
    .dw $FFFA,$FFEA, $0006,$FFEA
    .dw $FFFA,$0000, $0006,$0000

C1:

    lda collisiondetection_direction
    cmp #COLLISION_TOP
    bne .NotTop
    ; 下に移動
    lda collisiondetection_player
    asl a
    tax
    lda playerDataY, x
    sta collisiondetection_addr
    inx
    lda playerDataY, x
    sta collisiondetection_addr+1

    ldy #$00
    lda collisiondetection_y
    and #$0F
    eor #$FF
    clc
    adc #$01
    clc
    adc [collisiondetection_addr], y
    clc
    adc #$10
    sta [collisiondetection_addr], y
.NotTop:

    lda collisiondetection_direction
    cmp #COLLISION_BOTTOM
    bne .NotBottom
    ; 上に移動
    lda collisiondetection_player
    asl a
    tax
    lda playerDataY, x
    sta collisiondetection_addr
    inx
    lda playerDataY, x
    sta collisiondetection_addr+1

    ldy #$00
    lda [collisiondetection_addr], y
    and #$F0
    sec
    sbc #$01
    sta [collisiondetection_addr], y
.NotBottom:

    lda collisiondetection_direction
    cmp #COLLISION_RIGHT
    bne .NotRight
    ; 左に移動
    lda collisiondetection_player
    asl a
    tax
    lda playerDataX, x
    sta collisiondetection_addr
    inx
    lda playerDataX, x
    sta collisiondetection_addr+1

    ldy #$00
    lda collisiondetection_x+2
    and #$0F
    eor #$FF
    clc
    adc #$01
    clc
    adc [collisiondetection_addr], y
    sec
    sbc #$01
    sta [collisiondetection_addr], y
.NotRight:

    lda collisiondetection_direction
    cmp #COLLISION_LEFT
    bne .NotLeft
    ; 右に移動
    lda collisiondetection_player
    asl a
    tax
    lda playerDataX, x
    sta collisiondetection_addr
    inx
    lda playerDataX, x
    sta collisiondetection_addr+1

    ldy #$00
    lda collisiondetection_x+2
    and #$0F
    eor #$FF
    clc
    adc #$01
    clc
    adc [collisiondetection_addr], y
    clc
    adc #$10
    sta [collisiondetection_addr], y
.NotLeft:

    rts

C2:
    ; 衝突判定を終わる
    inc collisiondetection_end

    rts
