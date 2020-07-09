SetSprite:
    ; set sprite data
    ; player1
    ldx oam_counter
    lda #$8F
    sta OAM, x
    inx
    lda #$01
    sta OAM, x
    inx
    lda #$00
    sta OAM, x
    inx
    lda player1_screen_x
    sta OAM, x
    inx

    lda #$97
    sta OAM, x
    inx
    lda #$02
    sta OAM, x
    inx
    lda #$00
    sta OAM, x
    inx
    lda player1_screen_x
    sta OAM, x
    inx

    lda #$9F
    sta OAM, x
    inx
    lda #$03
    sta OAM, x
    inx
    lda #$00
    sta OAM, x
    inx
    lda player1_screen_x
    sta OAM, x
    inx

    ; sword
    lda #$8F
    clc
    adc player1_sword_height
    sta OAM, x
    inx
    lda #$04
    sta OAM, x
    inx
    lda #$00
    sta OAM, x
    inx
    lda player1_screen_x
    clc
    adc #$08
    ldy player1_atttack_counter
    clc
    adc attackTable, y
    sta OAM, x
    inx

    lda #$8F
    clc
    adc player1_sword_height
    sta OAM, x
    inx
    lda #$05
    sta OAM, x
    inx
    lda #$00
    sta OAM, x
    inx
    lda player1_screen_x
    clc
    adc #$10
    ldy player1_atttack_counter
    clc
    adc attackTable, y
    sta OAM, x
    inx
    
    lda #$8F
    clc
    adc player1_sword_height
    sta OAM, x
    inx
    lda #$05
    sta OAM, x
    inx
    lda #$00
    sta OAM, x
    inx
    lda player1_screen_x
    clc
    adc #$18
    ldy player1_atttack_counter
    clc
    adc attackTable, y
    sta OAM, x
    inx

    ; player2
    lda #$8F
    sta OAM, x
    inx
    lda #$01
    sta OAM, x
    inx
    lda #$01
    sta OAM, x
    inx
    lda player2_screen_x
    sta OAM, x
    inx
    lda #$97
    sta OAM, x
    inx
    lda #$02
    sta OAM, x
    inx
    lda #$01
    sta OAM, x
    inx
    lda player2_screen_x
    sta OAM, x
    inx
    lda #$9F
    sta OAM, x
    inx
    lda #$03
    sta OAM, x
    inx
    lda #$01
    sta OAM, x
    inx
    lda player2_screen_x
    sta OAM, x
    inx
    ; sword
    lda #$8F
    clc
    adc player2_sword_height
    sta OAM, x
    inx
    lda #$04
    sta OAM, x
    inx
    lda #$01+$40
    sta OAM, x
    inx
    lda player2_screen_x
    sec
    sbc #$08
    ldy player2_atttack_counter
    sec
    sbc attackTable, y
    sta OAM, x
    inx

    lda #$8F
    clc
    adc player2_sword_height
    sta OAM, x
    inx
    lda #$05
    sta OAM, x
    inx
    lda #$01+$40
    sta OAM, x
    inx
    lda player2_screen_x
    sec
    sbc #$10
    ldy player2_atttack_counter
    sec
    sbc attackTable, y
    sta OAM, x
    inx
    
    lda #$8F
    clc
    adc player2_sword_height
    sta OAM, x
    inx
    lda #$05
    sta OAM, x
    inx
    lda #$01+$40
    sta OAM, x
    inx
    lda player2_screen_x
    sec
    sbc #$18
    ldy player2_atttack_counter
    sec
    sbc attackTable, y
    sta OAM, x
    inx



    stx oam_counter
