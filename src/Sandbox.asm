Sandbox:

;     lda pad1
;     eor pad1_pre
;     and pad1
;     and #PAD_START
;     beq .aaa

;     lda #$07
;     sta $8000
;     ldy #$20
;     lda [stage_table_addr], y
;     sta $8001

; .aaa:


    rts