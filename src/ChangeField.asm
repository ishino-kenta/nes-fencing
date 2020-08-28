attr_addr   .rs 2

ChangeField:
    ; right
    lda player_lead
    cmp #PLAYER1
    beq .go1
    jmp .not1
.go1:

    lda field_limit_high
    sec
    sbc #$09
    sta tmp
    lda field_limit_high+1
    sbc #$00
    sta tmp+1

    lda tmp+1
    cmp player1_x+1
    beq .d1
    bcc .do1
    jmp .not1
.d1:
    lda tmp
    cmp player1_x
    bcc .do1
    jmp .not1
.do1:

    lda field_num
    clc
    adc #$01
    sta field_num

    tay
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
    sta attr_addr+1
    lda filedLimitTable, x
    inx
    sta field_limit_high
    sta attr_addr

    lda field_limit_low
    sta player1_x
    sta scroll_x
    lda field_limit_low+1
    sta player1_x+1
    sta scroll_x+1

    jsr DeadPlayer2

    jmp .c

.not1:
    ;left

    lda player_lead
    cmp #PLAYER2
    beq .go2
    jmp .not2
.go2:

    lda field_limit_low
    clc
    adc #$01
    sta tmp
    lda field_limit_low
    adc #$00
    sta tmp+1
    

    lda player2_x+1
    cmp tmp+1
    beq .d2
    bcc .do2
    jmp .not2
.d2:
    lda player2_x
    cmp tmp
    bcc .do2
    jmp .not2
.do2:

    lda field_num
    sec
    sbc #$01
    sta field_num

    tay
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
    sta attr_addr+1
    lda filedLimitTable, x
    inx
    sta field_limit_high
    sta attr_addr


    lda field_limit_high
    sec
    sbc #$08
    sta player2_x
    lda field_limit_high+1
    sbc #$00
    sta player2_x+1
    lda field_limit_high
    sec
    sbc #$F8
    sta scroll_x
    lda field_limit_high+1
    sbc #$00
    sta scroll_x+1

    jsr DeadPlayer1

    jmp .c

.not2:
    jmp .endc
.c:
    ; attr data address
    ; tile + (limit_high / 8 * 24)
    lda attr_addr
    and #$F8
    sta tmp
    lda attr_addr+1
    sta tmp+1
    asl attr_addr
    rol attr_addr+1
    lda attr_addr
    clc
    adc tmp
    sta attr_addr
    lda attr_addr+1
    adc tmp+1
    sta attr_addr+1
    lda #LOW(tile1)
    clc
    adc attr_addr
    sta attr_addr
    lda #HIGH(tile1)
    adc attr_addr+1
    sta attr_addr+1

    ; reload BG
    lda soft2000
    and #$7F
    sta soft2000
    sta $2000
    lda soft2001
    and #$E7
    sta soft2001
    sta $2001

    lda #$07
    sta $8000
    ldy field_num
    lda [stage_table_addr], y
    sta $8001

    lda #LOW(tile3)
    sta source_addr
    lda #HIGH(tile3)
    sta source_addr+1
    lda attr_addr
    sta source_addr+2
    lda attr_addr+1
    sta source_addr+3
    jsr ReloadBG

    lda soft2000
    ora #$80
    sta soft2000
    sta $2000
    lda soft2001
    ora #$18
    sta soft2001

.endc:

    rts

