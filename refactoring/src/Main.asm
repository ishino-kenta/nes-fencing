    ; inesヘッダー
    .inesprg 1  ; 16KB PRG code
    .ineschr 1  ; 8KB CHR data
    .inesmap 4
    .inesmir 0

    ; 定数
OAM = $0200
DRAW_BUFF = $0300

    ; 変数
    .include "./valiable.asm"

    .bank 0
    .org $C000

Main:

.Vw1:
    bit $2002
    bpl .Vw1

    lda #LOW(palette)
    sta source_addr
    lda #HIGH(palette)
    sta source_addr+1
    jsr LoadPalette

.Vw3:
    bit $2002
    bpl .Vw3

    jsr SetTitle

    lda #$00
    sta $A000 ; 垂直ミラーリング

    lda #%10010000  ; NMIオン
    sta soft2000
    sta $2000
    lda #%00011110  ; spr/BGオン
    sta soft2001
    sta $2001

    lda #$00
    sta camera_x
    sta camera_x+1

    lda #$01
    sta stage

    lda #LOW(SceneTitle)
    sta scene
    lda #HIGH(SceneTitle)
    sta scene+1

MainLoop:

    lda #$01
    sta do_draw
    sta do_dma

WatiNMI:
    inc wait_nmi
.Loop:
    lda wait_nmi
    bne .Loop

    lda #$00
    sta draw_buff_counter
    sta oam_counter
    ldx #$00
    sta DRAW_BUFF, x

    jsr ReadPad1
    jsr ReadPad2

    jmp [scene]

    ; シーン
    .include "./SceneBattle.asm"
    .include "./SceneTitle.asm"
    .include "./SceneStageSelect.asm"

    ; サブルーチン
    .include "./subroutine/LoadPalette.asm"
    .include "./subroutine/ReadPad.asm"
    .include "./subroutine/DrawBG.asm"
    .include "./SetStage.asm"
    .include "./FillTileBuff.asm"
    .include "./DrawTileBuff.asm"
    .include "./SetArea.asm"
    .include "./SetTitle.asm"
    .include "./DrawPlayer.asm"
    .include "./SetCamera.asm"
    .include "./Fall.asm"
    .include "./Move.asm"
    .include "./DrawCameraEdge.asm"
    .include "./CollisionDetection.asm"
    .include "./SetPlayerDirection.asm"
    .include "./Crouch.asm"
    .include "./Jump.asm"
    .include "./Stab.asm"


    .bank 1
    .org $E000

    ; RESET NMI IRQ
    .include "./NMI.asm"
    .include "./IRQ.asm"
    .include "./RESET.asm"

palette:
    .incbin "./res/palette.pal"

    ; Vectors
    .org $FFFA
    .dw NMI
    .dw RESET
    .dw IRQ

    ; Character datas
    .bank 2
    .org $0000
    .incbin "./res/chr.chr"
