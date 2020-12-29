SceneBattle:

    jsr Move1
    jsr Move2

    ; プレイヤーの向きを計算
    jsr SetPlayerDirection

    ; カメラ位置の決定
    jsr SetCamera

    ; カメラ端の画面の更新
    jsr DrawCameraEdge

    ; jsr Fall1
    ; jsr Fall2

    lda #PLAYER1
    sta collisiondetection_player
    lda #COLLISION_LEFT
    sta collisiondetection_direction
    jsr CollisionDetection

    ; プレイヤースプライト表示
    jsr DrawPlayer

    jmp MainLoop

