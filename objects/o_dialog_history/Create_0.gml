/// @description init
event_inherited();

#region data
	dialog_w = ui(400);
	dialog_h = ui(480);
	
	destroy_on_click_out = true;
	
	anchor = ANCHOR.left | ANCHOR.top;
	hold = false;
	
	dialog_resizable = true;
	dialog_w_min = 320;
	dialog_h_min = 320;
	hovering = -1;
	
	redo_list = ds_list_create();
	undo_list = ds_list_create();
	click_hold = noone;
	
	function refreshList() {
		ds_list_clear(redo_list);
		ds_list_clear(undo_list);
		
		while(!ds_stack_empty(REDO_STACK))
			ds_list_insert(redo_list, 0, ds_stack_pop(REDO_STACK));
	
		for( var i = 0; i < ds_list_size(redo_list); i++ )
			ds_stack_push(REDO_STACK, redo_list[| i]);
	
		while(!ds_stack_empty(UNDO_STACK))
			ds_list_add(undo_list, ds_stack_pop(UNDO_STACK));
	
		for( var i = ds_list_size(undo_list) - 1; i >= 0; i-- )
			ds_stack_push(UNDO_STACK, undo_list[| i]);
		
	}
	refreshList();
#endregion

#region content
	onResize = function() {
		sc_history.resize(dialog_w - ui(padding + padding), dialog_h - ui(title_height + padding));
	}
	
	sc_history = new scrollPane(dialog_w - ui(padding + padding), dialog_h - ui(title_height + padding), function(_y, _m) {
		draw_clear_alpha(COLORS._main_text, 0);
		
		if((ds_list_size(redo_list) != ds_stack_size(REDO_STACK)) || (ds_list_size(undo_list) != ds_stack_size(UNDO_STACK)))
			refreshList();
		
		draw_set_text(f_p1, fa_left, fa_center, COLORS._main_text);
		
		var lh = line_height() + ui(8);
		var _h = 0, hh;
		var yy = _y + ui(8);
		
		var lw = sc_history.surface_w - ui(32 + 2);
		var red = ds_list_size(redo_list);
		var amo = ds_list_size(redo_list) + ds_list_size(undo_list) + 1;
		var _hover = -1;
		var connect_line_st = 0;
		var connect_line_ed = 0;
		var action = -1;
		
		for( var i = 0; i < amo; i++ ) {
			if(i == red) {
				draw_sprite_stretched_ext(THEME.ui_scrollbar, 0, 0, yy, sc_history.surface_w, ui(4), COLORS._main_accent, 1);
				connect_line_st = yy + ui(2);
				
				_h += ui(4 + 8);
				yy += ui(4 + 8);
				continue;
			}
			
			var item;
			if(i < red)	item = redo_list[| i];
			else		item = undo_list[| i - red - 1];
			
			var itamo = array_length(item);
			var amoDisp = itamo;
			if(itamo > 3) {
				itamo = 3;
				amoDisp = 4;
			}
			hh = amoDisp * lh;
			
			BLEND_OVERRIDE;
			if(sHOVER && sc_history.hover && point_in_rectangle(_m[0], _m[1], ui(32), yy - ui(4), lw, yy + hh + ui(4) - 1)) {
				draw_sprite_stretched_ext(THEME.node_bg, 0, ui(32), yy - ui(2), lw, hh + ui(4), COLORS._main_icon_light, 1);
				_hover = i;
				
				if(array_length(item) > itamo) {
					TOOLTIP = "";
					for( var j = 0; j < array_length(item); j++ ) 
						TOOLTIP += (j? "\n" : "") + item[j].toString();
				}
				
				if(mouse_click(mb_left) && click_hold != item) {
					click_hold = item;
					action = i;
				}
			} else 
				draw_sprite_stretched_ext(THEME.node_bg, 0, ui(32), yy - ui(2), lw, hh + ui(4), COLORS._main_icon, 1);
			
			var cc = COLORS._main_icon_dark;
			var _yc = yy;
			
			if(i == hovering) cc = COLORS._main_accent;
			if(i < red)	_yc = yy + ui(6);
			else		_yc = yy + hh;
			
			draw_sprite_ui(THEME.arrow, i < red? 3 : 1, ui(16), _yc, 1.5, 1.5, 0, cc, 1);
			BLEND_NORMAL;
			
			if(i == hovering)
				connect_line_ed = _yc;
			
			for( var j = 0; j < amoDisp; j++ ) {
				var _ty = yy + lh * (j + 0.5);
				if(j == 3) {
					draw_set_color(COLORS._main_text_sub);
					draw_text_add(ui(32 + 12), _ty, string(array_length(item) - 3) + " more actions...");
				} else {
					draw_set_color(COLORS._main_text);
					draw_text_add(ui(32 + 12), _ty, item[j].toString());
				}
			}
			
			_h += hh + ui(8);
			yy += hh + ui(8);
		}
		
		if(hovering > -1) {
			draw_set_color(COLORS._main_accent);
			draw_line_width(ui(16), connect_line_st, ui(16), connect_line_ed, ui(3));
		}
		
		if(mouse_release(mb_left)) 
			click_hold = noone;
		hovering = _hover;
		
		if(action > -1) {
			if(action < red) {
				repeat(red - action) 
					REDO();
			} else {
				repeat(action - red) 
					UNDO();
			}
			hovering = -1;
		}
		
		return _h;
	})
#endregion