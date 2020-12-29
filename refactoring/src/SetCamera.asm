SetCamera:

    lda camera_x
    sta camera_x_pre
    lda camera_x+1
    sta camera_x_pre+1   

    lda #$00
    sta camera_x
    sta camera_x+1

    ; カメラによってメインスクリーン変更
    lda camera_x+1
    and #$01
    sta camera_tmp
    lda soft2000
    and #$FC
    ora camera_tmp
    sta soft2000

    rts