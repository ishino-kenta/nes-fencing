player1_direction   .rs 1
player2_direction   .rs 1

SetPlayerPosition:
    ; compule player1's screen position
    lda player1_x
    sec
    sbc scroll_x
    sta tmp
    lda player1_x+1
    sbc scroll_x+1
    sta tmp+1
    lda tmp
    clc
    adc #$08
    lda tmp+1
    adc #$00
    beq .1
    lda #$00
    jmp .2
.1:
    lda tmp
    clc
    adc #$08
.2:
    sta player1_screen_x

    ; compule player2's screen position
    lda player2_x
    sec
    sbc scroll_x
    sta tmp
    lda player2_x+1
    sbc scroll_x+1
    sta tmp+1
    lda tmp
    clc
    adc #$08
    lda tmp+1
    adc #$00
    beq .3
    lda #$00
    jmp .4
.3:
    lda tmp
    clc
    adc #$08
.4:
    sta player2_screen_x

    ; compute player direction

    lda player1_dead
    beq .a
    lda #DIRECTION_LEFT
    sta player2_direction
    jmp .e
.a:
    lda player2_dead
    beq .b
    lda #DIRECTION_RIGHT
    sta player1_direction
    jmp .e
.b:

    lda player1_x+1
    cmp player2_x+1
    beq .5
    bcc .6
    jmp .7
.5:
    lda player1_x
    cmp player2_x
    bcc .6
    jmp .7
.6:
    lda #DIRECTION_RIGHT
    sta player1_direction
    lda #DIRECTION_LEFT
    sta player2_direction
    jmp .8
.7:
    lda #DIRECTION_RIGHT
    sta player2_direction
    lda #DIRECTION_LEFT
    sta player1_direction
.8:
.e:
    