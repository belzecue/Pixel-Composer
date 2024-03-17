function Node_Combine_HSV(_x, _y, _group = noone) : Node_Processor(_x, _y, _group) constructor {
	name = "HSV Combine";
	
	inputs[| 0] = nodeValue("Hue",        self, JUNCTION_CONNECT.input, VALUE_TYPE.surface, noone);
	inputs[| 1] = nodeValue("Saturation", self, JUNCTION_CONNECT.input, VALUE_TYPE.surface, noone);
	inputs[| 2] = nodeValue("Value",      self, JUNCTION_CONNECT.input, VALUE_TYPE.surface, noone);
	inputs[| 3] = nodeValue("Alpha",      self, JUNCTION_CONNECT.input, VALUE_TYPE.surface, noone);
	
	inputs[| 4] = nodeValue("Array Input", self, JUNCTION_CONNECT.input, VALUE_TYPE.boolean, false);
	
	inputs[| 5] = nodeValue("HSV Array", self, JUNCTION_CONNECT.input, VALUE_TYPE.surface, [])
		.setArrayDepth(1);
	
	outputs[| 0] = nodeValue("Surface out", self, JUNCTION_CONNECT.output, VALUE_TYPE.surface, noone);
	
	input_display_list = [
		["Surfaces",	 true], 4, 0, 1, 2, 3, 5, 
	]
	
	attribute_surface_depth();
	
	static step = function() { #region
		var _arr = getInputData(4);
		
		inputs[| 0].setVisible(!_arr, !_arr);
		inputs[| 1].setVisible(!_arr, !_arr);
		inputs[| 2].setVisible(!_arr, !_arr);
		inputs[| 3].setVisible(!_arr, !_arr);
		
		inputs[| 5].setVisible(_arr, _arr);
	} #endregion
	
	static processData = function(_outSurf, _data, _output_index, _array_index) { #region
		var _arr  = _data[4];
		
		var _h = _arr? array_safe_get(_data[5], 0) : _data[0];
		var _s = _arr? array_safe_get(_data[5], 1) : _data[1];
		var _v = _arr? array_safe_get(_data[5], 2) : _data[2];
		var _a = _arr? array_safe_get(_data[5], 3) : _data[3];
		
		surface_set_shader(_outSurf, sh_combine_hsv);
			shader_set_surface("samH", _h);
			shader_set_surface("samS", _s);
			shader_set_surface("samV", _v);
			shader_set_surface("samA", _a);
			
			shader_set_i("useH", is_surface(_h));
			shader_set_i("useS", is_surface(_s));
			shader_set_i("useV", is_surface(_v));
			shader_set_i("useA", is_surface(_a));
			
			draw_sprite_stretched(s_fx_pixel, 0, 0, 0, surface_get_width_safe(_outSurf), surface_get_width_safe(_outSurf));
		surface_reset_shader();
		
		return _outSurf;
	} #endregion
}