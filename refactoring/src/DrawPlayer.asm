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
    cmp #CROUCH
    bne .NotCrouch
    txa
    clc
    adc #$20
    tax
    jmp .EndTile
.NotCrouch:
    ; ジャンプ
    ldy #PLAYER_JUMP_SPEED
    lda [variable_addr], y
    beq .NotJump
    txa
    clc
    adc #$24
    tax
    jmp .EndTile
.NotJump:

    ; 突き
    ldy #PLAYER_STAB_INDEX
    lda [variable_addr], y
    beq .NotStab
    txa
    clc
    adc #$28
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
    jmp .Posture
.Stab:
    lda sprite_x
    sec
    sbc #$08
    sta sprite_x
    lda sprite_x+1
    sbc #$00
    sta sprite_x+1
    jmp .Posture
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
    adc #$0C
    tax
    jmp .EndTile
.Run:
    txa
    clc
    adc #$10
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
    adc #$14
    tax
    jmp .Posture
.NotStep:
.Posture:
    ; 構えの高さ 通常時,突き時,ステップ時のみ
    ldy #PLAYER_POSTURE
    txa
    clc
    adc [variable_addr],y
    adc [variable_addr],y
    adc [variable_addr],y
    adc [variable_addr],y
    tax
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
    cmp #CROUCH
    beq .NotDrawSword
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
    sta sprite_tmp
    ldy #PLAYER_STAB_INDEX
    lda [variable_addr], y
    beq .NotStabSword
    lda sprite_tmp
    clc
    adc #$04
    sta sprite_tmp
.NotStabSword:
    ldy sprite_tmp
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

    ldy #PLAYER_POSTURE
    lda [variable_addr],y
    asl a
    asl a
    eor #$FF
    clc
    adc #$01
    clc
    adc #$FB
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
    .dw spriteLowRight,spriteLowLeft
    .dw spriteMidRight,spriteMidLeft
    .dw spriteHighRight,spriteHighLeft

    .dw spriteRun1Right,spriteRun1Left
    .dw spriteRun2Right,spriteRun2Left

    .dw spriteStepLowRight,spriteStepLowLeft
    .dw spriteStepMidRight,spriteStepMidLeft
    .dw spriteStepHighRight,spriteStepHighLeft

    .dw spriteCrouchRight,spriteCrouchLeft

    .dw spriteJumpRight,spriteJumpLeft

    .dw spriteStabLowRight,spriteStabLowLeft
    .dw spriteStabMidRight,spriteStabMidLeft
    .dw spriteStabHighRight,spriteStabHighLeft


spriteMidRight:
    .db $03,$13,$23,$04,$14,$24,$05,$15,$25
spriteMidLeft:
    .db $05,$15,$25,$04,$14,$24,$03,$13,$23
spriteLowRight:
    .db $43,$53,$63,$44,$54,$64,$45,$55,$65
spriteLowLeft:
    .db $45,$55,$65,$44,$54,$64,$43,$53,$63
spriteHighRight:
    .db $83,$93,$A3,$84,$94,$A4,$85,$95,$A5
spriteHighLeft:
    .db $85,$95,$A5,$84,$94,$A4,$83,$93,$A3

spriteRun1Right:
    .db $49,$59,$69,$4A,$5A,$6A,$4B,$5B,$6B
spriteRun1Left:
    .db $4B,$5B,$6B,$4A,$5A,$6A,$49,$59,$69
spriteRun2Right:
    .db $4C,$5C,$6C,$4D,$5D,$6D,$4E,$5E,$6E
spriteRun2Left:
    .db $4E,$5E,$6E,$4D,$5D,$6D,$4C,$5C,$6C

spriteStepMidRight:
    .db $06,$16,$26,$07,$17,$27,$08,$18,$28
spriteStepMidLeft:
    .db $08,$18,$28,$07,$17,$27,$06,$16,$26
spriteStepLowRight:
    .db $46,$56,$66,$47,$57,$67,$48,$58,$68
spriteStepLowLeft:
    .db $48,$58,$68,$47,$57,$67,$46,$56,$66
spriteStepHighRight:
    .db $86,$96,$A6,$87,$97,$A7,$88,$98,$A8
spriteStepHighLeft:
    .db $88,$98,$A8,$87,$97,$A7,$86,$96,$A6

spriteCrouchRight:
    .db $8C,$9C,$AC,$8D,$9D,$AD,$8E,$9E,$AE
spriteCrouchLeft:
    .db $8E,$9E,$AE,$8D,$9D,$AD,$8C,$9C,$AC

spriteJumpRight:
    .db $89,$99,$A9,$8A,$9A,$AA,$8B,$9B,$AB
spriteJumpLeft:
    .db $8B,$9B,$AB,$8A,$9A,$AA,$89,$99,$A9

spriteStabMidRight:
    .db $00,$10,$20,$01,$11,$21,$02,$12,$22
spriteStabMidLeft:
    .db $02,$12,$22,$01,$11,$21,$00,$10,$20
spriteStabLowRight:
    .db $40,$50,$60,$41,$51,$61,$42,$52,$62
spriteStabLowLeft:
    .db $42,$52,$62,$41,$51,$61,$40,$50,$60
spriteStabHighRight:
    .db $80,$90,$A0,$81,$91,$A1,$82,$92,$A2
spriteStabHighLeft:
    .db $82,$92,$A2,$81,$91,$A1,$80,$90,$A0

spriteY:
    .db $F0,$F8,$00,$F0,$F8,$00,$F0,$F8,$00

centerX:
    .db $F4,$FF, $F5,$FF

swordX:
    ; 通常
    .db $06,$00, $E2,$FF
    ; 突き
    .db $08,$00, $E0,$FF
swordY:
    .db $F4,$F0,$EC ; 下,中,上