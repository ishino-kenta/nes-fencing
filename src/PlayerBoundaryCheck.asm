PlayerBoundaryCheck1:
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
    beq .eq1
    bcc .n
    jmp .o1
.eq1:
    lda scroll_x
    cmp player1_x
    bcc .n
.o1:
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
    beq .eq2
    bcc .e
    jmp .o2
.eq2:
    lda player1_x
    cmp tmp
    bcc .e
.o2:
    lda tmp
    sta player1_x
    lda tmp+1
    sta player1_x+1
.e:

    ; field limit
;     lda field_limit_high+1
;     sta tmp+1
;     lda field_limit_high
;     sta tmp
;     lda tmp
;     sec
;     sbc #$08
;     sta tmp
;     lda tmp+1
;     sbc #$00
;     sta tmp+1
;     lda tmp+1
;     cmp player1_x+1
;     beq .eq
;     bcc .bnd
;     jmp .endb
; .eq:
;     lda tmp
;     cmp player1_x
;     bcc .bnd
;     jmp .endb
; .bnd:
;     lda tmp+1
;     sta player1_x+1
;     lda tmp
;     sta player1_x
; .endb:


    rts

PlayerBoundaryCheck2:
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
    lda player_lead
    cmp #VACANT
    bne .e
    lda scroll_x+1
    cmp player2_x+1
    beq .eq1
    bcc .n
    jmp .o1
.eq1:
    lda scroll_x
    cmp player2_x
    bcc .n
.o1:
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
    beq .eq2
    bcc .e
    jmp .o2
.eq2:
    lda player2_x
    cmp tmp
    bcc .e
.o2:
    lda tmp
    sta player2_x
    lda tmp+1
    sta player2_x+1
.e:

    ; field limit
;     lda field_limit_high+1
;     sta tmp+1
;     lda field_limit_high
;     sta tmp
;     lda tmp
;     sec
;     sbc #$08
;     sta tmp
;     lda tmp+1
;     sbc #$00
;     sta tmp+1
;     lda tmp+1
;     cmp player2_x+1
;     beq .eq
;     bcc .bnd
;     jmp .endb
; .eq:
;     lda tmp
;     cmp player2_x
;     bcc .bnd
;     jmp .endb
; .bnd:
;     lda tmp+1
;     sta player2_x+1
;     lda tmp
;     sta player2_x
; .endb:

    rts