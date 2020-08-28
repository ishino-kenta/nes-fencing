SPEED = $01
player1_speed_index   .rs 1
player2_speed_index   .rs 1

player1_run .rs 1

RUN = $0B
SPEED_MAX = $0C

MovePlayer1:

    ; test code ---
    lda pad1
    and #PAD_SELECT
    beq .aaa
    lda #$01
    sta player1_speed_index
.aaa:
    ; test code ---


    ; move player1
    lda player1_atttack_index
    beq .move1
    jmp .stay1
.move1:
    lda player1_x
    sta player1_x_pre
    lda player1_x+1
    sta player1_x_pre+1
    
    lda pad1
    and #PAD_RIGHT
    beq .end_right1
    lda player1_speed_index
    clc
    adc #$01
    sta player1_speed_index
    lda player1_crouch
    cmp #CROUCH
    beq .do11
    lda player1_fall_index
    bne .do11
    jmp .not11
.do11:
    lda #SPEED_MAX
    sta player1_speed_index
.not11:
    lda player1_speed_index
    cmp #SPEED_MAX+1
    bne .s11
    lda #SPEED_MAX
    sta player1_speed_index
.s11:
    ldx player1_speed_index
    lda player1_x
    clc
    adc moveTable, x
    sta player1_x
    lda player1_x+1
    adc #$00
    sta player1_x+1

    lda #CHECK_RIGHT
    sta tmp+6
    lda #PLAYER1
    jsr CheckHit

.end_right1:

    lda pad1
    and #PAD_LEFT
    beq .end_left1
    lda player1_speed_index
    clc
    adc #$01
    sta player1_speed_index
    lda player1_crouch
    cmp #CROUCH
    beq .do12
    lda player1_fall_index
    bne .do12
    jmp .not12
.do12:
    lda #SPEED_MAX
    sta player1_speed_index
.not12:
    lda player1_speed_index
    cmp #SPEED_MAX+1
    bne .s12
    lda #SPEED_MAX
    sta player1_speed_index
.s12:
    ldx player1_speed_index
    lda player1_x
    sec
    sbc moveTable, x
    sta player1_x
    lda player1_x+1
    sbc #$00
    sta player1_x+1

    lda #CHECK_LEFT
    sta tmp+6
    lda #PLAYER1
    jsr CheckHit
.end_left1:

    lda pad1
    and #PAD_RIGHT+PAD_LEFT
    beq .stay1
    jmp .end1
.stay1:
    lda #$00
    sta player1_speed_index
.end1:

    rts

MovePlayer2:

    ; move player2
    lda player2_atttack_index
    beq .move2
    jmp .stay2
.move2:

    lda player2_x
    sta player2_x_pre
    lda player2_x+1
    sta player2_x_pre+1

    lda pad2
    and #PAD_RIGHT
    beq .end_right2
    lda player2_speed_index
    clc
    adc #$01
    sta player2_speed_index
    lda player2_crouch
    cmp #CROUCH
    beq .do21
    lda player2_fall_index
    bne .do21
    jmp .not21
.do21:
    lda #SPEED_MAX
    sta player2_speed_index
.not21:
    lda player2_speed_index
    cmp #SPEED_MAX+1
    bne .s21
    lda #SPEED_MAX
    sta player2_speed_index
.s21:
    ldx player2_speed_index
    lda player2_x
    clc
    adc moveTable, x
    sta player2_x
    lda player2_x+1
    adc #$00
    sta player2_x+1

    lda #CHECK_RIGHT
    sta tmp+6
    lda #PLAYER2
    jsr CheckHit
.end_right2:

    lda pad2
    and #PAD_LEFT
    beq .end_left2
    lda player2_speed_index
    clc
    adc #$01
    sta player2_speed_index
    lda player2_crouch
    cmp #CROUCH
    beq .do22
    lda player2_fall_index
    bne .do22
    jmp .not22
.do22:
    lda #SPEED_MAX
    sta player2_speed_index
.not22:
    lda player2_speed_index
    cmp #SPEED_MAX+1
    bne .s22
    lda #SPEED_MAX
    sta player2_speed_index
.s22:
    ldx player2_speed_index
    lda player2_x
    sec
    sbc moveTable, x
    sta player2_x
    lda player2_x+1
    sbc #$00
    sta player2_x+1

    lda #CHECK_LEFT
    sta tmp+6
    lda #PLAYER2
    jsr CheckHit
.end_left2:

    lda pad2
    and #PAD_RIGHT+PAD_LEFT
    beq .stay2
    jmp .end2
.stay2:
    lda #$00
    sta player2_speed_index
.end2:
    rts

moveTable:
    .db $01,$02,$03,$02,$01,$00,$00,$00,$00,$00,$00,$02,$03
