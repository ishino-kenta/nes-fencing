;--------------------------------------------------
; DRAW_BUFFER $0300~
; format
;  0. length (0 is end of datas)
;  1. flag
;   0. inc 32 (don't use for atteribute)
;   1-2. mode
;    00. tile or attr row, data from DRAW_BUFFER 
;    01. tile or attr row colmun, data from rom
;    10. attr colmun, data from DRAW_BUFFER
;    11. attr colmun(), data from rom
;  2. address($2000~$23BF) low bite
;  3. address high bite
;  4~. tile number (repeat for length)
;  4-5. (rom mode) rom address low-high
;
; used register
; a,x,y

DRAW_BUFFER = $0300
FLAG_INC32 = $01
FLAG_MODE_TILE_BUFF = $00
FLAG_MODE_TILE_ROM = $02
FLAG_MODE_ATTR_BUFF = $04
FLAG_MODE_ATTR_ROM = $06


tmp_drawbg .rs 5

DrawBG:
    ldx #$00
.start:
    lda DRAW_BUFFER, x
    inx
    cmp #$00
    bne .do_draw
    jmp .end
.do_draw:
    sta tmp_drawbg
    ; inc 32
    lda DRAW_BUFFER, x
    and #$01
    asl a
    asl a
    ora #%10010000
    sta $2000
    ; mode
    lda DRAW_BUFFER, x
    inx
    and #$06

    tay
    lda .pointer_table, y
    sta tmp_drawbg+1
    lda .pointer_table+1, y
    sta tmp_drawbg+2
    jmp [tmp_drawbg+1]


.tile_buf:
    lda DRAW_BUFFER, x
    inx
    sta $2006
    lda DRAW_BUFFER, x
    inx
    sta $2006
    ldy #$00
.loop1:
    lda DRAW_BUFFER, x
    inx
    sta $2007
    iny
    cpy tmp_drawbg
    bne .loop1
    jmp .start

.tile_rom:
    lda DRAW_BUFFER, x
    inx
    sta $2006
    lda DRAW_BUFFER, x
    inx
    sta $2006
    lda DRAW_BUFFER, x
    inx
    sta tmp_drawbg+1
    lda DRAW_BUFFER, x
    inx
    sta tmp_drawbg+2
    ldy #$00
.loop2:
    lda [tmp_drawbg+1], y
    iny
    sta $2007
    cpy tmp_drawbg
    bne .loop2
    jmp .start

.attr_buf:
    lda DRAW_BUFFER, x
    inx
    sta tmp_drawbg+1
    lda DRAW_BUFFER, x
    inx
    sta tmp_drawbg+2
    ldy #$00
.loop3:
    lda tmp_drawbg+1
    sta $2006
    lda tmp_drawbg+2
    sta $2006
    lda DRAW_BUFFER, x
    inx
    sta $2007
    lda tmp_drawbg+2
    clc
    adc #$08
    sta tmp_drawbg+2
    iny
    cpy tmp_drawbg
    bne .loop3
    jmp .start

.attr_rom:
    lda DRAW_BUFFER, x
    inx
    sta tmp_drawbg+1
    lda DRAW_BUFFER, x
    inx
    sta tmp_drawbg+2
    lda DRAW_BUFFER, x
    inx
    sta tmp_drawbg+3
    lda DRAW_BUFFER, x
    inx
    sta tmp_drawbg+4
    ldy #$00
.loop4:
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
    bne .loop4
    jmp .start
    
.end:
    rts

.pointer_table:
    .dw .tile_buf, .tile_rom, .attr_buf, .attr_rom

