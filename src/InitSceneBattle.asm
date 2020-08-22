field_num   .rs 1 ; 1~

stage_table_addr    .rs 2

InitSceneBattle:

    lda #SWORD_MID
    sta player1_sword_height
    lda #SWORD_MID
    sta player2_sword_height

    lda #$00
    sta player1_dead
    sta player2_dead

    lda #VACANT
    sta player_lead

    lda #$20
    sta player1_x
    lda #$04
    sta player1_x+1

    lda #$A0
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

    lda #$80
    sta player1_y
    sta player2_y

    lda selected_stage
    asl a
    tax
    lda stageTable, x
    sta stage_table_addr
    inx
    lda stageTable, x
    sta stage_table_addr+1

    ldy #$00
    lda [stage_table_addr], y
    lsr a
    sta field_num
    inc field_num

    ldy field_num
    lda [stage_table_addr], y
    asl a
    asl a
    tax
    lda filedLimitTable, x
    inx
    sta field_limit_low+1
    lda filedLimitTable, x
    inx
    sta field_limit_low
    lda filedLimitTable, x
    inx
    sta field_limit_high+1
    lda filedLimitTable, x
    inx
    sta field_limit_high

    lda #$07
    sta $8000
    ldy field_num
    lda [stage_table_addr], y
    sta $8001

    rts

    .include "./src/field_data.asm"