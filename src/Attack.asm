player1_atttack_counter .rs 1
player2_atttack_counter .rs 1

Attack:
    ; player1
    lda player1_atttack_counter
    beq .2
    dec player1_atttack_counter
.2:

    lda pad1
    eor pad1_pre
    and pad1
    cmp #PAD_A
    bne .1
    lda player1_atttack_counter
    bne .1
    lda #$12
    sta player1_atttack_counter
.1:
    lda player1_atttack_counter

    ; player2
    lda player2_atttack_counter
    beq .3
    dec player2_atttack_counter
.3:

    lda pad2
    eor pad2_pre
    and pad2
    cmp #PAD_A
    bne .4
    lda player2_atttack_counter
    bne .4
    lda #$12
    sta player2_atttack_counter
.4:
    lda player2_atttack_counter

    rts

attackTable:
    .db $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F,$10
    .db $0C,$08,$04
