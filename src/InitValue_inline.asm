InitValue:
    lda #$00
    sta scroll_x
    sta scroll_x+1
    sta scroll_y
    sta scroll_y+1

    lda #$60
    sta player1_x
    lda #$01
    sta player1_x+1

    lda #$80
    sta player2_x
    lda #$01
    sta player2_x+1

    lda #SWORD_UP
    sta player1_sword_height
    lda #SWORD_MID
    sta player2_sword_height

    lda #$00
    sta player1_dead
    sta player2_dead

    lda #VACANT
    sta player_lead

    lda #$38
    sta player1_x
    lda #$04
    sta player1_x+1

    lda #$78
    sta player2_x
    lda #$04
    sta player2_x+1

    lda player1_x
    clc
    adc player2_x
    sta tmp
    lda player1_x+1
    adc player2_x+1
    sta tmp+1
    lda #$00
    adc #$00
    sta tmp+2
    lsr tmp+2
    ror tmp+1
    ror tmp
    lda tmp
    sec
    sbc #$78
    sta scroll_x
    lda tmp+1
    sbc #$00
    sta scroll_x+1

    lda #$50
    sta player1_y