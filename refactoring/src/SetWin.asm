SetWin:

    ; 大量に描画するのでグラフィックをオフ
    lda soft2000
    and #$7F
    sta soft2000
    lda soft2001
    and #$E7
    sta soft2001

    inc wait_nmi
.Wn1:
    lda wait_nmi
    bne .Wn1

    ; タイル初期化
    ldx #$00
    ldy #$00
.TileInitLoop:
    lda #$F0
    sta DRAW_BUFF, x
    inx
    lda #INC_1+DATA_ONE
    sta DRAW_BUFF, x
    inx
    lda tileIint, y
    sta DRAW_BUFF, x
    inx
    iny
    lda tileIint, y
    sta DRAW_BUFF, x
    inx
    iny
    lda #$00
    sta DRAW_BUFF, x
    inx

    cpy #$08
    bne .TileInitLoop

    lda #$00
    sta DRAW_BUFF, x

    jsr DrawBG

    ; 属性初期化
    ldx #$00
    lda #$40
    sta DRAW_BUFF, x
    inx
    lda #INC_1+DATA_ONE
    sta DRAW_BUFF, x
    inx
    lda #$C0
    sta DRAW_BUFF, x
    inx
    iny
    lda #$23
    sta DRAW_BUFF, x
    inx
    iny
    lda #$00
    sta DRAW_BUFF, x
    inx
    lda #$00
    sta DRAW_BUFF, x
    jsr DrawBG

    ; CONGRATULATIONS

    ldx #$00
    
    lda #$0F
    sta DRAW_BUFF, x
    inx
    lda #INC_1+DATA_ROM
    sta DRAW_BUFF, x
    inx
    lda #$09
    sta DRAW_BUFF, x
    inx
    lda #$23
    sta DRAW_BUFF, x
    inx
    lda #LOW(congratulationsTile)
    sta DRAW_BUFF, x
    inx
    lda #HIGH(congratulationsTile)
    sta DRAW_BUFF, x
    inx

    ; Player

    lda #$05
    sta DRAW_BUFF, x
    inx
    lda #INC_1+DATA_ROM
    sta DRAW_BUFF, x
    inx
    lda #$06
    sta DRAW_BUFF, x
    inx
    lda #$21
    sta DRAW_BUFF, x
    inx
    lda #LOW(playerTile)
    sta DRAW_BUFF, x
    inx
    lda #HIGH(playerTile)
    sta DRAW_BUFF, x
    inx

    lda #$01
    sta DRAW_BUFF, x
    inx
    lda #INC_1+DATA_ONE
    sta DRAW_BUFF, x
    inx
    lda #$0B
    sta DRAW_BUFF, x
    inx
    lda #$21
    sta DRAW_BUFF, x
    inx
    lda area_num
    lsr a
    lsr a
    lsr a
    lsr a
    lsr a
    lsr a
    lsr a
    clc
    adc #$11
    sta DRAW_BUFF, x
    inx

    lda #$00
    sta DRAW_BUFF, x

    jsr DrawBG


    ; WIN

    lda #$00
    sta set_title_counter
    sta set_title_counter+1
    ldx #$00
.WinLoop:

    lda #$09
    sta DRAW_BUFF, x
    inx
    lda #INC_1+DATA_ROM
    sta DRAW_BUFF, x
    inx
    lda #$2D
    clc
    adc set_title_counter
    sta DRAW_BUFF, x
    inx
    lda #$21
    sta DRAW_BUFF, x
    inx
    lda #LOW(winTile)
    clc
    adc set_title_counter+1
    sta DRAW_BUFF, x
    inx
    lda #HIGH(winTile)
    adc #$00
    sta DRAW_BUFF, x
    inx

    lda set_title_counter
    clc
    adc #$20
    sta set_title_counter
    lda set_title_counter+1
    clc
    adc #$09
    sta set_title_counter+1

    lda set_title_counter
    cmp #$60
    bne .WinLoop

    lda #$00
    sta DRAW_BUFF, x

    jsr DrawBG


    lda #$00
    sta draw_buff_counter

    lda $2002
    lda soft2000
    ora #$80
    sta soft2000
    sta $2000

    inc wait_nmi
.Wn2:
    lda wait_nmi
    bne .Wn2

    lda soft2001
    ora #$18
    sta soft2001

    rts

congratulationsTile:    
    .incbin "./res/congratulations_hor.tile"
winTile:    
    .incbin "./res/win_hor.tile"
playerTile:    
    .incbin "./res/player_hor.tile"
