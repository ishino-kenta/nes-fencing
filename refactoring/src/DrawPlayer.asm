DIRECTION_RIGHT = 0
DIRECTION_LEFT = 1

DRAW_PLAYER1 = 0
DRAW_PLAYER2 = 1

;--------------------------------------------------
; 入力
;  variable_addr
;  sprite_player

DrawPlayer:

    ; x位置
    ldy #PLAYER_DIRECTION
    lda [variable_addr], y
    asl a
    tax
    ldy #PLAYER_X
    lda centerX, x
    clc
    adc [variable_addr], y
    sta sprite_x
    inx
    iny
    lda [variable_addr], y
    adc centerX, x
    sta sprite_x+1

    ; スプライトのタイルのアドレス
    ; 向き
    ldy #PLAYER_DIRECTION
    lda [variable_addr], y
    asl a
    tax
    ; しゃがみ
    ldy #PLAYER_CROUCH
    lda [variable_addr], y
    beq .NotCrouch
    txa
    clc
    adc #$10
    tax
    jmp .EndTile
.NotCrouch:
    ; ジャンプ
    ldy #PLAYER_JUMP_SPEED
    lda [variable_addr], y
    beq .NotJump
    txa
    clc
    adc #$14
    tax
    jmp .EndTile
.NotJump:
    ; 突き
    ldy #PLAYER_STAB_INDEX
    lda [variable_addr], y
    beq .NotStab
    txa
    clc
    adc #$18
    tax
    ; 突きの時x位置変更
    ldy #PLAYER_DIRECTION
    lda [variable_addr], y
    cmp #DIRECTION_RIGHT
    bne .Stab
    lda sprite_x
    clc
    adc #$08
    sta sprite_x
    lda sprite_x+1
    adc #$00
    sta sprite_x+1
    jmp .EndStab
.Stab:
    lda sprite_x
    sec
    sbc #$08
    sta sprite_x
    lda sprite_x+1
    sbc #$00
    sta sprite_x+1
.EndStab:
    jmp .EndTile
.NotStab:
    ; 走り
    ldy #PLAYER_SPEED_INDEX
    lda [variable_addr], y
    cmp #SPEED_RUN
    bcc .NotRun

    ldy #PLAYER_X
    lda [variable_addr], y
    and #$08
    beq .Run
    txa
    clc
    adc #$04
    tax
    jmp .EndTile
.Run:
    txa
    clc
    adc #$08
    tax
    jmp .EndTile
.NotRun:
    ; ステップ
    ldy #PLAYER_SPEED_INDEX
    lda [variable_addr], y
    cmp #SPEED_STEP_START
    bcc .NotStep
    cmp #SPEED_STEP_END+1
    bcs .NotStep
    txa
    clc
    adc #$0C
    tax
    jmp .EndTile
.NotStep:
.EndTile:
    lda spriteTile, x
    sta sprite_tile
    inx
    lda spriteTile, x
    sta sprite_tile+1

    ; y位置
    ldy #PLAYER_Y
    lda [variable_addr], y
    sta sprite_y
    
    ; 属性
    ldy #PLAYER_DIRECTION
    lda [variable_addr], y
    asl a
    asl a
    asl a
    asl a
    asl a
    asl a
    ora sprite_player
    sta sprite_attr

    ; 1列目の書き込み
    ldx oam_counter

    lda sprite_x
    sec
    sbc camera_x
    sta sprite_x+2
    lda sprite_x+1
    sbc camera_x+1
    beq .Show11
    jsr Hide
    jmp .End11
.Show11:
    ldy #$00
    jsr Show
.End11:
    ; 2列目の書き込み
    lda sprite_x
    clc
    adc #$08
    sta sprite_x
    lda sprite_x+1
    adc #$00
    sta sprite_x+1
    lda sprite_x
    sec
    sbc camera_x
    sta sprite_x+2
    lda sprite_x+1
    sbc camera_x+1
    beq .Show12
    jsr Hide
    jmp .End12
.Show12:
    ldy #$03
    jsr Show
.End12:

    ; 3列目の書き込み
    lda sprite_x
    clc
    adc #$08
    sta sprite_x
    lda sprite_x+1
    adc #$00
    sta sprite_x+1
    lda sprite_x
    sec
    sbc camera_x
    sta sprite_x+2
    lda sprite_x+1
    sbc camera_x+1
    beq .Show13
    jsr Hide
    jmp .End13
.Show13:
    ldy #$06
    jsr Show
.End13:

    ; 剣の表示

    ; 走り中かつ突いていないなら非表示
    ldy #PLAYER_SPEED_INDEX
    lda [variable_addr], y
    cmp #SPEED_RUN
    bcc .Next
    ldy #PLAYER_STAB_INDEX
    lda [variable_addr], y
    beq .NotDrawSword
.Next:
    ; しゃがみ中は非表示
    ldy #PLAYER_CROUCH
    lda [variable_addr], y
    bne .NotDrawSword
    ; ジャンプ中は非表示
    ldy #PLAYER_JUMP_SPEED
    lda [variable_addr], y
    bne .NotDrawSword
    ; 毎フレームプレイヤーを切り替える
    lda clock
    and #$01
    cmp sprite_player
    beq .DrawSword
