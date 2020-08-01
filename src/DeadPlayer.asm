player1_dead   .rs 1
player2_dead   .rs 1

player_lead .rs 1

VACANT = $00
PLAYER1 = $01
PLAYER2 = $02
DEAD_TIME = $FF

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
    lda #$FE
    sta player1_x
    sta player1_x+1
.1:

    lda player2_dead
    beq .2
    lda #$FE
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
    jmp .e
.1:
    lda player2_x
    sec
    sbc #$C0
    sta player1_x
    lda player2_x+1
    sbc #$00
    sta player1_x+1

; boundary processing.
; but I dont know it is ok.
; should I use x=0 for boundary?
;
;     lda player2_x+1
;     cmp #$00
;     bne .11
;     lda tmp+1
;     cmp #$FF
;     bne .11
;     lda #$FE
;     sta tmp
;     sta tmp+1
;     lda #$03
;     sta player1_dead
; .11:
;     lda tmp
;     sta player1_x
;     lda tmp+1
;     sta player1_x+1

    dec player1_dead
    jmp .e
.2:
    lda player1_x
    clc
    adc #$C0
    sta player2_x
    lda player1_x+1
    adc #$00
    sta player2_x+1
    dec player2_dead
    jmp .e
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

    dec player1_dead
    dec player2_dead
.e:

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