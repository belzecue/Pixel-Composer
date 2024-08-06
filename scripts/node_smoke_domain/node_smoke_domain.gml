function Node_Smoke_Domain(_x, _y, _group = noone) : Node_Smoke(_x, _y, _group) constructor {
	name  = "Domain";
	color = COLORS.node_blend_smoke;
	icon  = THEME.smoke_sim;
	
	manual_ungroupable	 = false;
	
	inputs[| 0] = nodeValue("Dimension", self, JUNCTION_CONNECT.input, VALUE_TYPE.integer, DEF_SURF)
		.setDisplay(VALUE_DISPLAY.vector);
	
	inputs[| 1] = nodeValue("Collision", self, JUNCTION_CONNECT.input, VALUE_TYPE.surface, noone);
	
	inputs[| 2] = nodeValue("Material dissipation type", self, JUNCTION_CONNECT.input, VALUE_TYPE.integer, 1)
		.setDisplay(VALUE_DISPLAY.enum_button, [ "Multiply", "Subtract" ]);
	
	inputs[| 3] = nodeValue("Material dissipation", self, JUNCTION_CONNECT.input, VALUE_TYPE.float, 0.02)
		.setDisplay(VALUE_DISPLAY.slider, { range: [ 0, 0.1, 0.01 ] });
	
	inputs[| 4] = nodeValue("Velocity dissipation type", self, JUNCTION_CONNECT.input, VALUE_TYPE.integer, 1)
		.setDisplay(VALUE_DISPLAY.enum_button, [ "Multiply", "Subtract" ]);
	
	inputs[| 5] = nodeValue("Velocity dissipation", self, JUNCTION_CONNECT.input, VALUE_TYPE.float, 0.00)
		.setDisplay(VALUE_DISPLAY.slider, { range: [ 0, 0.1, 0.01 ] });
	
	inputs[| 6] = nodeValue("Acceleration", self, JUNCTION_CONNECT.input, VALUE_TYPE.float, [ 0, 0 ])
		.setDisplay(VALUE_DISPLAY.vector);
	
	inputs[| 7] = nodeValue("Material intertia", self, JUNCTION_CONNECT.input, VALUE_TYPE.float, [ 1, -0.2 ])
		.setDisplay(VALUE_DISPLAY.vector);
	
	inputs[| 8] = nodeValue("Initial pressure", self, JUNCTION_CONNECT.input, VALUE_TYPE.float, 0.75)
		.setDisplay(VALUE_DISPLAY.slider);
	
	inputs[| 9] = nodeValue("Material Maccormack weight", self, JUNCTION_CONNECT.input, VALUE_TYPE.float, 1)
		.setDisplay(VALUE_DISPLAY.slider);
	
	inputs[| 10] = nodeValue("Velocity Maccormack weight", self, JUNCTION_CONNECT.input, VALUE_TYPE.float, 0)
		.setDisplay(VALUE_DISPLAY.slider);
	
	inputs[| 11] = nodeValue("Wrap", self, JUNCTION_CONNECT.input, VALUE_TYPE.boolean, false);
	
	outputs[| 0] = nodeValue("Domain", self, JUNCTION_CONNECT.output, VALUE_TYPE.sdomain, noone);
	
	input_display_list = [ 
		["Domain",		false], 0, 11, 1,
		["Properties",	false], 8, 6, 7,
		["Dissipation",	false], 2, 3, 4, 5,
		["Huh?",		 true], 9, 10, 
	];
	
	domain = fd_rectangle_create(256, 256);
	_dim_old = [0, 0];
	
	static update = function(frame = CURRENT_FRAME) { #region
		RETURN_ON_REST
		
		var _dim	= getInputData( 0);
		var coll	= getInputData( 1);
		var mdisTyp = getInputData( 2);
		var mdis    = getInputData( 3);
		var vdisTyp = getInputData( 4);
		var vdis    = getInputData( 5);
		var acc     = getInputData( 6);
		var matInr  = getInputData( 7);
		var inPress = getInputData( 8);
		var mMac	= getInputData( 9);
		var vMac	= getInputData(10);
		var wrap	= getInputData(11);
		
		if(IS_FIRST_FRAME || !is_surface(domain.sf_world)) {
			fd_rectangle_clear(domain);
			fd_rectangle_destroy(domain);
			domain = fd_rectangle_create(_dim[0], _dim[1]);
			
			fd_rectangle_set_visualization_shader(domain, FD_VISUALIZATION_SHADER.COLORIZE);
			fd_rectangle_set_material_type(domain, FD_MATERIAL_TYPE.A_16);
			fd_rectangle_set_velocity_time_step(domain, 1);
			fd_rectangle_set_material_time_step(domain, 1);
			
	        fd_rectangle_set_pressure_iteration_type(domain, -2);
			fd_rectangle_set_initial_value_pressure(domain, inPress);
		}
		
		surface_set_target(domain.sf_world);
			draw_clear_alpha($00FFFF, 0);
			if(is_surface(coll))
				draw_surface_stretched_safe(coll, 0, 0, _dim[0], _dim[1]);
		surface_reset_target();
		
		fd_rectangle_set_material_dissipation_type(domain, mdisTyp);
		fd_rectangle_set_material_dissipation_value(domain, mdis);
		
		fd_rectangle_set_velocity_dissipation_type(domain, vdisTyp);
		fd_rectangle_set_velocity_dissipation_value(domain, vdis);
			
		fd_rectangle_set_acceleration(domain, acc[0], acc[1], matInr[0], matInr[1]);
		
		fd_rectangle_set_velocity_maccormack_weight(domain, vMac);
	    fd_rectangle_set_material_maccormack_weight(domain, mMac);
		
		fd_rectangle_set_repeat(domain, wrap);
		
		outputs[| 0].setValue(domain);
	} #region
	
	static onDrawNode = function(xx, yy, _mx, _my, _s, _hover, _focus) { #region
		var bbox = drawGetBbox(xx, yy, _s);
		var _mat = getInputData(1);
		if(!is_surface(_mat)) return;
		
		draw_surface_fit(_mat, bbox.xc, bbox.yc, bbox.w, bbox.h);
	} #endregion
}