ChangeField:
    ; right
    lda player_lead
    cmp #PLAYER1
    beq .go1
    jmp .not1
.go1:
    lda field_limit_high+1
    cmp player1_x+1
    beq .d1
    bcc .do1
    jmp .not1
.d1:
    lda field_limit_high
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
    lda filedLimitTable, x
    inx
    sta field_limit_high

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
    lda player2_x+1
    cmp field_limit_low+1
    beq .d2
    bcc .do2
    jmp .not2
.d2:
    lda player2_x
    cmp field_limit_low
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
    lda filedLimitTable, x
    inx
    sta field_limit_high


    lda field_limit_high
    sta player2_x
    lda field_limit_high+1
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

