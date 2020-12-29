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
; stage_length
;  ステージの長さを保持．
; stage_base
;  ステージの初期ベースに変更．

TILE_BUFF = $0500


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
    sta stage_length
    iny
    lda [stage_pointer], y
    sta stage_base
    iny

    ; エリア1にセット
    lda [stage_pointer], y
    sta area_pointer
    iny
    lda [stage_pointer], y
    sta area_pointer+1

    jsr SetArea

    rts

    .include "./stagedata.asm"