.NotDrawSword:
    jsr HideSword
    jsr HideSword
    jmp .EndDrawSword

.DrawSword:
    ; ソード1の書き込み
    ldy #PLAYER_DIRECTION
    lda [variable_addr], y
    asl a
    tay
    lda sprite_x
    clc
    adc swordX, y
    sta sprite_x
    iny
    lda sprite_x+1
    adc swordX, y
    sta sprite_x+1
    lda sprite_x
    sec
    sbc camera_x
    sta sprite_x+2
    lda sprite_x+1
    sbc camera_x+1
    beq .Show14
    jsr HideSword
    jmp .End14
.Show14:
    lda #$00
    sta sprite_tmp
    jsr ShowSword
.End14:

    ; ソード2の書き込み
    lda sprite_x
    clc
    adc #$08
    sta sprite_x
    lda sprite_x+1
    adc #$00
    sta sprite_x+1
    lda sprite_x
    sec
    sbc camera_x
    sta sprite_x+2
    lda sprite_x+1
    sbc camera_x+1
    beq .Show15
    jsr HideSword
    jmp .End15
.Show15:
    lda #$01
    sta sprite_tmp
    jsr ShowSword
.End15:

.EndDrawSword:

    stx oam_counter
    
    rts

; 入力: y(0,3,6)
Show:

    tya
    clc
    adc #$03
    sta sprite_tmp
.Loop:
    lda spriteY, y
    clc
    adc sprite_y
    sta OAM, x
    inx
    lda [sprite_tile], y
    sta OAM, x
    inx
    lda sprite_attr
    sta OAM, x
    inx
    lda sprite_x+2
    sta OAM, x
    inx

    iny
    cpy sprite_tmp
    bne .Loop

    rts

Hide:

    txa
    clc
    adc #$0C
    sta sprite_tmp
    lda #$FE
.Loop:
    sta OAM, x
    inx

    cpx sprite_tmp
    bne .Loop

    rts

; 入力: sprite_tmp(0,1)
ShowSword:

    lda #$F7
    clc
    adc sprite_y
    sta OAM, x
    inx
    ldy #PLAYER_DIRECTION
    lda [variable_addr], y
    cmp #DIRECTION_RIGHT
    bne .Direction
    lda #$C0
    eor sprite_tmp
    sta OAM, x
    inx
    jmp .EndDirection
.Direction:
    lda #$C1
    eor sprite_tmp
    sta OAM, x
    inx
.EndDirection:
    lda sprite_attr
    sta OAM, x
    inx
    lda sprite_x+2
    sta OAM, x
    inx

    rts

HideSword:

    txa
    clc
    adc #$04
    sta sprite_tmp
    lda #$FE
.Loop:
    sta OAM, x
    inx

    cpx sprite_tmp
    bne .Loop

    rts




spriteTile:
    .dw spriteRight,spriteLeft
    .dw spriteRun1Right,spriteRun1Left
    .dw spriteRun2Right,spriteRun2Left
    .dw spriteStepRight,spriteStepLeft
    .dw spriteCrouchRight,spriteCrouchLeft
    .dw spriteJumpRight,spriteJumpLeft
    .dw spriteStabRight,spriteStabLeft


spriteRight:
    .db $03,$13,$23,$04,$14,$24,$05,$15,$25
spriteLeft:
    .db $05,$15,$25,$04,$14,$24,$03,$13,$23
spriteRun1Right:
    .db $49,$59,$69,$4A,$5A,$6A,$4B,$5B,$6B
spriteRun1Left:
    .db $4B,$5B,$6B,$4A,$5A,$6A,$49,$59,$69
spriteRun2Right:
    .db $4C,$5C,$6C,$4D,$5D,$6D,$4E,$5E,$6E
spriteRun2Left:
    .db $4E,$5E,$6E,$4D,$5D,$6D,$4C,$5C,$6C
spriteStepRight:
    .db $06,$16,$26,$07,$17,$27,$08,$18,$28
spriteStepLeft:
    .db $08,$18,$28,$07,$17,$27,$06,$16,$26
spriteCrouchRight:
    .db $46,$56,$66,$47,$57,$67,$48,$58,$68
spriteCrouchLeft:
    .db $48,$58,$68,$47,$57,$67,$46,$56,$66
spriteJumpRight:
    .db $86,$96,$A6,$87,$97,$A7,$88,$98,$A8
spriteJumpLeft:
    .db $88,$98,$A8,$87,$97,$A7,$86,$96,$A6
spriteStabRight:
    .db $00,$10,$20,$01,$11,$21,$02,$12,$22
spriteStabLeft:
    .db $02,$12,$22,$01,$11,$21,$00,$10,$20

spriteY:
    .db $F0,$F8,$00,$F0,$F8,$00,$F0,$F8,$00

centerX:
    .db $F4,$FF, $F5,$FF

swordX:
    .db $06,$00, $E2,$FF
swordY:
    .db $F4,$F0,$EC ; 下,中,上