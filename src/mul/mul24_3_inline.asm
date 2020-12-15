    ; tile + (limit_high / 8 * 24)
    lda attr_addr
    and #$F8
    sta tmp
    lda attr_addr+1
    sta tmp+1

    asl attr_addr
    rol attr_addr+1
    lda attr_addr
    clc
    adc tmp
    sta attr_addr
    lda attr_addr+1
    adc tmp+1
    sta attr_addr+1