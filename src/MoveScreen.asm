CAMERA_MOVEMENT_RIGHT_LOW = $04
CAMERA_MOVEMENT_RIGHT_HIGH = $00
CAMERA_MOVEMENT_LEFT_LOW = $FC
CAMERA_MOVEMENT_LEFT_HIGH = $FF

MoveScreen:
    lda scroll_x
    sta scroll_x_pre
    lda scroll_x+1
    sta scroll_x_pre+1
    ; compule screen scrolling from player position
    lda player_lead
    cmp #VACANT
    bne .i
    lda scroll_x_pre
    sta tmp
    lda scroll_x_pre+1
    sta tmp+1
    jmp .j
.i:
    lda player_lead
    cmp #PLAYER2
    bne .k
    lda player1_dead
    beq .k
    lda player2_x
    sta tmp
    lda player2_x+1
    sta tmp+1
    lda tmp
    sec
    sbc #$D8
    sta tmp
    lda tmp+1
    sbc #$00
    sta tmp+1
    jmp .j
.k:
    lda player_lead
    cmp #PLAYER1
    bne .l
    lda player2_dead
    beq .l
    lda player1_x
    sta tmp
    lda player1_x+1
    sta tmp+1
    lda tmp
    sec
    sbc #$18
    sta tmp
    lda tmp+1
    sbc #$00
    sta tmp+1
    jmp .j
.l:
    lda player1_x
    clc
    adc player2_x
    sta tmp
    lda player1_x+1
    adc player2_x+1
    sta tmp+1
    lda #$00
    adc #$00
    sta tmp+2
    lsr tmp+2
    ror tmp+1
    ror tmp
    lda tmp
    sec
    sbc #$78
    sta tmp
    lda tmp+1
    sbc #$00
    sta tmp+1
.j:

    ; boundry check
    lda scroll_x_pre+1
    cmp #$00
    bne .e
    lda tmp+1
    cmp #$FF
    bne .e
    lda #$00
    sta tmp
    sta tmp+1
.e:
    and #$01
    sta nt_base

    ; limit camera movement
    lda tmp
    sec
    sbc scroll_x_pre
    sta tmp
    lda tmp+1
    sbc scroll_x_pre+1
    sta tmp+1

    lda #CAMERA_MOVEMENT_RIGHT_HIGH
    cmp tmp+1
    bcc .a
    lda #CAMERA_MOVEMENT_RIGHT_LOW
    cmp tmp
    bcc .a
    ; x <= $0004
    jmp .d
.a:

    lda #$7F
    cmp tmp+1
    bcc .b
    lda #$FF
    cmp tmp
    bcc .b
    ; $0004 < x <= $7FFF
    lda #CAMERA_MOVEMENT_RIGHT_LOW
    sta tmp
    lda #CAMERA_MOVEMENT_RIGHT_HIGH
    sta tmp+1
    jmp .d
.b:

    lda #CAMERA_MOVEMENT_LEFT_HIGH
    cmp tmp+1
    bcc .c
    lda #CAMERA_MOVEMENT_LEFT_LOW
    cmp tmp
    bcc .c
    ; $7FFF < x <= $FFFC
    lda #CAMERA_MOVEMENT_LEFT_LOW
    sta tmp
    lda #CAMERA_MOVEMENT_LEFT_HIGH
    sta tmp+1
    jmp .d
.c:
    ; $FFFC < x
.d:
    
    lda scroll_x_pre
    clc
    adc tmp
    sta scroll_x
    lda scroll_x_pre+1
    adc tmp+1
    sta scroll_x+1

    ; compule screen scrolling direction
    lda scroll_x+1
    cmp scroll_x_pre+1
    beq .1
    bcc .left
    jmp .right
.1:
    lda scroll_x
    cmp scroll_x_pre
    bcc .left
    jmp .right
.left:
    lda #DIRECTION_LEFT
    jmp .end
.right:
    lda #DIRECTION_RIGHT
.end:
    sta direction_scroll

    rts