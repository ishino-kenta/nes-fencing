    ; tile + (limit_high / 8 * 28)
    lsr attr_addr+1
    ror attr_addr

    lda attr_addr
    and #$FC
    sta attr_addr
    sta tmp
    lda attr_addr+1
    sta tmp+1

    asl tmp
    rol tmp+1
    lda attr_addr
    clc
    adc tmp
    sta attr_addr
    lda attr_addr+1
    adc tmp+1
    sta attr_addr+1

    asl tmp
    rol tmp+1
    lda attr_addr
    clc
    adc tmp
    sta attr_addr
    lda attr_addr+1
    adc tmp+1
    sta attr_addr+1