function Node_Blend_Edge(_x, _y, _group = noone) : Node_Processor(_x, _y, _group) constructor {
	name = "Blend Edge";
	
	inputs[| 0] = nodeValue("Surface in", self, JUNCTION_CONNECT.input, VALUE_TYPE.surface, noone);
	
	inputs[| 1] = nodeValue("Width", self, JUNCTION_CONNECT.input, VALUE_TYPE.float, 0.1)
		.setDisplay(VALUE_DISPLAY.slider)
		.setMappable(5);
	
	inputs[| 2] = nodeValue("Types",self, JUNCTION_CONNECT.input, VALUE_TYPE.integer, 0)
		.setDisplay(VALUE_DISPLAY.enum_button, [ "Both", "Horizontal", "Vertical" ]);
	
	inputs[| 3] = nodeValue("Active", self, JUNCTION_CONNECT.input, VALUE_TYPE.boolean, true);
		active_index = 3;
	
	inputs[| 4] = nodeValue("Channel", self, JUNCTION_CONNECT.input, VALUE_TYPE.integer, 0b1111)
		.setDisplay(VALUE_DISPLAY.toggle, { data: array_create(4, THEME.inspector_channel) });
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	
	inputs[| 5] = nodeValue("Width map", self, JUNCTION_CONNECT.input, VALUE_TYPE.surface, noone)
		.setVisible(false, false);
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	
	inputs[| 6] = nodeValue("Blending", self, JUNCTION_CONNECT.input, VALUE_TYPE.float, 1)
		.setDisplay(VALUE_DISPLAY.slider);
		
	inputs[| 7] = nodeValue("Smoothness", self, JUNCTION_CONNECT.input, VALUE_TYPE.float, 0)
		.setDisplay(VALUE_DISPLAY.slider);
		
	input_display_list = [ 3, 4, 
		["Surfaces", true], 0, 
		["Blend",	false], 2, 1, 5, 6, 7, 
	]
	
	outputs[| 0] = nodeValue("Surface out", self, JUNCTION_CONNECT.output, VALUE_TYPE.surface, noone);
	
	temp_surface = array_create(1);
	
	attribute_surface_depth();
	
	static step = function() { #region
		inputs[| 1].mappableStep();
	} #endregion
	
	static processData = function(_outSurf, _data, _output_index, _array_index) {
		var _sw = surface_get_width_safe(_data[0]);
		var _sh = surface_get_height_safe(_data[0]);
		
		for( var i = 0, n = array_length(temp_surface); i < n; i++ ) 
			temp_surface[i] = surface_verify(temp_surface[i], _sw, _sh);
		
		var _edg = _data[2];
		
		if(_edg == 0) {
			surface_set_shader(temp_surface[0], sh_blend_edge);
				shader_set_f("dimension", _sw, _sh);
				shader_set_f_map("width", _data[1], _data[5], inputs[| 1]);
				shader_set_i("edge"     , 0);
				shader_set_f("blend"    , clamp(_data[6], 0.001, 0.999));
				shader_set_f("smooth"   , _data[7]);
				
				draw_surface(_data[0], 0, 0);
			surface_reset_shader();
			
			surface_set_shader(_outSurf, sh_blend_edge);
				shader_set_i("edge"     , 1);
				
				draw_surface(temp_surface[0], 0, 0);
			surface_reset_shader();
			
		} else {
			surface_set_shader(_outSurf, sh_blend_edge);
				shader_set_f("dimension", _sw, _sh);
				shader_set_f_map("width", _data[1], _data[5], inputs[| 1]);
				shader_set_i("edge"     , _edg - 1);
				shader_set_f("blend"    , clamp(_data[6], 0.001, 0.999));
				
				draw_surface(_data[0], 0, 0);
			surface_reset_shader();
			
		}
		
		return _outSurf;
	}
}