BoundaryCheck1:
    ; boundary check
    lda player1_x+1
    cmp #$FF
    bne .end1
    lda player1_x_pre+1
    cmp #$00
    bne .end1
    lda #$00
    sta player1_x
    sta player1_x+1
.end1:

    lda player_lead
    cmp #VACANT
    bne .e
    lda scroll_x+1
    cmp player1_x+1
    bcc .n
    lda scroll_x
    cmp player1_x
    bcc .n
    lda scroll_x
    sta player1_x
    lda scroll_x+1
    sta player1_x+1
.n:
    lda scroll_x
    clc
    adc #$F0
    sta tmp
    lda scroll_x+1
    adc #$00
    sta tmp+1
    
    lda player1_x+1
    cmp tmp+1
    bcc .e
    lda player1_x
    cmp tmp
    bcc .e

    lda tmp
    sta player1_x
    lda tmp+1
    sta player1_x+1
.e:
    rts

BoundaryCheck2:
    lda player2_x+1
    cmp #$FF
    bne .end2
    lda player2_x_pre+1
    cmp #$00
    bne .end2
    lda #$00
    sta player2_x
    sta player2_x+1
.end2:
    lda #$0A
    sta test

    lda player_lead
    cmp #VACANT
    bne .e
    lda scroll_x+1
    cmp player2_x+1
    bcc .n
    lda scroll_x
    cmp player2_x
    bcc .n
    lda scroll_x
    sta player2_x
    lda scroll_x+1
    sta player2_x+1
.n:
    lda scroll_x
    clc
    adc #$F0
    sta tmp
    lda scroll_x+1
    adc #$00
    sta tmp+1
    
    lda player2_x+1
    cmp tmp+1
    bcc .e
    lda player2_x
    cmp tmp
    bcc .e

    lda tmp
    sta player2_x
    lda tmp+1
    sta player2_x+1
.e:

    rts