;--------------------------------------------------
; ステージのデータをロードする．
; 入力
; ステージ番号
;
; 出力
; stage_pointer
;  選んだステージに移動させる．
; area_pointer
;  エリア1に移動させる．
; nrof_area
;  ステージの長さを保持．
; stage_base
;  ステージの初期ベースに変更．

TILE_BUFF = $0400

area_num    .rs 1

SetStage:

    ; ステージのロード
    lda stage ; ステージ選択 後で入力に

    asl a
    tax
    lda stageList, x
    sta stage_pointer
    inx
    lda stageList, x
    sta stage_pointer+1

    ; ステージデータのロード
    ldy #$00
    lda [stage_pointer], y
    sta nrof_area
    iny
    lda [stage_pointer], y
    sta stage_base
    iny

    ; エリア1にセット
    lda #$00
    sta area_num

    jsr SetArea
    lda #$00
    sta draw_area_x
    jsr DrawArea

    rts

    .include "./stagedata.asm"