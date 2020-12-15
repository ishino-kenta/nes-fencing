;--------------------------------------------------
; DRAW_BUFF($0300~) のデータを描画する．
; DRAW_BUFF には以下のフォーマットでデータをスタックする．
; 
; データフォーマット
;  0. Length (0 がデータの終わりを示す)
;
;  1. Flag
;   0-1. "inc mode" 
;    "00". inc 1 (タイル/アトリビュートを行で)
;    "01". inc 32 (タイルを列で) 
;    "10". inc 8 (アトリビュートを列で)
; 
;   2-3. "data mode"
;    "00". data from DRAW_BUFF
;    "01". data from rom
;    "10". one data
;
;  2. アドレス($2000~$23BF) low バイト
;  3. アドレス high バイト
;
;  ("data mode" が data from DRAW_BUFF のとき)
;  4~. タイルナンバー (length の分繰り返し)
;  ("data mode" が data from rom のとき)
;  4-5. rom アドレス low-high
;  ("data mode" が one data のとき)
;  4. タイルナンバー
;
; 利用するレジスタ
; a,x,y
;
; ???? BUG ????
; In situation that BG and sprite off. 
; length $80, data from rom, PPU behaves strangely in this situation
; length $40, data from rom, PPU behaves correctly in this situation
;


DRAW_BUFF = $0300
INC_1 = $00
INC_32 = $01
INC_8 = $02
DATA_BUFF = $00
DATA_ROM = $04
DATA_ONE = $08


DrawBG:
    ldx #$00
.Start:
    lda DRAW_BUFF, x
    inx
    cmp #$00
    bne .DoDraw
    jmp .End

.DoDraw:
    sta tmp_drawbg
    ; inc 32
    lda DRAW_BUFF, x
    and #$01
    asl a
    asl a
    ora soft2000
    sta $2000
    ; mode
    lda DRAW_BUFF, x
    inx
    and #$0E

    tay
    lda .pointer_table, y
    sta tmp_drawbg+1
    lda .pointer_table+1, y
    sta tmp_drawbg+2
    jmp [tmp_drawbg+1]

.TileBuf:
    lda DRAW_BUFF, x
    inx
    sta $2006
    lda DRAW_BUFF, x
    inx
    sta $2006
    ldy #$00
.Loop1:
    lda DRAW_BUFF, x
    inx
    sta $2007
    iny
    cpy tmp_drawbg
    bne .Loop1
    jmp .Start

.TileRom:
    lda DRAW_BUFF, x
    inx
    sta $2006
    lda DRAW_BUFF, x
    inx
    sta $2006
    lda DRAW_BUFF, x
    inx
    sta tmp_drawbg+1
    lda DRAW_BUFF, x
    inx
    sta tmp_drawbg+2
    ldy #$00
.Loop2:
    lda [tmp_drawbg+1], y
    iny
    sta $2007
    cpy tmp_drawbg
    bne .Loop2
    jmp .Start

.AttrBuf:
    lda DRAW_BUFF, x
    inx
    sta tmp_drawbg+1
    lda DRAW_BUFF, x
    inx
    sta tmp_drawbg+2
    ldy #$00
.Loop3:
    lda tmp_drawbg+1
    sta $2006
    lda tmp_drawbg+2
    sta $2006
    lda DRAW_BUFF, x
    inx
    sta $2007
    lda tmp_drawbg+2
    clc
    adc #$08
    sta tmp_drawbg+2
    iny
    cpy tmp_drawbg
    bne .Loop3
    jmp .Start

.AttrRom:
    lda DRAW_BUFF, x
    inx
    sta tmp_drawbg+1
    lda DRAW_BUFF, x
    inx
    sta tmp_drawbg+2
    lda DRAW_BUFF, x
    inx
    sta tmp_drawbg+3
    lda DRAW_BUFF, x
    inx
    sta tmp_drawbg+4
    ldy #$00
.Loop4:
    lda tmp_drawbg+1
    sta $2006
    lda tmp_drawbg+2
    sta $2006
    lda [tmp_drawbg+3], y
    iny
    sta $2007
    lda tmp_drawbg+2
    clc
    adc #$08
    sta tmp_drawbg+2
    cpy tmp_drawbg
    bne .Loop4
    jmp .Start

.TileOne:
    lda DRAW_BUFF, x
    inx
    sta $2006
    lda DRAW_BUFF, x
    inx
    sta $2006
    ldy #$00
.Loop5:
    lda DRAW_BUFF, x
    sta $2007
    iny
    cpy tmp_drawbg
    bne .Loop5
    inx

    jmp .Start

.AttrOne:
    ; 未実装
    jmp .Start

.End:
    rts

.pointer_table:
    .dw .TileBuf, .AttrBuf, .TileRom, .AttrRom, .TileOne, .AttrOne, $0000, $0000

