NUMBER_OF_ATTR = $08
    ; scroll_x / 32 * 8
    ; right
    lsr tmp+1
    ror tmp
    lsr tmp+1
    ror tmp
    lsr tmp+1
    ror tmp
    lsr tmp+1
    ror tmp
    lsr tmp+1
    ror tmp

    asl tmp
    rol tmp+1
    asl tmp
    rol tmp+1
    asl tmp
    rol tmp+1

    lda tmp
    clc
    adc attr_addr
    sta tmp
    lda tmp+1
    adc attr_addr+1
    sta tmp+1

    ; left
    lsr tmp+3
    ror tmp+2
    lsr tmp+3
    ror tmp+2
    lsr tmp+3
    ror tmp+2
    lsr tmp+3
    ror tmp+2
    lsr tmp+3
    ror tmp+2

    asl tmp+2
    rol tmp+3
    asl tmp+2
    rol tmp+3
    asl tmp+2
    rol tmp+3

    lda tmp+2
    clc
    adc attr_addr
    sta tmp+2
    lda tmp+3
    adc attr_addr+1
    sta tmp+3
