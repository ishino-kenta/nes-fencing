stageTable:
    .dw stage1Table,stage2Table

stage1Table:
    ; the number of field, field 0, field 1, ...
    .db $03, $00,$01,$00
stage2Table:
    .db $05, $00,$01,$01,$01,$00

filedLimitTable:
    ; field_limit_low+1, field_limit_low, field_limit_high+1, field_limit_high
    .db $00,$00,$02,$00 ; field 0
    .db $00,$00,$08,$E0 ; field 1