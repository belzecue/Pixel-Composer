function Node_create_Image_Sequence(_x, _y, _group = noone) {
	var path = "";
	if(NODE_NEW_MANUAL) {
		path = get_open_filenames_compat("image|*.png;*.jpg", "");
		key_release();
		if(path == "") return noone;
	}
	
	var node  = new Node_Image_Sequence(_x, _y, _group).skipDefault();
	var paths = string_splice(path, "\n");
	
	node.inputs[| 0].setValue(paths);
	if(NODE_NEW_MANUAL) node.doUpdate();
	
	return node;
}

function Node_create_Image_Sequence_path(_x, _y, _path) {
	var node = new Node_Image_Sequence(_x, _y, PANEL_GRAPH.getCurrentContext()).skipDefault();
	    node.inputs[| 0].setValue(_path);
	    node.doUpdate();

	return node;
}

enum CANVAS_SIZE {
	individual,
	minimum,
	maximum
}

enum CANVAS_SIZING {
	padding,
	scale
}

function Node_Image_Sequence(_x, _y, _group = noone) : Node(_x, _y, _group) constructor {
	name  = "Image Array";
	spr   = [];
	color = COLORS.node_blend_input;
	
	inputs[| 0]  = nodeValue("Paths", self, JUNCTION_CONNECT.input, VALUE_TYPE.path, [])
		.setDisplay(VALUE_DISPLAY.path_array, { filter: ["image|*.png;*.jpg", ""] });
	
	inputs[| 1]  = nodeValue("Padding", self, JUNCTION_CONNECT.input, VALUE_TYPE.integer, [0, 0, 0, 0])
		.setDisplay(VALUE_DISPLAY.padding)
		.rejectArray();
	
	inputs[| 2] = nodeValue_Enum_Scroll("Canvas size", self,  0, [ "Individual", "Minimum", "Maximum" ])
		.rejectArray();
	
	inputs[| 3] = nodeValue_Enum_Scroll("Sizing method", self,  0, [ "Padding / Crop", "Scale" ])
		.rejectArray();
	
	input_display_list = [
		["Array settings",	false], 0, 1, 2, 3
	];
	
	outputs[| 0] = nodeValue("Surface out", self, JUNCTION_CONNECT.output, VALUE_TYPE.surface, []);
	outputs[| 1] = nodeValue("Paths", self, JUNCTION_CONNECT.output, VALUE_TYPE.path, [] ).
		setVisible(true, true);
	
	attribute_surface_depth();
	
	path_current = [];
	edit_time    = 0;
	
	attributes.file_checker = true;
	array_push(attributeEditors, [ "File Watcher", function() { return attributes.file_checker; }, 
		new checkBox(function() { attributes.file_checker = !attributes.file_checker; }) ]);
	
	on_drop_file = function(path) {
		if(directory_exists(path)) {
			with(dialogCall(o_dialog_drag_folder, WIN_W / 2, WIN_H / 2)) {
				dir_paths = path;
				target    = other;
			}
			return true;
		}
		
		var paths = paths_to_array_ext(path);
		
		inputs[| 0].setValue(path);
		if(updatePaths()) {
			doUpdate();
			return true;
		}
		
		return false;
	}
	
	insp1UpdateTooltip  = __txt("Refresh");
	insp1UpdateIcon     = [ THEME.refresh_icon, 1, COLORS._main_value_positive ];
	
	static onInspector1Update = function() {
		updatePaths();
		triggerRender();
	}
	
	function updatePaths() {
		var _paths   = getInputData(0);
		var paths    = path_get(_paths);
		path_current = array_clone(paths);
		
		for(var i = 0; i < array_length(spr); i++) {
			if(spr[i] && sprite_exists(spr[i]))
				sprite_delete(spr[i]);
		}
		
		spr = [];
		
		for( var i = 0, n = array_length(paths); i < n; i++ )  {
			var path = paths[i];
			if(path == -1) continue;
			
			var ext = string_lower(filename_ext(path));
			setDisplayName(filename_name_only(path));
			edit_time = max(edit_time, file_get_modify_s(path));
			
			switch(ext) {
				case ".png"	 :
				case ".jpg"	 :
				case ".jpeg" :
					var _spr = sprite_add_map(path);
					
					if(_spr == -1) {
						var _txt = $"Image node: File not a valid image.";
						logNode(_txt); noti_warning(_txt);
						return false;
					}
					
					array_push(spr, _spr);
					break;
			}
		}
		
		outputs[| 1].setValue(paths);
		
		return true;
	}
	
	static step = function() {
		if(attributes.file_checker)
		for( var i = 0, n = array_length(path_current); i < n; i++ ) {
			var _ed = file_get_modify_s(path_current[i]);
			
			if(_ed > edit_time) {
				updatePaths();
				triggerRender();
				break;
			}
		}
	}
	
	static update = function(frame = CURRENT_FRAME) {
		var path = inputs[| 0].getValue();
		
		if(!array_equals(path_current, path)) 
			updatePaths();
		
		var pad = getInputData(1);
		var can = getInputData(2);
		inputs[| 3].setVisible(can != CANVAS_SIZE.individual);
		
		var siz = getInputData(3);
		
		var  ww = -1,  hh = -1;
		var _ww = -1, _hh = -1;
		
		var surfs = outputs[| 0].getValue();
		var amo   = array_length(spr);
		for(var i = amo; i < array_length(surfs); i++)
			surface_free(surfs[i]);
			
		array_resize(surfs, amo);
		
		for(var i = 0; i < amo; i++) {
			var _spr = spr[i];
			var _w = sprite_get_width(_spr);
			var _h = sprite_get_height(_spr);
			
			switch(can) {
				case CANVAS_SIZE.minimum :
					ww = ww == -1? _w : min(ww, _w);
					hh = hh == -1? _h : min(hh, _h);
					break;
					
				case CANVAS_SIZE.maximum :
					ww = ww == -1? _w : max(ww, _w);
					hh = hh == -1? _h : max(hh, _h);
					break;
			}
		}
		
		_ww = ww;
		_hh = hh;
		ww += pad[0] + pad[2];
		hh += pad[1] + pad[3];
		
		for(var i = 0; i < array_length(spr); i++) {
			var _spr = spr[i];
			switch(can) {
				case CANVAS_SIZE.individual :
					ww = sprite_get_width(_spr)  + pad[0] + pad[2];
					hh = sprite_get_height(_spr) + pad[1] + pad[3];
					
					surfs[i] = surface_verify(surfs[i], ww, hh, attrDepth());
					surface_set_target(surfs[i]);
						DRAW_CLEAR
						BLEND_OVERRIDE;
						draw_sprite(_spr, 0, pad[2], pad[1]);
						BLEND_NORMAL;
					surface_reset_target();
					break;
					
				case CANVAS_SIZE.maximum :
				case CANVAS_SIZE.minimum :
					surfs[i] = surface_verify(surfs[i], ww, hh, attrDepth());
					var _w = sprite_get_width(_spr);
					var _h = sprite_get_height(_spr);
						
					if(siz == CANVAS_SIZING.scale) {
						var ss = min(_ww / _w, _hh / _h);
						var sw = (ww - _w * ss) / 2;
						var sh = (hh - _h * ss) / 2;
						
						surface_set_target(surfs[i]);
							DRAW_CLEAR
							BLEND_OVERRIDE;
							draw_sprite_ext(_spr, 0, sw, sh, ss, ss, 0, c_white, 1);
							BLEND_NORMAL;
						surface_reset_target();
						
					} else {
						var xx = (ww - _w) / 2;
						var yy = (hh - _h) / 2;
						
						surface_set_target(surfs[i]);
							DRAW_CLEAR
							BLEND_OVERRIDE;
							draw_sprite(_spr, 0, xx, yy);
							BLEND_NORMAL;
						surface_reset_target();
					}
					break;
			}
			
		}
		
		outputs[| 0].setValue(surfs);
	}
	
	static dropPath = function(path) { 
		if(!is_array(path)) path = [ path ];
		inputs[| 0].setValue(path); 
	}
}