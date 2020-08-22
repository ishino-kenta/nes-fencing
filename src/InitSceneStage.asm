InitSceneStage:

    lda #$07
    sta $8000
    lda #$03
    sta $8001

    lda #$08
    sta scroll_x
    lda #$01
    sta scroll_x+1
    

    rts