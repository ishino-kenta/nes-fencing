; ines header
    .inesprg 1  ; 1x 16KB PRG code
    .ineschr 1  ; 1x  8KB CHR data
    .inesmap 4 
    .inesmir 1

inline .macro
    .include "./src/\1_inline.asm"
    .endm

OAM = $0200
DIRECTION_LEFT = $01
DIRECTION_RIGHT = $00

    .rsset $0000
test .rs 2
tmp .rs 4
source_addr .rs 2

draw_ready  .rs 1
wait_nmi    .rs 1
do_draw .rs 1
do_dma  .rs 1

soft2000    .rs 1
soft2001    .rs 1

ppu_counter .rs 1
oam_counter .rs 1

scroll_x    .rs 2
scroll_x_pre    .rs 2
direction_scroll    .rs 1
nt_base .rs 1
scroll_y    .rs 2

player1_x   .rs 2
player1_x_pre   .rs 2
player1_screen_x    .rs 1
player2_x   .rs 2
player2_x_pre   .rs 2
player2_screen_x    .rs 1





; main proces
    .bank 0
    .org $C000 

Main:

.vw1:
    bit $2002
    bpl .vw1

    lda #LOW(palette)
    sta source_addr
    lda #HIGH(palette)
    sta source_addr+1
    jsr LoadPalette


.vw2:
    bit $2002
    bpl .vw2

    lda #$00
    sta scroll_x
    sta scroll_x+1
    sta scroll_y
    sta scroll_y+1

    lda #$50
    sta player1_x
    lda #$01
    sta player1_x+1

    lda #$A0
    sta player2_x
    lda #$01
    sta player2_x+1

    lda #SWORD_UP
    sta player1_sword_height



    ; draw bg

    lda #$01
    sta tmp
.loop:
    ldx #$00
    lda #$1E
    sta DRAW_BUFFER, x
    inx
    lda #FLAG_INC32+FLAG_MODE_TILE_ROM
    sta DRAW_BUFFER, x
    inx
    lda #$20
    sta DRAW_BUFFER, x
    inx
    lda tmp
    sta DRAW_BUFFER, x
    inx

    lda #$00
    sta tmp+1
    lda tmp
    sec
    sbc #$01
    clc
    adc #$20
    asl a
    rol tmp+1
    asl a
    rol tmp+1
    asl a
    rol tmp+1
    asl a
    rol tmp+1
    asl a
    rol tmp+1

    clc
    adc #LOW(tile1)
    sta DRAW_BUFFER, x
    inx
    lda #HIGH(tile1)
    adc tmp+1
    sta DRAW_BUFFER, x
    inx

    lda #$00
    sta DRAW_BUFFER, x
    inx
    jsr DrawBG
    inc tmp
    lda tmp
    cmp #$20
    bne .loop

    lda #$01
    sta $A000

    lda #%10010000  ; enable NMI
    sta soft2000
    sta $2000
    lda #%00011000  ; enable spr/BG
    sta soft2001
    sta $2001

MainLoop:

    lda #$01
    sta do_draw
    sta do_dma

WatiNMI:
    inc wait_nmi
.loop:
    lda wait_nmi
    bne .loop

    ; =main logic=

    jsr ReadPad1
    jsr ReadPad2

    lda #$00
    sta ppu_counter
    sta oam_counter

    inline MovePlayer
    
    inline MoveScreen

    inline SetPlayerPosition

    inline ChangeSwordHeight

    jsr Attack
    
    inline SetSprite

    ; switch base nametable
    lda soft2000
    and #$FE
    ora nt_base
    sta soft2000

    .include "./src/SetTile_inline.asm"


    jmp MainLoop

NMI:

    lda do_draw
    beq .not_draw
    jsr DrawBG
    lda #$00
    sta do_draw
.not_draw:

    lda do_dma
    beq .not_dma
    lda #$00
    sta $2003
    lda #HIGH(OAM)
    sta $4014
.not_dma:

    bit $20
    lda scroll_x
    sta $2005
    lda scroll_y
    sta $2005

    lda soft2000
    sta $2000
    lda soft2001
    sta $2001

    lda #$00
    sta wait_nmi

    rti

IRQ:

    rti

    .include "./src/LoadPalette.asm"
    .include "./src/DrawBG.asm"
    .include "./src/ReadPad.asm"
    .include "./src/Attack.asm"


    .bank 1
    .org $E000
RESET:
    sei         ; disanle IRQs
    cld         ; disable decimal mode
    ldx #$40
    stx $4017   ; disable APU frame IRQ(?)
    ldx #$FF
    txs         ; setup stack
    inx
    stx $2000   ; disable NMI
    stx $2001   ; disable rendering
    stx $4010   ; disable DMC IRQs(?)
    lda #$00
    sta $A000   ; nametable mirroring
    sta $4015   ; sound register iniitialize

VblankWait1:
    bit $2002
    bpl VblankWait1

ClearMemory:
    lda #$00
    sta $0000, x
    sta $0100, x
    sta $0300, x
    sta $0400, x
    sta $0500, x
    sta $0600, x
    sta $0700, x
    lda #$FE
    sta $0200, x    ; init sprite DMA space $FE
    inx
    bne ClearMemory

InitSprites:
    lda #$02
    sta $4014; sprite DMA

InitBank:
    ldx #0
.loop:
    lda initBankTable, x
    stx $8000   ; select bank
    sta $8001   ; select data
    inx
    cpx #8
    bne .loop

    jmp Main

initBankTable:
    .db $00,$02,$04,$05,$06,$07,$00,$00

palette:
    .incbin "src/res/palette.pal"

tile1:
    .incbin "src/res/field2.tile"
attr1:
    .incbin "src/res/field.attr"

; vectors
    .org $FFFA
    .dw NMI
    .dw RESET
    .dw IRQ


; Character datas
    .bank 2
    .org $0000
    .incbin "./src/res/chr.chr"
