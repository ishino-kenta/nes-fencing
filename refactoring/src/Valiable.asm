test    .rs 10

source_addr .rs 2

do_draw .rs 1
do_dma  .rs 1
wait_nmi    .rs 1

ppu_counter .rs 1
oam_counter .rs 1

scene   .rs 2

soft2000    .rs 1
soft2001    .rs 1

fill_draw_cul   .rs 2
fill_draw_buff   .rs 2
fill_draw_raw_buff   .rs 2
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

title_tmp   .rs 1


stage_length    .rs 1
stage_base  .rs 1
stage_pointer  .rs 2
area_pointer    .rs 2

camera_x    .rs 2

stage_counter   .rs 2

tmp_drawbg .rs 5

pad1    .rs 1
pad1_pre    .rs 1  
pad2    .rs 1
pad2_pre    .rs 1  