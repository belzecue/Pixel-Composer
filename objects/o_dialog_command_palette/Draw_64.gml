/// @description init

draw_sprite_stretched(THEME.textbox, 3, dialog_x, dialog_y, dialog_w, dialog_h);

tb_search.setFocusHover(sHOVER, sFOCUS);
tb_search.draw(dialog_x + ui(32), dialog_y, dialog_w - ui(32), ui(32), search_string);
tb_search.sprite_index = 0;

draw_sprite_ext(THEME.search, 0, dialog_x + ui(20), dialog_y + ui(16), 1, 1, 0, COLORS._main_icon, 1);

sc_content.setFocusHover(sFOCUS, sHOVER);
sc_content.draw(dialog_x, dialog_y + ui(32));

draw_set_color(CDEF.main_dkgrey);
draw_line(dialog_x, dialog_y + ui(32), dialog_x + dialog_w - 1, dialog_y + ui(32));

draw_sprite_stretched(THEME.textbox, 1, dialog_x, dialog_y, dialog_w, dialog_h);