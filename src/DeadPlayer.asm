player1_dead   .rs 1
player2_dead   .rs 1

player_lead .rs 1

VACANT = $FF
PLAYER1 = $00
PLAYER2 = $01
DEAD_TIME = $60

DeadPlayer1:

    lda #DEAD_TIME
    sta player1_dead

    ; check lead player
    lda player2_dead
    beq .1
    lda #VACANT
    jmp .2
.1:
    lda #PLAYER2
.2:
    sta player_lead

    rts


DeadPlayer2:

    lda #DEAD_TIME
    sta player2_dead

    ; check lead player
    lda player1_dead
    beq .1
    lda #VACANT
    jmp .2
.1:
    lda #PLAYER1
.2:
    sta player_lead

    rts

DissappearPlayer:

    lda player1_dead
    beq .1
    lda #$FF
    sta player1_x
    sta player1_x+1
.1:

    lda player2_dead
    beq .2
    lda #$FF
    sta player2_x
    sta player2_x+1
.2:

    rts

DecDead:
    ; reborn
    lda player1_dead
    cmp #$01
    bne .n
    lda player2_dead
    cmp #$01
    bne .1
    jmp .both
.n:
    lda player2_dead
    cmp #$01
    beq .2
    jmp .end
.1:

    lda player2_x
    sec
    sbc #$C0
    sta tmp
    lda player2_x+1
    sbc #$00
    sta tmp+1
    ; boundary check
    lda player2_x+1
    cmp #$00
    bne .11
    lda tmp+1
    cmp #$FF
    bne .11
    lda #$00
    sta tmp
    sta tmp+1
    lda #$03
    sta player1_dead
.11:
    lda tmp
;    clc
;    adc #$08 ; Forgot what to add
    sta player1_x
    lda tmp+1
;    adc #$00
    sta player1_x+1

    lda #$A0
    sta player1_y
    lda #$00
    sta player1_jump_speed

    dec player1_dead
    jmp .end
.2:
;
    ; lda player1_x
    ; clc
    ; adc #$C0
    ; sta player2_x
    ; lda player1_x+1
    ; adc #$00
    ; sta player2_x+1
;
    lda player1_x
    clc
    adc #$C0
    sta tmp
    lda player1_x+1
    adc #$00
    sta tmp+1

    ; boundary check

    lda field_limit_high+1
    cmp tmp+1
    beq .aaa
    bcc .bbb
    jmp .ccc
.aaa:
    lda field_limit_high
    cmp tmp
    bcc .bbb
    jmp .ccc
.bbb:
    lda #$00
    sta tmp
    sta tmp+1
    lda #$03
    sta player2_dead
.ccc:

    lda tmp
;    sec
;    sbc #$08 ; Forgot what to sub
    sta player2_x
    lda tmp+1
;    sbc #$00
    sta player2_x+1
;
    lda #$A0
    sta player2_y
    lda #$00
    sta player2_jump_speed

    dec player2_dead

    jmp .end
.both:
    lda scroll_x
    clc
    adc #$18
    sta player1_x
    lda scroll_x+1
    adc #$00
    sta player1_x+1

    lda scroll_x
    clc
    adc #$D8
    sta player2_x
    lda scroll_x+1
    adc #$00
    sta player2_x+1

    lda #$A0
    sta player1_y
    sta player2_y

    lda #$00
    sta player1_jump_speed
    sta player2_jump_speed

    dec player1_dead
    dec player2_dead
.end:

    lda player1_dead
    sec
    sbc #$01
    bcs .i
    lda #$00
.i:
    sta player1_dead

    lda player2_dead
    sec
    sbc #$01
    bcs .j
    lda #$00
.j:
    sta player2_dead

    rts