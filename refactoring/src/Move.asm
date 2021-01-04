

SPEED_MAX = $0C
SPEED_RUN = $0B
SPEED_STEP_START = $01
SPEED_STEP_END = $04

;--------------------------------------------------
; 入力
;  variable_addr

Move:

    ; 突き中は移動しない
    ldy #PLAYER_STAB_INDEX
    lda [variable_addr], y
    bne .Not
    ldy #PLAYER_DEAD
    lda [variable_addr], y
    bne .Not
    jmp .Move
.Not:
    jmp .Stay
.Move:

    ; 右
    ldy #PAD
    lda [variable_addr], y
    and #PAD_RIGHT
    bne .DoRight
    jmp .NotRight
.DoRight:
    ; 空中ではマックススピードから
    ldy #PLAYER_FALL_INDEX
    lda [variable_addr], y
    beq .NotJumpRight
    ldy #PLAYER_SPEED_INDEX
    lda #SPEED_MAX
    sta [variable_addr], y
    jmp .EndIterateRight 
.NotJumpRight:
    ; しゃがみ中はマックススピードから
    ldy #PLAYER_CROUCH
    lda [variable_addr], y
    cmp #CROUCH
    bne .NotCrouchRight
    ldy #PLAYER_SPEED_INDEX
    lda #SPEED_MAX
    sta [variable_addr], y
    jmp .EndIterateRight 
.NotCrouchRight:
    ; インデックスを進める
    ldy #PLAYER_SPEED_INDEX
    lda [variable_addr], y
    clc
    adc #$01
    sta [variable_addr], y
    cmp #SPEED_MAX+1
    bne .EndIterateRight
    lda #SPEED_MAX
    sta [variable_addr], y
.EndIterateRight:
    ; 右に移動
    ldy #PLAYER_SPEED_INDEX
    lda [variable_addr], y
    tax
    ldy #PLAYER_X
    lda [variable_addr], y
    clc
    adc speedTable, x
    sta [variable_addr], y
    iny
    lda [variable_addr], y
    adc #$00
    sta [variable_addr], y
    
    ; リードしていなければ画面外へ移動できなくする
    lda leadplayer
    cmp #LEAD_VACANT
    bne .NotRight
    lda camera_x+1
    clc
    adc #$81
    sta camera_x+1
    ldy #PLAYER_X
    iny
    lda [variable_addr], y
    clc
    adc #$80
    sta [variable_addr], y
    
    lda [variable_addr], y
    cmp camera_x+1
    beq .NextRight
    bcc .NotLimitRight
    jmp .LimitRight
.NextRight:
    dey
    lda [variable_addr], y
    cmp camera_x
    bcc .NotLimitRight
.LimitRight:
    ldy #PLAYER_X
    lda camera_x
    sta [variable_addr], y
    iny
    lda camera_x+1
    sta [variable_addr], y
.NotLimitRight:
    lda camera_x+1
    sec
    sbc #$81
    sta camera_x+1
    ldy #PLAYER_X
    iny
    lda [variable_addr], y
    sec
    sbc #$80
    sta [variable_addr], y

.NotRight:

    ; 左
    ldy #PAD
    lda [variable_addr], y
    and #PAD_LEFT
    bne .DoLeft
    jmp .NotLeft
.DoLeft:
    ; 空中ではマックススピードから
    ldy #PLAYER_FALL_INDEX
    lda [variable_addr], y
    beq .NotJumpLeft
    ldy #PLAYER_SPEED_INDEX
    lda #SPEED_MAX
    sta [variable_addr], y
    jmp .EndIterateLeft 
.NotJumpLeft:
    ; しゃがみ中はマックススピードから
    ldy #PLAYER_CROUCH
    lda [variable_addr], y
    cmp #CROUCH
    bne .NotCrouchLeft
    ldy #PLAYER_SPEED_INDEX
    lda #SPEED_MAX
    sta [variable_addr], y
    jmp .EndIterateLeft 
.NotCrouchLeft:
    ; インデックスを進める
    ldy #PLAYER_SPEED_INDEX
    lda [variable_addr], y
    clc
    adc #$01
    sta [variable_addr], y
    cmp #SPEED_MAX+1
    bne .EndIterateLeft
    lda #SPEED_MAX
    sta [variable_addr], y
.EndIterateLeft:
    ; 左に移動
    ldy #PLAYER_SPEED_INDEX
    lda [variable_addr], y
    tax
    ldy #PLAYER_X
    lda [variable_addr], y
    sec
    sbc speedTable, x
    sta [variable_addr], y
    iny
    lda [variable_addr], y
    sbc #$00
    sta [variable_addr], y

    ; リードしていなければ画面外へ移動できなくする
    lda leadplayer
    cmp #LEAD_VACANT
    bne .NotLeft
    lda camera_x+1
    clc
    adc #$80
    sta camera_x+1
    ldy #PLAYER_X
    iny
    lda [variable_addr], y
    clc
    adc #$80
    sta [variable_addr], y
    
    lda camera_x+1
    cmp [variable_addr], y
    beq .NextLeft
    bcc .NotLimitLeft
    jmp .LimitLeft
.NextLeft:
    lda camera_x
    dey
    cmp [variable_addr], y
    bcc .NotLimitLeft
.LimitLeft:
    ldy #PLAYER_X
    lda camera_x
    sta [variable_addr], y
    iny
    lda camera_x+1
    sta [variable_addr], y
.NotLimitLeft:
    lda camera_x+1
    sec
    sbc #$80
    sta camera_x+1
    ldy #PLAYER_X
    iny
    lda [variable_addr], y
    sec
    sbc #$80
    sta [variable_addr], y
.NotLeft:

    ; 移動しなければインデックスをリセット
    ldy #PAD
    lda [variable_addr], y
    and #PAD_RIGHT+PAD_LEFT
    beq .Stay
    jmp .End
.Stay:
    ldy #PLAYER_SPEED_INDEX
    lda #$00
    sta [variable_addr], y
.End:

    ; テスト用上下
;     ldy #PAD
;     lda [variable_addr], y
;     and #PAD_UP
;     beq .NotUp
;     ldy #PLAYER_Y
;     lda [variable_addr], y
;     sec
;     sbc #$01
;     sta [variable_addr], y
; .NotUp:
;     ldy #PAD
;     lda [variable_addr], y
;     and #PAD_DOWN
;     beq .NotDown
;     ldy #PLAYER_Y
;     lda [variable_addr], y
;     clc
;     adc #$01
;     sta [variable_addr], y
; .NotDown:
    ldy #PAD
    lda [variable_addr], y
    iny
    eor [variable_addr], y
    dey
    and [variable_addr], y
    and #PAD_SELECT
    beq .NotSelect
    ldy #PLAYER_X
    lda [variable_addr], y
    ; sec
    ; sbc #$01
    clc
    adc #$01
    sta [variable_addr], y
.NotSelect:

    rts

speedTable:
    .db $01,$01,$02,$01,$01,$00,$00,$00,$00,$00,$00,$02,$03
