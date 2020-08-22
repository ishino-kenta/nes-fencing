player1_atttack_index .rs 1
player2_atttack_index .rs 1

Attack1:
    ; player1
    lda player1_atttack_index
    beq .2
    dec player1_atttack_index
.2:

    lda pad1
    eor pad1_pre
    and pad1
    cmp #PAD_B
    bne .1
    lda player1_atttack_index
    bne .1
    lda player1_fall_index
    bne .1
    lda #$12
    sta player1_atttack_index
.1:
    lda player1_atttack_index

    rts

Attack2:
    ; player2
    lda player2_atttack_index
    beq .3
    dec player2_atttack_index
.3:

    lda pad2
    eor pad2_pre
    and pad2
    cmp #PAD_B
    bne .4
    lda player2_atttack_index
    bne .4
    lda player2_fall_index
    bne .4
    lda #$12
    sta player2_atttack_index
.4:
    lda player2_atttack_index

    rts

attackTable:
    .db $00,$00, $FF,$FF, $FE,$FF, $FD,$FF, $FC,$FF, $FB,$FF, $FA,$FF, $F9,$FF, $F8,$FF
    .db $F7,$FF, $F6,$FF, $F5,$FF, $F4,$FF, $F3,$FF, $F2,$FF, $F1,$FF, $F0,$FF
    .db $F4,$FF, $F8,$FF, $FC,$FF
    
    .db $00,$00, $01,$00, $02,$00, $03,$00, $04,$00, $05,$00, $06,$00, $07,$00, $08,$00
    .db $09,$00, $0A,$00, $0B,$00, $0C,$00, $0D,$00, $0E,$00, $0F,$00, $10,$00
    .db $0C,$00, $08,$00, $04,$00
