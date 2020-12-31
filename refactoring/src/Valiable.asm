
VARIABLE_PLAYER1 = $0004
VARIABLE_PLAYER2 = VARIABLE_PLAYER1 + $0C

PAD                 = $00
PAD_PRE             = $01
PLAYER_X            = $02
PLAYER_Y            = $04
PLAYER_FALL_INDEX   = $05
PLAYER_DIRECTION    = $06
PLAYER_SPEED_INDEX  = $07
PLAYER_CROUCH       = $08
PLAYER_JUMP_SPEED   = $09
PLAYER_STAB_INDEX   = $0A
PLAYER_POSTURE   = $0B

    .rsset $0000

test    .rs 4

; player1
pad1    .rs 1
pad1_pre    .rs 1
player1_x   .rs 2
player1_y   .rs 1
player1_fall_index  .rs 1
player1_direction   .rs 1
player1_speed_index .rs 1
player1_crouch .rs 1
player1_jump_speed  .rs 1
player1_stab_index  .rs 1
player1_posture  .rs 1

; player2
pad2    .rs 1
pad2_pre    .rs 1
player2_x   .rs 2
player2_y   .rs 1
player2_fall_index  .rs 1
player2_direction   .rs 1
player2_speed_index .rs 1
player2_crouch .rs 1
player2_jump_speed  .rs 1
player2_stab_index  .rs 1
player2_posture  .rs 1

variable_addr   .rs 2

source_addr .rs 2

do_draw .rs 1
do_dma  .rs 1
wait_nmi    .rs 1

draw_buff_counter .rs 1
oam_counter .rs 1

stage   .rs 1
scene   .rs 2

soft2000    .rs 1
soft2001    .rs 1

fill_draw_cul   .rs 4
fill_draw_buff   .rs 2
fill_draw_nametable   .rs 2
fill_draw_counter   .rs 1
fill_draw_raw   .rs 1


fill_tile_cul .rs 2
fill_tile_buff    .rs 2
area_page    .rs 1 ; エリア数-1であることに注意
page_x  .rs 1
area_command .rs 2
nrof_object .rs 1
area_offset .rs 1
object  .rs 1

stage_length    .rs 1
stage_base  .rs 1
stage_pointer  .rs 2
area_pointer    .rs 2

camera_tmp   .rs 1
camera_x    .rs 2
camera_x_pre    .rs 2

stage_counter   .rs 2

tmp_drawbg .rs 5



sprite_tmp  .rs 1
sprite_x    .rs 3
sprite_y    .rs 1
sprite_tile    .rs 2
sprite_attr  .rs 1
sprite_player  .rs 1

collisiondetection_x    .rs 3
collisiondetection_y    .rs 1
collisiondetection_direction    .rs 1
collisiondetection_end   .rs 1
collisiondetection_addr .rs 2

clock   .rs 1