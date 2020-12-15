    ; tmp * 8
    lda tmp+5
    sta tmp+1
    lda tmp+6
    sta tmp+2
    
    lda tmp
    sta tmp+3
    lda #$00
    sta tmp+4

    asl tmp+3
    rol tmp+4
    asl tmp+3
    rol tmp+4
    asl tmp+3
    rol tmp+4
    lda tmp+1
    clc
    adc tmp+3
    sta tmp+1
    lda tmp+2
    adc tmp+4
    sta tmp+2
