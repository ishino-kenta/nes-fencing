

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
    beq .Move
    jmp .End
.Move:

    ; 右
    ldy #PAD
    lda [variable_addr], y
    and #PAD_RIGHT
    beq .NotRight
    ; ジャンプ中はマックススピードから
    ldy #PLAYER_JUMP_SPEED
    lda [variable_addr], y
    beq .NotJumpRight
    ldy #PLAYER_SPEED_INDEX
    lda #SPEED_MAX
    sta [variable_addr], y
    jmp .EndIterateRight 
.NotJumpRight:
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
.NotRight:

    ; 左
    ldy #PAD
    lda [variable_addr], y
    and #PAD_LEFT
    beq .NotLeft
    ; ジャンプ中はマックススピードから
    ldy #PLAYER_JUMP_SPEED
    lda [variable_addr], y
    beq .NotJumpLeft
    ldy #PLAYER_SPEED_INDEX
    lda #SPEED_MAX
    sta [variable_addr], y
    jmp .EndIterateLeft 
.NotJumpLeft:
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

    rts

speedTable:
    .db $01,$02,$03,$02,$01,$00,$00,$00,$00,$00,$00,$02,$03
