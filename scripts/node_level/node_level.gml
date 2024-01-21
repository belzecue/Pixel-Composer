function Node_Level(_x, _y, _group = noone) : Node_Processor(_x, _y, _group) constructor {
	name = "Level";
	
	inputs[| 0] = nodeValue("Surface in", self, JUNCTION_CONNECT.input, VALUE_TYPE.surface, 0);
	
	inputs[| 1] = nodeValue("White",   self, JUNCTION_CONNECT.input, VALUE_TYPE.float, [0, 1])
		.setDisplay(VALUE_DISPLAY.slider_range);
	
	inputs[| 2] = nodeValue("Red",   self, JUNCTION_CONNECT.input, VALUE_TYPE.float, [0, 1])
		.setDisplay(VALUE_DISPLAY.slider_range);
	
	inputs[| 3] = nodeValue("Green",   self, JUNCTION_CONNECT.input, VALUE_TYPE.float, [0, 1])
		.setDisplay(VALUE_DISPLAY.slider_range);
	
	inputs[| 4] = nodeValue("Blue",   self, JUNCTION_CONNECT.input, VALUE_TYPE.float, [0, 1])
		.setDisplay(VALUE_DISPLAY.slider_range);
	
	inputs[| 5] = nodeValue("Alpha",   self, JUNCTION_CONNECT.input, VALUE_TYPE.float, [0, 1])
		.setDisplay(VALUE_DISPLAY.slider_range);
	
	inputs[| 6] = nodeValue("Mask", self, JUNCTION_CONNECT.input, VALUE_TYPE.surface, 0);
	
	inputs[| 7] = nodeValue("Mix", self, JUNCTION_CONNECT.input, VALUE_TYPE.float, 1)
		.setDisplay(VALUE_DISPLAY.slider);
	
	inputs[| 8] = nodeValue("Active", self, JUNCTION_CONNECT.input, VALUE_TYPE.boolean, true);
		active_index = 8;
	
	inputs[| 9] = nodeValue("Channel", self, JUNCTION_CONNECT.input, VALUE_TYPE.integer, 0b1111)
		.setDisplay(VALUE_DISPLAY.toggle, { data: array_create(4, THEME.inspector_channel) });
		
	__init_mask_modifier(6); // inputs 10, 11
	
	outputs[| 0] = nodeValue("Surface out", self, JUNCTION_CONNECT.output, VALUE_TYPE.surface, noone);
	
	attribute_surface_depth();
	
	level_renderer = new Inspector_Custom_Renderer(function(_x, _y, _w, _m, _hover, _focus) { #region
		var _h = 128;
		var x0 = _x;
		var x1 = _x + _w;
		var y0 = _y;
		var y1 = _y + _h; 
		
		draw_set_color(COLORS.node_level_shade);
		var _wh = getInputData(1);
		var _wmin = min(_wh[0], _wh[1]);
		var _wmax = max(_wh[0], _wh[1]);
		
		draw_rectangle(x0, y0, x0 + max(0, _wmin) * _w, y1, false);
		draw_rectangle(x0 + min(1, _wmax) * _w, y0, x1, y1, false);
		
		for( var i = 0; i < 4; i++ ) {
			var _bx = x1 - 20 - i * 24;
			var _by = y0;
			
			if(buttonInstant(THEME.button_hide, _bx, _by, 20, 20, _m, _focus, _hover) == 2) 
				histShow[i] = !histShow[i];
			draw_sprite_ui_uniform(THEME.circle, 0, _bx + 10, _by + 10, 1, COLORS.histogram[i], 0.5 + histShow[i] * 0.5);
		}
		
		if(histMax > 0)
			histogramDraw(x0, y1, _w, _h);

		draw_set_color(COLORS.node_level_outline);
		draw_rectangle(x0, y0, x1, y1, true);
		
		return _h;
	}); #endregion
	
	input_display_list = [ 8, 9, 
		level_renderer,
		["Surfaces", true],	0, 6, 7, 10, 11,
		["Level",	false],	1,
		["Channel",	 true],	2, 3, 4, 5
	];
	histogramInit();
	
	static onInspect = function() {
		if(array_length(current_data) > 0)
			histogramUpdate(current_data[0]);
	}
	
	static onValueFromUpdate = function(index) { #region
		if(index == 0) {
			doUpdate();
			if(array_length(current_data) > 0)
				histogramUpdate(current_data[0]);
		}
	} #endregion
	
	static step = function() { #region
		__step_mask_modifier();
	} #endregion
	
	static processData = function(_outSurf, _data, _output_index, _array_index) { #region	
		var _w = _data[1];
		var _r = _data[2];
		var _g = _data[3];
		var _b = _data[4];
		var _a = _data[5];
		
		surface_set_shader(_outSurf, sh_level);
			shader_set_f("lw", _w);
			shader_set_f("lr", _r);
			shader_set_f("lg", _g);
			shader_set_f("lb", _b);
			shader_set_f("la", _a);
			
			draw_surface_safe(_data[0]);
		surface_reset_shader();
		
		__process_mask_modifier(_data);
		_outSurf = mask_apply(_data[0], _outSurf, _data[6], _data[7]);
		_outSurf = channel_apply(_data[0], _outSurf, _data[9]);
		
		return _outSurf;
	} #endregion
}
