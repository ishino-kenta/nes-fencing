; ines header
    .inesprg 4  ; 1x 16KB PRG code
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
test .rs 10
tmp .rs 7
source_addr .rs 4

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
direction_scroll_pre    .rs 1
nt_base .rs 1
scroll_y    .rs 2

player1_x   .rs 2
player1_x_pre   .rs 2
player1_screen_x    .rs 1
player2_x   .rs 2
player2_x_pre   .rs 2
player2_screen_x    .rs 1

player1_y   .rs 1
player2_y   .rs 1

field_limit_low    .rs 2
field_limit_high    .rs 2

player1_sword_off   .rs 1
player2_sword_off   .rs 1

game_scene  .rs 2


     .bank 0
     .org $A000
tile3:
    .incbin "src/res/field4_24.tile"
tile3_attr:
    .incbin "src/res/field4_24.attr"

     .bank 1
     .org $A000
tile1:
    .incbin "src/res/field3_24.tile"
tile1_attr:
    .incbin "src/res/field3_24.attr"

    .bank 2
    .org $8000

    .bank 3
    .org $A000
title:
    .incbin "src/res/title.tile"
title_attr:
    .incbin "src/res/title.attr"
stage:
    .incbin "src/res/stage.tile"
stage_attr:
    .incbin "src/res/stage.attr"
win:
    .incbin "src/res/win.tile"

    .bank 4
    .org $8000

    .bank 5
    .org $A000

    .bank 6
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

    jsr InitSceneTitle

    lda #LOW(title)
    sta source_addr
    lda #HIGH(title)
    sta source_addr+1
    lda #LOW(title_attr)
    sta source_addr+2
    lda #HIGH(title_attr)
    sta source_addr+3
    jsr ReloadBG

.vw3:
    bit $2002
    bpl .vw3

    ; horizontal mirroring
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

    lda #$00
    sta ppu_counter
    sta oam_counter

    jsr ReadPad1
    jsr ReadPad2

    jmp [game_scene]

SceneBattle:

    jsr DecDead

    lda player1_dead
    bne .1
    jsr MovePlayer1
    jsr PlayerBoundaryCheck1
    jsr ChangeSwordHeight1
    jsr Attack1
    jsr Jump1
    jsr Fall1
    jsr ComputePlayerTop
    jsr Sandbox
    lda #CHECK_BOTTOM
    sta tmp+6
    lda #PLAYER1
    jsr CheckHit
    lda #CHECK_TOP
    sta tmp+6
    lda #PLAYER1
    jsr CheckHit
    jsr Crouch1
.1:

    lda player2_dead
    bne .2
    jsr MovePlayer2
    jsr PlayerBoundaryCheck2
    jsr ChangeSwordHeight2
    jsr Attack2
    jsr Jump2
    jsr Fall2
    jsr ComputePlayerTop
    lda #CHECK_BOTTOM
    sta tmp+6
    lda #PLAYER2
    jsr CheckHit
    lda #CHECK_TOP
    sta tmp+6
    lda #PLAYER2
    jsr CheckHit
    jsr Crouch2
.2:

    jsr ComputeSwordY
    jsr ComputePlayerTop

    lda player1_dead
    ora player2_dead
    bne .3
    jsr ComputeTip
    lda player1_crouch
    cmp #CROUCH
    beq .off
    lda player1_fall_index
    bne .off
    lda player1_speed_index
    cmp #RUN
    bcs .off
    lda player2_crouch
    cmp #CROUCH
    beq .off
    lda player2_fall_index
    bne .off
    lda player2_speed_index
    cmp #RUN
    bcs .off
    jsr SwordCollision
    jsr PlayerBoundaryCheck1
    jsr PlayerBoundaryCheck2
.off:
    
    jsr CheckHitAttack
.3:

    jsr DissappearPlayer

    jsr MoveScreen
    jsr SetPlayerPosition
    jsr SetPlayer

    ; switch base nametable
    lda soft2000
    and #$FE
    ora nt_base
    sta soft2000

    inline SetBG

    jsr ChangeField
    jsr PlayerWin

    jsr Sandbox

    jmp MainLoop




