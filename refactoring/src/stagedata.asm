    .db $00, $00 ; llllbbbb, tttt???? l:ページ数 b:基本背景 t:タイル
    .db $00, $00 ; xxxxyyyy, pnnnnnnn x:x位置(0-F) y:y位置(0-D) p:改ページ n:種類
    .db $FF ; 終了


stageList:
    .dw $0000, stage1, stage2

stage1:
    .db $02 ; エリア数
    .db $01 ; 基本タイル
    .dw .area1, .area2
.area1:
    .db $03 ; ページ数
    .db $12, $12, $12 ; 各ページのオブジェクト数

    .db $02, $70 ; 種類(8), y位置(4)：x位置(4) 優先順位が小さいものから．
    .db $03, $71
    .db $02, $72
    .db $03, $73
    .db $02, $74
    .db $02, $75
    .db $02, $76
    .db $02, $77
    .db $03, $60
    .db $02, $61
    .db $02, $62
    .db $02, $63
    .db $02, $64
    .db $02, $65
    .db $02, $66
    .db $02, $67
    .db $02, $7F
    .db $02, $6F

    .db $03, $D0
    .db $03, $C1
    .db $03, $B2
    .db $03, $A3
    .db $03, $94
    .db $03, $85
    .db $03, $76
    .db $03, $67
    .db $03, $58
    .db $03, $49
    .db $03, $3A
    .db $03, $2B
    .db $03, $1C
    .db $03, $0D
    .db $03, $1E
    .db $03, $2E
    .db $03, $3F
    .db $03, $4F

    .db $04, $D0
    .db $04, $C1
    .db $04, $B2
    .db $04, $A3
    .db $04, $94
    .db $04, $85
    .db $04, $76
    .db $04, $67
    .db $04, $58
    .db $04, $49
    .db $04, $3A
    .db $04, $2B
    .db $04, $1C
    .db $04, $0D
    .db $04, $1E
    .db $04, $2E
    .db $04, $3F
    .db $04, $4F
.area2:
    .db $02 ; ページ数
    .db $06, $04 ; 各ページのオブジェクト数

    .db $02, $00 ; 種類(8), y位置(4)：x位置(4) 優先順位が小さいものから．
    .db $02, $11
    .db $02, $22
    .db $02, $33
    .db $02, $44
    .db $02, $55

    .db $02, $00
    .db $02, $22
    .db $02, $44
    .db $02, $88

stage2:
    .db $02 ; エリア数
    .db $01 ; 基本タイル
    .dw .area1, .area2
.area1
    .db $02 ; ページ数
    .db $06, $04 ; 各ページのオブジェクト数

    .db $02, $00 ; 種類(8), y位置(4)：x位置(4) 優先順位が小さいものから．
    .db $02, $11
    .db $02, $22
    .db $02, $33
    .db $02, $44
    .db $02, $55

    .db $02, $00
    .db $02, $22
    .db $02, $44
    .db $02, $88
.area2
    .db $02 ; ページ数
    .db $06, $04 ; 各ページのオブジェクト数

    .db $02, $00 ; 種類(8), y位置(4)：x位置(4) 優先順位が小さいものから．
    .db $02, $11
    .db $02, $22
    .db $02, $33
    .db $02, $44
    .db $02, $55

    .db $02, $00
    .db $02, $22
    .db $02, $44
    .db $02, $88

baseTile:
    .db $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
    .db $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$01,$01
    .db $01,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02,$02,$02,$02
    .db $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
    .db $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04

objectTileData:
    ; ブロック
    .db $00,$00,$00,$00
    .db $01,$01,$01,$01
    .db $60,$61,$62,$63
    .db $64,$65,$66,$67
    .db $68,$69,$6A,$6B
    .db $00,$00,$00,$00
    .db $00,$00,$00,$00
    .db $00,$00,$00,$00
    .db $00,$00,$00,$00
    .db $00,$00,$00,$00
    .db $00,$00,$00,$00
    .db $00,$00,$00,$00
    .db $00,$00,$00,$00
    .db $00,$00,$00,$00
    .db $00,$00,$00,$00
    .db $00,$00,$00,$00
    ; 背景
    .db $00,$00,$00,$00

objectAttributeData:
    .db 0,1,2,3,1,2,3,0