function Panel_Preview(_panel) : PanelContent(_panel) constructor {
	context_str = "Preview";
	
	last_focus = noone;
	
	canvas_x = w / 2 - 64;
	canvas_y = h / 2 - 64;
	canvas_s = 1;
	canvas_w = 128;
	canvas_h = 128;
	
	canvas_bg = -1;
	
	do_fullView = false;
	
	canvas_hover = true;
	canvas_dragging = false;
	canvas_drag_mx  = 0;
	canvas_drag_my  = 0;
	canvas_drag_sx  = 0;
	canvas_drag_sy  = 0;
	
	preview_node	= [ noone, noone ];
	preview_channel = [ 0, 0 ];
	preview_surface = [ 0, 0 ];
	
	preview_x		= 0;
	preview_x_to	= 0;
	preview_x_max	= 0;
	preview_sequence  = [ 0, 0 ];
	_preview_sequence = preview_sequence;
	preview_rate     = 10;
	
	grid_show	= false;
	grid_width	= 16;
	grid_height	= 16;
	
	tool_index		= -1;
	tool_sub_index	= 0;
	
	right_menu_y = 8;
	mouse_on_preview = false;
	
	resetViewOnDoubleClick = true;
	
	splitView = 0;
	splitPosition = 0.5;
	splitSelection = 0;
	
	splitViewDragging = false;
	splitViewStart = 0;
	splitViewMouse = 0;
	
	toolbar_height = 40;
	toolbars = [
		[ 
			s_icon_reset_when_preview,
			function() { return resetViewOnDoubleClick;  },
			function() { return resetViewOnDoubleClick? "Center canvas on preview" : "Keep canvas on preview" }, 
			function() { resetViewOnDoubleClick = !resetViewOnDoubleClick; } 
		],
		[ 
			s_icon_split_view,
			function() { return splitView;  },
			function() { 
				switch(splitView) {
					case 0 : return "Split view off";
					case 1 : return "Horizontal split view";
					case 2 : return "Vertical split view";
				}
				return "Split view";
			}, 
			function() { splitView = (splitView + 1) % 3; } 
		],
	];
	
	actions = [
		[ 
			s_icon_center_canvas,
			"Center canvas", 
			function() { fullView(); }
		],
	]
	
	tb_framerate = new textBox(TEXTBOX_INPUT.number, function(val) { preview_rate = real(val); })
	
	addHotkey("Preview", "Focus content",		"F", MOD_KEY.none,	function() { fullView(); });
	addHotkey("Preview", "Save current frame",	"S", MOD_KEY.shift,	function() { saveCurrentFrame(); });
	
	addHotkey("Preview", "Toggle grid",			"G", MOD_KEY.ctrl,	function() { grid_show = !grid_show; });
	
	function setNodePreview(node) {
		if(resetViewOnDoubleClick)
			do_fullView = true;
		
		preview_node[splitView? splitSelection : 0] = node;
	}
	
	function getNodePreview() { return preview_node[splitView? splitSelection : 0]; }
	function getNodePreviewSurface() { return preview_surface[splitView? splitSelection : 0]; }
	function getNodePreviewSequence() { return preview_sequence[splitView? splitSelection : 0]; }
	
	function getPreviewData() {
		preview_surface  = [ 0, 0 ];
		preview_sequence = [ 0, 0 ];
		
		for( var i = 0; i < 2; i++ ) {
			var node = preview_node[i];
			
			if(node == noone) continue;
			if(node.preview_channel >= ds_list_size(node.outputs)) continue;
			
			var _prev_val = node.outputs[| node.preview_channel];
			if(_prev_val.type != VALUE_TYPE.surface) return;
			
			var value = _prev_val.getValue();
			
			if(is_array(value))
				preview_sequence[i] = value;
			else
				preview_surface[i] = value;
		
			if(preview_sequence[i] != 0) {
				if(array_length(preview_sequence[i]) == 0) return;
				preview_surface[i] = preview_sequence[i][safe_mod(node.preview_index, array_length(preview_sequence[i]))];
			}
		}
		
		var prevS = getNodePreviewSurface();
		if(is_surface(prevS)) {
			canvas_w = surface_get_width(prevS);
			canvas_h = surface_get_height(prevS);	
		}
	}
	
	function dragCanvas() {
		if(canvas_dragging) {
			var dx = mx - canvas_drag_mx;
			var dy = my - canvas_drag_my;
			canvas_drag_mx = mx;
			canvas_drag_my = my;
			
			canvas_x += dx;
			canvas_y += dy;
			
			if(mouse_check_button_released(mb_middle)) 
				canvas_dragging = false;
		}
		
		if(FOCUS == panel && HOVER == panel && canvas_hover) {
			if(mouse_check_button_pressed(mb_middle)) {
				canvas_dragging = true;	
				canvas_drag_mx  = mx;
				canvas_drag_my  = my;
				canvas_drag_sx  = canvas_x;
				canvas_drag_sy  = canvas_y;
			}
			
			var _canvas_s = canvas_s;
			var inc = 0.5;
			if(canvas_s > 16)		inc = 2;
			else if(canvas_s > 8)	inc = 1;
			
			if(mouse_wheel_down()) canvas_s = max(round(canvas_s / inc) * inc - inc, 0.25);
			if(mouse_wheel_up())   canvas_s = min(round(canvas_s / inc) * inc + inc, 32);
			if(_canvas_s != canvas_s) {
				var dx = (canvas_s - _canvas_s) * ((mx - canvas_x) / _canvas_s);
				var dy = (canvas_s - _canvas_s) * ((my - canvas_y) / _canvas_s);
				canvas_x -= dx;
				canvas_y -= dy;
			}
		}
		canvas_hover = true;
	}
	
	function fullView() {
		var prevS = getNodePreviewSurface();
		if(!is_surface(prevS)) return;
		
		canvas_w = surface_get_width(prevS);
		canvas_h = surface_get_height(prevS);
				
		
		var ss = min((w - 32) / canvas_w, (h - 32) / canvas_h);
		canvas_s = ss;
		canvas_x = w / 2 - canvas_w * canvas_s / 2;
		canvas_y = h / 2 - canvas_h * canvas_s / 2;
		
		if(PANEL_GRAPH.node_focus) {
			canvas_x -= PANEL_GRAPH.node_focus.preview_x * canvas_s;
			canvas_y -= PANEL_GRAPH.node_focus.preview_y * canvas_s;
		}
	}
	
	sbChannel = new scrollBox([], function(index) { 
		var node = getNodePreview();
		if(node == noone) return;
		
		node.preview_channel = index; 
	});
	
	sbChannel.align = fa_left;
	function drawNodeChannel(_x, _y) {
		var _node = getNodePreview();
		if(_node == noone) return;
		if(ds_list_size(_node.outputs) < 2) return;
		
		var chName = [];
		var ww = 40;
		var hh = 28;
		draw_set_text(f_p0, fa_center, fa_center, c_white);
		
		for( var i = 0; i < ds_list_size(_node.outputs); i++ ) {
			array_push(chName, _node.outputs[| i].name);
			ww = max(ww, string_width(_node.outputs[| i].name) + 40);
		}
		sbChannel.data_list = chName;
		sbChannel.hover = HOVER == panel;
		sbChannel.active = FOCUS == panel;
		
		sbChannel.draw(_x - ww, _y - hh / 2, ww, hh, _node.outputs[| _node.preview_channel].name, [mx, my], panel.x, panel.y);
		right_menu_y += 40;
	}
	
	function drawNodePreview() {
		var ss  = canvas_s;
		
		if(is_surface(preview_surface[0])) {
			var psx = canvas_x + preview_node[0].preview_x * ss;
			var psy = canvas_y + preview_node[0].preview_y * ss;
			
			var psw = surface_get_width(preview_surface[0]);
			var psh = surface_get_height(preview_surface[0]);
			var pswd = psw * ss;
			var pshd = psh * ss;
			
			var psx1 = psx + pswd;
			var psy1 = psy + pshd;	
		}
		
		if(is_surface(preview_surface[1])) {
			var ssx = canvas_x + preview_node[1].preview_x * ss;
			var ssy = canvas_y + preview_node[1].preview_y * ss;
			
			var ssw = surface_get_width(preview_surface[1]);
			var ssh = surface_get_height(preview_surface[1]);
		}
		
		switch(splitView) {
			case 0 :
				if(is_surface(preview_surface[0])) {
					preview_node[0].previewing = 1;
					draw_surface_ext_safe(preview_surface[0], psx, psy, ss, ss, 0, c_white, 1);						
				}
				break;
			case 1 :
				var sp = splitPosition * w;
				
				if(is_surface(preview_surface[0])) {
					preview_node[0].previewing = 2;
					var maxX = min(sp, psx1);
					var sW = min(psw, (maxX - psx) / ss);
					
					if(sW > 0)
						draw_surface_part_ext_safe(preview_surface[0], 0, 0, sW, psh, psx, psy, ss, ss, 0, c_white, 1);
				}
				
				if(is_surface(preview_surface[1])) {
					preview_node[1].previewing = 3;
					var minX = max(ssx, sp);
					var sX = (minX - ssx) / ss;
					var spx = max(sp, ssx);
					
					if(sX >= 0 && sX < ssw)
						draw_surface_part_ext_safe(preview_surface[1], sX, 0, ssw - sX, ssh, spx, ssy, ss, ss, 0, c_white, 1);
				}
				break;
			case 2 :
				var sp = splitPosition * h;
					
				if(is_surface(preview_surface[0])) {
					preview_node[0].previewing = 4;
					var maxY = min(sp, psy1);
					var sH = min(psh, (maxY - psy) / ss);
					
					if(sH > 0)
						draw_surface_part_ext_safe(preview_surface[0], 0, 0, psw, sH, psx, psy, ss, ss, 0, c_white, 1);
				}
				
				if(is_surface(preview_surface[1])) {
					preview_node[1].previewing = 5;
					var minY = max(ssy, sp);
					var sY = (minY - ssy) / ss;
					var spy = max(sp, ssy);
					
					if(sY >= 0 && sY < ssh)
						draw_surface_part_ext_safe(preview_surface[1], 0, sY, ssw, ssh - sY, ssx, spy, ss, ss, 0, c_white, 1);
				}
				break;
		}
	}
	
	function drawPreviewOverlay(_node) {
		right_menu_y = 8;
		draw_set_text(f_p0, fa_right, fa_top, c_ui_blue_ltgrey);
		draw_text(w - 8, right_menu_y, "fps " + string(fps));
		right_menu_y += 20;
		
		draw_set_text(f_p0, fa_right, fa_top, c_ui_blue_ltgrey);
		draw_text(w - 8, right_menu_y, "frame " + string(ANIMATOR.current_frame) + "/" + string(ANIMATOR.frames_total));
		right_menu_y += 20;
		draw_text(w - 8, right_menu_y, string(canvas_w) + "x" + string(canvas_h) + "px");
		right_menu_y += 20;
		draw_text(w - 8, right_menu_y, "x" + string(canvas_s));
		right_menu_y += 20;
		
		var prev_size = 48;
		preview_x = lerp_float(preview_x, preview_x_to, 5);
		
		var pseq = getNodePreviewSequence();
		if(pseq != 0) {
			if(pseq != _preview_sequence) {
				_preview_sequence = pseq;
				preview_x    = 0;
				preview_x_to = 0;
			}
			
			if(HOVER == panel && my > h - prev_size - 16) {
				canvas_hover = false;
				if(mouse_wheel_down())	preview_x_to = clamp(preview_x_to - prev_size, - preview_x_max, 0);
				if(mouse_wheel_up())	preview_x_to = clamp(preview_x_to + prev_size, - preview_x_max, 0);
			}
			
			preview_x_max = 0;
			for(var i = 0; i < array_length(pseq); i++) {
				var xx = preview_x + 8 + (prev_size + 8) * i;
				var yy = h - prev_size - 8;
				
				var prev   = pseq[i];
				if(!is_surface(prev)) continue;
				
				var prev_w = surface_get_width(prev);
				var prev_h = surface_get_height(prev);
				var ss     = prev_size / max(prev_w, prev_h);
				
				draw_set_color(c_ui_blue_grey);
				draw_rectangle(xx, yy, xx + prev_w * ss, yy + prev_h * ss, true);
				
				if(FOCUS == panel && point_in_rectangle(mx, my, xx, yy, xx + prev_w * ss, yy + prev_h * ss)) {
					if(mouse_check_button_pressed(mb_left)) {
						_node.preview_index = i;
						do_fullView = true;
					}
					draw_surface_ext_safe(prev, xx, yy, ss, ss, 0, c_white, 1);
				} else {
					draw_surface_ext_safe(prev, xx, yy, ss, ss, 0, c_white, 0.5);	
				}
				
				if(i == _node.preview_index) {
					draw_set_color(c_ui_orange);
					draw_rectangle(xx, yy, xx + prev_w * ss, yy + prev_h * ss, true);
				}
				
				preview_x_max += prev_size + 8;
			}
			preview_x_max = max(preview_x_max - 100, 0);
			
			var by = h - prev_size - 56;
			var bx = 10;
			
			var b = buttonInstant(s_button_hide, bx, by, 40, 40, [mx, my], FOCUS == panel, HOVER == panel);
			
			if(_node.preview_speed == 0) {
				if(b) {
					draw_sprite_ext(s_sequence_control, 1, bx + 20, by + 20, 1, 1, 0, c_ui_blue_ltgrey, 1);
					if(b == 2) _node.preview_speed = preview_rate / room_speed;
				}
				draw_sprite_ext(s_sequence_control, 1, bx + 20, by + 20, 1, 1, 0, c_ui_blue_ltgrey, 0.5);
			} else {
				if(b) {
					draw_sprite_ext(s_sequence_control, 0, bx + 20, by + 20, 1, 1, 0, c_ui_orange, 1);
					if(b == 2) _node.preview_speed = 0;
				}
				draw_sprite_ext(s_sequence_control, 0, bx + 20, by + 20, 1, 1, 0, c_ui_orange, .75);
			}
			
			tb_framerate.active = FOCUS == panel;
			tb_framerate.hover  = HOVER == panel;
			tb_framerate.draw(bx + 52, by + 4, 64, 32, preview_rate, [mx, my]);
		}
		
		draw_set_color(c_ui_blue_grey);
		var cx = canvas_x + _node.preview_x * canvas_s;
		var cy = canvas_y + _node.preview_y * canvas_s;
		var _ww = canvas_w * canvas_s;
		var _hh = canvas_h * canvas_s;
		draw_rectangle(cx, cy, cx + _ww, cy + _hh, true);
		
		if(grid_show) {
			var _gw = grid_width  * canvas_s;
			var _gh = grid_height * canvas_s;
			
			var gw = ceil(_ww / _gw);
			var gh = ceil(_hh / _gh);
			
			draw_set_color(c_ui_blue_ltgrey);
			for( var i = 0; i < gw; i++ ) {
				var _xx = cx + i * _gw;
				draw_line(_xx, cy, _xx, cy + _hh);
			}
			
			for( var i = 0; i < gh; i++ ) {
				var _yy = cy + i * _gh;
				draw_line(cx, _yy, cx + _ww, _yy);
			}
		}
	}
	
	function drawNodeOverlay(_active, _node) {
		var active = _active;
		var _mx = mouse_on_preview? mx : -99999;
		var _my = mouse_on_preview? my : -99999;
		
		if(_node.tools != -1) {
			var xx = 16;
			var yy = 16;
			
			for(var i = 0; i < array_length(_node.tools); i++) {
				var b = buttonInstant(s_button, xx, yy, 40, 40, [_mx, _my], FOCUS == panel, HOVER == panel);
				var toggle = false;
				if(b == 1) {
					TOOLTIP = _node.tools[i][0];
					active = false;
				} else if(b == 2) {
					toggle = true;
					active = false;
				}
				
				if(FOCUS == panel && keyboard_check_pressed(ord(string(i + 1))))
					toggle = true;
					
				if(toggle) {
					if(is_array(_node.tools[i][1])) {
						if(tool_index == i)
							tool_sub_index = (tool_sub_index + 1) % array_length(_node.tools[i][1]);
						tool_index = i;
					} else
						tool_index = tool_index == i? -1 : i;
				}
				
				if(tool_index == i)
					draw_sprite_stretched(s_button, 2, xx, yy, 40, 40);
				
				if(is_array(_node.tools[i][1])) {
					var _ind = tool_sub_index % array_length(_node.tools[i][1]);
					draw_sprite_ext(_node.tools[i][1][_ind], 0, xx + 20, yy + 20, 1, 1, 0, c_white, 1);
				} else
					draw_sprite_ext(_node.tools[i][1], 0, xx + 20, yy + 20, 1, 1, 0, c_white, 1);
				yy += 48;
			}
		}
		
		_node.drawOverlay(active, canvas_x + _node.preview_x * canvas_s, canvas_y + _node.preview_y * canvas_s, canvas_s, _mx, _my);
	}
	
	function drawToolBar() {
		var ty = h - toolbar_height;
		//draw_sprite_stretched_ext(s_toolbar_shadow, 0, 0, ty - 12 + 4, w, 12, c_white, 0.5);
		draw_set_color(c_ui_blue_black);
		draw_rectangle(0, ty, w, h, false);
		
		draw_set_color(c_ui_blue_dkgrey);
		draw_line(0, ty, w, ty);
		
		var tbx = toolbar_height / 2;
		var tby = ty + toolbar_height / 2;
		
		for( var i = 0; i < array_length(toolbars); i++ ) {
			var tb = toolbars[i];
			var tbSpr = tb[0];
			var tbInd = tb[1]();
			var tbTooltip = tb[2]();
			
			var b = buttonInstant(s_button_hide, tbx - 14, tby - 14, 28, 28, [mx, my], FOCUS == panel, HOVER == panel, tbTooltip, tbSpr, tbInd);
			if(b == 2) tb[3]();
			
			tbx += 32;
		}
		
		tbx = w - toolbar_height / 2;
		for( var i = 0; i < array_length(actions); i++ ) {
			var tb = actions[i];
			var tbSpr = tb[0];
			var tbTooltip = tb[1];
			
			var b = buttonInstant(s_button_hide, tbx - 14, tby - 14, 28, 28, [mx, my], FOCUS == panel, HOVER == panel, tbTooltip, tbSpr, 0);
			if(b == 2) tb[2]();
			
			tbx -= 32;
		}
		
		draw_set_color(c_ui_blue_dkblack);
		draw_line_width(tbx + 12, tby - toolbar_height / 2 + 8, tbx + 12, tby + toolbar_height / 2 - 8, 2);
		drawNodeChannel(tbx, tby);
	}
	
	function drawSplitView() {
		if(splitView == 0) return;
		
		draw_set_color(c_ui_blue_grey);
		
		if(splitViewDragging) {
			if(splitView == 1) {
				var cx = splitViewStart + (mx - splitViewMouse);
				splitPosition = clamp(cx / w, .1, .9);
			} else if(splitView == 2) {
				var cy = splitViewStart + (my - splitViewMouse);
				splitPosition = clamp(cy / h, .1, .9);
			}
			
			if(mouse_check_button_released(mb_left))
				splitViewDragging = false;
		}
		
		if(splitView == 1) {
			var sx = w * splitPosition;
			
			if(mouse_on_preview && point_in_rectangle(mx, my, sx - 2, 0, sx + 2, h)) {
				draw_line_width(sx, 0, sx, h, 2);
				if(mouse_check_button_pressed(mb_left)) {
					splitViewDragging = true;
					splitViewStart = sx;
					splitViewMouse = mx;
				}
			} else 
				draw_line_width(sx, 0, sx, h, 1);
			
			
			draw_sprite(s_panel_active_split, 0, splitSelection? sx + 16 : sx - 16, 16);
			
			if(mouse_on_preview && mouse_check_button_pressed(mb_left)) {
				if(point_in_rectangle(mx, my, 0, 0, sx, h))
					splitSelection = 0;
				else if(point_in_rectangle(mx, my, sx, 0, w, h))
					splitSelection = 1;
			}
		} else {
			var sy = h * splitPosition;
			
			if(mouse_on_preview && point_in_rectangle(mx, my, 0, sy - 2, w, sy + 2)) {
				draw_line_width(0, sy, w, sy, 2);
				if(mouse_check_button_pressed(mb_left)) {
					splitViewDragging = true;
					splitViewStart = sy;
					splitViewMouse = my;
				}
			} else
				draw_line_width(0, sy, w, sy, 1);
			draw_sprite(s_panel_active_split, 0, 16, splitSelection? sy + 16 : sy - 16);
			
			if(mouse_on_preview && mouse_check_button_pressed(mb_left)) {
				if(point_in_rectangle(mx, my, 0, 0, w, sy))
					splitSelection = 0;
				else if(point_in_rectangle(mx, my, 0, sy, w, h))
					splitSelection = 1;
			}
		}
	}
	
	function drawContent() {
		mouse_on_preview = point_in_rectangle(mx, my, 0, 0, w, h - toolbar_height);
		
		draw_clear(c_ui_blue_black);
		if(canvas_bg == -1) {
			if(canvas_s >= 1) draw_sprite_tiled_ext(s_transparent, 0, canvas_x, canvas_y, canvas_s, canvas_s, c_white, 0.5);
		} else {
			draw_clear(canvas_bg);
		}
		
		dragCanvas();
		
		getPreviewData();
		drawNodePreview();
		
		if(PANEL_GRAPH.node_focus)
			drawNodeOverlay(FOCUS == panel, PANEL_GRAPH.node_focus);
		
		var viewNode = getNodePreview();
		if(viewNode) {
			drawPreviewOverlay(viewNode);
		}
		
		if(last_focus != PANEL_GRAPH.node_focus) {
			last_focus = PANEL_GRAPH.node_focus;
			tool_index = -1;
		}
		
		if(do_fullView) {
			do_fullView = false;
			fullView();
		}
		
		if(FOCUS == panel) {
			if(mouse_check_button_pressed(mb_right)) {
				var dia = dialogCall(o_dialog_menubox, mouse_mx + 8, mouse_my + 8);
				dia.setMenu([ 
					[ "Save current preview as...", function() { PANEL_PREVIEW.saveCurrentFrame(); } ], 
					[ "Save all current previews as...", function() { PANEL_PREVIEW.saveAllCurrentFrames(); } ], 
				]);
			}
		}
		
		drawSplitView();
		drawToolBar();
	}
	
	function saveCurrentFrame() {
		var prevS = getNodePreviewSurface();
		if(!is_surface(prevS)) return;
		
		var path = get_save_filename(".png", "export");
		if(path == "") return;
		if(filename_ext(path) == "") path += ".png";
		
		surface_save(prevS, path);
	}
	
	function saveAllCurrentFrames() {
		var path = get_save_filename(".png", "export");
		if(path == "") return;
		
		var ext  = filename_ext(path);
		if(ext == "") ext = ".png";
		var name = string_replace_all(path, ext, "");
		var ind  = 0;
		
		var pseq = getNodePreviewSequence();
		for(var i = 0; i < array_length(pseq); i++) {
			var prev   = pseq[i];
			if(!is_surface(prev)) continue;
			var _name = name + string(ind) + ext;
			surface_save(prev, _name);
			ind++;
		}
	}
}