SceneTitle:

    lda pad1
    eor pad1_pre
    and pad1
    and #PAD_START
    beq .1

    jsr InitSceneStage

    lda #LOW(SceneStage)
    sta game_scene
    lda #HIGH(SceneStage)
    sta game_scene+1

    lda soft2000
    and #$7F
    sta soft2000
    sta $2000
    lda soft2001
    and #$E7
    sta soft2001
    sta $2001

    lda #LOW(stage)
    sta source_addr
    lda #HIGH(stage)
    sta source_addr+1
    lda #LOW(stage_attr)
    sta source_addr+2
    lda #HIGH(stage_attr)
    sta source_addr+3
    jsr ReloadBG

    lda soft2000
    ora #$80
    sta soft2000
    sta $2000
    lda soft2001
    ora #$18
    sta soft2001

.1:

    jmp MainLoop




SceneStage:

    jsr SelectStage

    jsr SetCursor

    jmp MainLoop




SceneResult:

    jsr SetPlayer

    lda player_lead
    cmp #PLAYER1
    bne .not1
    inc player1_screen_x
    inc player1_screen_x
    inc player1_screen_x
.not1:
    lda player_lead
    cmp #PLAYER2
    bne .not2
    dec player2_screen_x
    dec player2_screen_x
    dec player2_screen_x
.not2:

    lda pad1
    eor pad1_pre
    and pad1
    and #PAD_START
    beq .1

    jsr InitSceneStage

    lda soft2000
    and #$7F
    sta soft2000
    sta $2000
    lda soft2001
    and #$E7
    sta soft2001
    sta $2001

    lda #LOW(stage)
    sta source_addr
    lda #HIGH(stage)
    sta source_addr+1
    lda #LOW(stage_attr)
    sta source_addr+2
    lda #HIGH(stage_attr)
    sta source_addr+3
    jsr ReloadBG

    ldx #$00
.l:
    lda #$00
    sta OAM, x
    inx
    cpx #$28
    bne .l

    lda soft2000
    ora #$80
    sta soft2000
    sta $2000
    lda soft2001
    ora #$18
    sta soft2001

    lda #LOW(SceneStage)
    sta game_scene
    lda #HIGH(SceneStage)
    sta game_scene+1

.1:

    jmp MainLoop



    .include "./src/NMI.asm"    
    .include "./src/IRQ.asm"


    .include "./src/DeadPlayer.asm"
    .include "./src/MovePlayer.asm"
    .include "./src/ChangeSwordHeight.asm"
    .include "./src/MoveScreen.asm"
    .include "./src/Sandbox.asm"
    .include "./src/Fall.asm"
    .include "./src/Jump.asm"
    .include "./src/Crouch.asm"
    .include "./src/ComputeSwordY.asm"
    .include "./src/ComputePlayerTop.asm"
    .include "./src/ReloadBG.asm"
    .include "./src/ChangeField.asm"
    .include "./src/InitSceneBattle.asm"
    .include "./src/InitSceneStage.asm"
    .include "./src/InitSceneTitle.asm"
    .include "./src/SelectStage.asm"
    .include "./src/SetCursor.asm"
    .include "./src/SetPlayerPosition.asm"
    .include "./src/PlayerWin.asm"
;    .include "./src/WallHit.asm"


    .bank 7
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

.vw:
    bit $2002
    bpl .vw

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
    .db $00,$02,$04,$05,$06,$07,$00,$01

palette:
    .incbin "src/res/palette.pal"

    .include "./src/LoadPalette.asm"
    .include "./src/DrawBG.asm"
    .include "./src/ReadPad.asm"
    .include "./src/Attack.asm"
    .include "./src/SetPlayer.asm"
    .include "./src/SwordCollision.asm"
    .include "./src/ComputeTip.asm"
    .include "./src/CheckHitAttack.asm"
    .include "./src/PlayerBoundaryCheck.asm"
    .include "./src/CheckHit.asm"


; vectors
    .org $FFFA
    .dw NMI
    .dw RESET
    .dw IRQ


; Character datas
    .bank 8
    .org $0000
    .incbin "./src/res/chr.chr"
