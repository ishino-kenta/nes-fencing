SetPlayerPosition:
    ; compule player1's screen position
    lda player1_x
    sec
    sbc scroll_x
    sta tmp
    lda player1_x+1
    sbc scroll_x+1
    beq .1
    lda #$00
    jmp .2
.1:
    lda tmp
.2:
    sta player1_screen_x

    ; compule player2's screen position
    lda player2_x
    sec
    sbc scroll_x
    sta tmp
    lda player2_x+1
    sbc scroll_x+1
    beq .3
    lda #$00
    jmp .4
.3:
    lda tmp
.4:
    sta player2_screen_x
