PAD_RIGHT = $01
PAD_LEFT = $02
PAD_DOWN = $04
PAD_UP = $08
PAD_START = $10
PAD_SELECT = $20
PAD_B = $40
PAD_A = $80

;--------------------------------------------------
; 


ReadPad1:
    lda pad1
    sta pad1_pre
    lda #$01
    sta $4016
    lda #$00
    sta $4016
    ldx #$08
.Loop:
    lda $4016
    lsr a
    rol pad1
    dex
    bne .Loop
    rts

;--------------------------------------------------
; 


ReadPad2:
    lda pad2
    sta pad2_pre
    lda #$01
    sta $4017
    lda #$00
    sta $4017
    ldx #$08
.Loop:
    lda $4017
    lsr a
    rol pad2
    dex
    bne .Loop
    rts