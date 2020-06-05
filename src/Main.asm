; ines header
    .inesprg 1  ; 1x 16KB PRG code
    .ineschr 1  ; 1x  8KB CHR data
    .inesmap 4 
    .inesmir 1

; Declare some constants here

; Declare variables 
    .rsset $0000


    .bank 0
    .org $C000 
Main:

.vw1:
    bit $2002
    bpl .vw1

    .include "./src/LoadPalettes.asm"

.vw2:
    bit $2002
    bpl .vw2


Forever:
    jmp Forever

NMI:
    rti

IRQ:

    rti

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

; vectors
    .org $FFFA
    .dw NMI
    .dw RESET
    .dw IRQ

; Character datas

    .bank 2
    .org $0000
    .incbin "./src/graphic/palette.spal"
    .incbin "./src/graphic/palette.bpal"
