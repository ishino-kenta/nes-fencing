SetCursor:

    lda selected_stage
    asl a
    tay

    ldx oam_counter

    lda cursorTable, y
    sta OAM, x
    inx
    iny

    lda #$04
    sta OAM, x
    inx

    lda #$00
    sta OAM, x
    inx

    lda cursorTable, y
    sta OAM, x
    inx

    stx oam_counter


    rts

cursorTable:
    ; cursor_y, corsor_x
    .db $3F,$18
    .db $4F,$18