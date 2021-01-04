SceneBattle:

    jsr Pause

    lda pause
    beq .Do
    jmp .Pause
.Do:

    jsr Reborn

    ; 突き
    lda #LOW(VARIABLE_PLAYER1)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER1)
    sta variable_addr+1
    jsr Stab
    lda #LOW(VARIABLE_PLAYER2)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER2)
    sta variable_addr+1
    jsr Stab

    ; しゃがみ判定
    lda #LOW(VARIABLE_PLAYER1)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER1)
    sta variable_addr+1
    jsr Crouch
    lda #LOW(VARIABLE_PLAYER2)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER2)
    sta variable_addr+1
    jsr Crouch

    ; 構え変更
    lda #LOW(VARIABLE_PLAYER1)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER1)
    sta variable_addr+1
    jsr ChangePosture
    lda #LOW(VARIABLE_PLAYER2)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER2)
    sta variable_addr+1
    jsr ChangePosture

    ; 剣の衝突
    jsr CollisionDetectionSword
    ; プレイヤー移動
    lda #LOW(VARIABLE_PLAYER1)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER1)
    sta variable_addr+1
    jsr Move
    lda #LOW(VARIABLE_PLAYER2)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER2)
    sta variable_addr+1
    jsr Move
    ; 壁の衝突判定
    lda #COLLISION_RIGHT
    sta collisiondetection_direction
    lda #LOW(VARIABLE_PLAYER1)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER1)
    sta variable_addr+1
    jsr CollisionDetection
    lda #COLLISION_LEFT
    sta collisiondetection_direction
    lda #LOW(VARIABLE_PLAYER1)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER1)
    sta variable_addr+1
    jsr CollisionDetection
    lda #COLLISION_RIGHT
    sta collisiondetection_direction
    lda #LOW(VARIABLE_PLAYER2)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER2)
    sta variable_addr+1
    jsr CollisionDetection
    lda #COLLISION_LEFT
    sta collisiondetection_direction
    lda #LOW(VARIABLE_PLAYER2)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER2)
    sta variable_addr+1
    jsr CollisionDetection

    ; ジャンプ
    lda #LOW(VARIABLE_PLAYER1)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER1)
    sta variable_addr+1
    jsr Jump
    lda #LOW(VARIABLE_PLAYER2)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER2)
    sta variable_addr+1
    jsr Jump
    ; 落下
    lda #LOW(VARIABLE_PLAYER1)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER1)
    sta variable_addr+1
    jsr Fall
    lda #LOW(VARIABLE_PLAYER2)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER2)
    sta variable_addr+1
    jsr Fall
    ; 床の衝突判定
    lda #COLLISION_BOTTOM
    sta collisiondetection_direction
    lda #LOW(VARIABLE_PLAYER1)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER1)
    sta variable_addr+1
    jsr CollisionDetection
    lda #COLLISION_BOTTOM
    sta collisiondetection_direction
    lda #LOW(VARIABLE_PLAYER2)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER2)
    sta variable_addr+1
    jsr CollisionDetection
    ; 天井の衝突判定
    lda #COLLISION_TOP
    sta collisiondetection_direction
    lda #LOW(VARIABLE_PLAYER1)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER1)
    sta variable_addr+1
    jsr CollisionDetection
    lda #COLLISION_TOP
    sta collisiondetection_direction
    lda #LOW(VARIABLE_PLAYER2)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER2)
    sta variable_addr+1
    jsr CollisionDetection

    ; 剣のヒット
    lda #LOW(VARIABLE_PLAYER1)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER1)
    sta variable_addr+1
    lda #LOW(VARIABLE_PLAYER2)
    sta variable_addr+2
    lda #HIGH(VARIABLE_PLAYER2)
    sta variable_addr+3
    jsr Hit
    lda #LOW(VARIABLE_PLAYER2)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER2)
    sta variable_addr+1
    lda #LOW(VARIABLE_PLAYER1)
    sta variable_addr+2
    lda #HIGH(VARIABLE_PLAYER1)
    sta variable_addr+3
    jsr Hit
    jsr HitCheck

    ; 離れすぎたら死亡
    jsr FarAway

    ; プレイヤーの向きを計算
    jsr SetPlayerDirection

    ; エリア移動
    jsr ChangeArea

    ; カメラ位置の決定
    jsr SetCamera

    ; カメラ端の画面の更新
    jsr DrawCameraEdge

    ; プレイヤースプライト表示
    lda #LOW(VARIABLE_PLAYER1)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER1)
    sta variable_addr+1
    lda #DRAW_PLAYER1
    sta sprite_player
    jsr DrawPlayer
    lda #LOW(VARIABLE_PLAYER2)
    sta variable_addr
    lda #HIGH(VARIABLE_PLAYER2)
    sta variable_addr+1
    lda #DRAW_PLAYER2
    sta sprite_player
    jsr DrawPlayer
    
.Pause:

    jmp MainLoop

Wait:

    ldx #$00
.Loop:
    inx
    cpx #$FF
    bne .Loop

    rts