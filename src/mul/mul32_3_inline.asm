    ; tile + (limit_high / 8 * 32)
    lda attr_addr
    and #$F8
    sta attr_addr

    asl attr_addr
    rol attr_addr+1
    asl attr_addr
    rol attr_addr+1