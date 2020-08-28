PlayerWin:
    lda player_lead
    cmp #PLAYER1
    beq .do1
    jmp .not1
.do1:

    ldy #$00
    lda [stage_table_addr], y
    clc
    adc #$01
    cmp field_num
    beq .do12
    jmp .not1
.do12:

    lda #$00
    sta player1_screen_x
    sta player2_screen_x
    sta player1_crouch
    lda #RUN
    sta player1_speed_index
    
    jmp .w

.not1:

    lda player_lead
    cmp #PLAYER2
    beq .do2
    jmp .not2
.do2:
    lda #$00
    cmp field_num
    beq .do22
    jmp .not2
.do22:


    lda #$00
    sta player2_screen_x
    sta player1_screen_x
    sta player2_crouch
    lda #RUN
    sta player2_speed_index

    jmp .w
.not2:
    jmp .end

.w:

    lda #$08
    sta scroll_x
    lda #$00
    sta scroll_x+1

    jsr ComputePlayerTop

    jsr SetPlayer

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
    lda #$03
    sta $8001

    ; set BG

    lda #LOW(title)
    sta source_addr
    lda #HIGH(title)
    sta source_addr+1
    lda #LOW(title_attr)
    sta source_addr+2
    lda #HIGH(title_attr)
    sta source_addr+3
    jsr ReloadBG

    ; WIN
    
    ldx #$00
    lda #$C0
    sta DRAW_BUFFER, x ; lenght
    inx
    lda #FLAG_DATA_ONE
    sta DRAW_BUFFER, x ; flag
    inx
    lda #$20
    sta DRAW_BUFFER, x ; addr high
    inx
    lda #$F0
    sta DRAW_BUFFER, x ; addr low
    inx
    lda #$00
    sta DRAW_BUFFER, x ; data
    inx
    lda #$00
    sta DRAW_BUFFER, x ; end
    inx
    
    jsr DrawBG

    ldx #$00
    lda #$40
    sta DRAW_BUFFER, x ; lenght
    inx
    lda #FLAG_DATA_ROM
    sta DRAW_BUFFER, x ; flag
    inx
    lda #$21
    sta DRAW_BUFFER, x ; addr high
    inx
    lda #$00
    sta DRAW_BUFFER, x ; addr low
    inx
    lda #LOW(win)
    sta DRAW_BUFFER, x ; data
    inx
    lda #HIGH(win)
    sta DRAW_BUFFER, x ; data
    inx
    lda #$00
    sta DRAW_BUFFER, x ; end
    inx
    
    jsr DrawBG

    ldx #$00
    lda #$40
    sta DRAW_BUFFER, x ; lenght
    inx
    lda #FLAG_DATA_ROM
    sta DRAW_BUFFER, x ; flag
    inx
    lda #$21
    sta DRAW_BUFFER, x ; addr high
    inx
    lda #$40
    sta DRAW_BUFFER, x ; addr low
    inx
    lda #LOW(win)
    sta tmp
    lda #HIGH(win)
    sta tmp+1
    lda tmp
    clc
    adc #$40
    sta tmp
    lda tmp+1
    adc #$00
    sta tmp+1
    lda tmp
    sta DRAW_BUFFER, x ; data
    inx
    lda tmp+1
    sta DRAW_BUFFER, x ; data
    inx
    lda #$00
    sta DRAW_BUFFER, x ; end
    inx
    
    jsr DrawBG

    lda soft2000
    ora #$80
    sta soft2000
    sta $2000
    lda soft2001
    ora #$18
    sta soft2001


    lda #LOW(SceneResult)
    sta game_scene
    lda #HIGH(SceneResult)
    sta game_scene+1

.end:

    rts