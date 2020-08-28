InitSceneTitle:

    lda #$08
    sta scroll_x
    lda #$00
    sta scroll_x+1

    lda #LOW(SceneTitle)
    sta game_scene
    lda #HIGH(SceneTitle)
    sta game_scene+1

    lda #$07
    sta $8000
    lda #$03
    sta $8001

    rts