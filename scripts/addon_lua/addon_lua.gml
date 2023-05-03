#region setup
	function __addon_lua_setup(lua, context) {
		__addon_lua_setup_functions(lua);
		__addon_lua_setup_constants(lua, context);
		__addon_lua_setup_widget(lua, context);
		
		context.ready = true;
	}
#endregion
	
#region constant
	function __addon_lua_setup_constants(lua, context) {
		lua_add_code(lua, "ID = '" + string(context.ID) + "'");
	
		lua_add_code(lua, "c_aqua = " + string(c_aqua));
		lua_add_code(lua, "c_black = " + string(c_black));
		lua_add_code(lua, "c_blue = " + string(c_blue));
		lua_add_code(lua, "c_dkgray = " + string(c_dkgray));
		lua_add_code(lua, "c_fuchsia = " + string(c_fuchsia));
		lua_add_code(lua, "c_gray = " + string(c_gray));
		lua_add_code(lua, "c_green = " + string(c_green));
		lua_add_code(lua, "c_lime = " + string(c_lime));
		lua_add_code(lua, "c_ltgray = " + string(c_ltgray));
		lua_add_code(lua, "c_maroon = " + string(c_maroon));
		lua_add_code(lua, "c_navy = " + string(c_navy));
		lua_add_code(lua, "c_olive = " + string(c_olive));
		lua_add_code(lua, "c_orange = " + string(c_orange));
		lua_add_code(lua, "c_purple = " + string(c_purple));
		lua_add_code(lua, "c_red = " + string(c_red));
		lua_add_code(lua, "c_silver = " + string(c_silver));
		lua_add_code(lua, "c_teal = " + string(c_teal));
		lua_add_code(lua, "c_white = " + string(c_white));
		lua_add_code(lua, "c_yellow = " + string(c_yellow));

		lua_add_code(lua, "fa_left = " + string(fa_left));
		lua_add_code(lua, "fa_middle = " + string(fa_middle));
		lua_add_code(lua, "fa_right = " + string(fa_right));
		//
		lua_add_code(lua, "fa_top = " + string(fa_top));
		lua_add_code(lua, "fa_center = " + string(fa_center));
		lua_add_code(lua, "fa_bottom = " + string(fa_bottom));
	
		lua_add_code(lua, "mb_left = " + string(mb_left));
		lua_add_code(lua, "mb_middle = " + string(mb_middle));
		lua_add_code(lua, "mb_right = " + string(mb_right));

		lua_add_code(lua, "vk_nokey = " + string(vk_nokey));
		lua_add_code(lua, "vk_anykey = " + string(vk_anykey));
		lua_add_code(lua, "vk_left = " + string(vk_left));
		lua_add_code(lua, "vk_right = " + string(vk_right));
		lua_add_code(lua, "vk_up = " + string(vk_up));
		lua_add_code(lua, "vk_down = " + string(vk_down));
		lua_add_code(lua, "vk_enter = " + string(vk_enter));
		lua_add_code(lua, "vk_escape = " + string(vk_escape));
		lua_add_code(lua, "vk_space = " + string(vk_space));
		lua_add_code(lua, "vk_shift = " + string(vk_shift));
		lua_add_code(lua, "vk_control = " + string(vk_control));
		lua_add_code(lua, "vk_alt = " + string(vk_alt));
		lua_add_code(lua, "vk_backspace = " + string(vk_backspace));
		lua_add_code(lua, "vk_tab = " + string(vk_tab));
		lua_add_code(lua, "vk_home = " + string(vk_home));
		lua_add_code(lua, "vk_end = " + string(vk_end));
		lua_add_code(lua, "vk_delete = " + string(vk_delete));
		lua_add_code(lua, "vk_insert = " + string(vk_insert));
		lua_add_code(lua, "vk_pageup = " + string(vk_pageup));
		lua_add_code(lua, "vk_pagedown = " + string(vk_pagedown));
		lua_add_code(lua, "vk_pause = " + string(vk_pause));
		lua_add_code(lua, "vk_printscreen = " + string(vk_printscreen));
		lua_add_code(lua, "vk_f1 = " + string(vk_f1));
		lua_add_code(lua, "vk_f2 = " + string(vk_f2));
		lua_add_code(lua, "vk_f3 = " + string(vk_f3));
		lua_add_code(lua, "vk_f4 = " + string(vk_f4));
		lua_add_code(lua, "vk_f5 = " + string(vk_f5));
		lua_add_code(lua, "vk_f6 = " + string(vk_f6));
		lua_add_code(lua, "vk_f7 = " + string(vk_f7));
		lua_add_code(lua, "vk_f8 = " + string(vk_f8));
		lua_add_code(lua, "vk_f9 = " + string(vk_f9));
		lua_add_code(lua, "vk_f10 = " + string(vk_f10));
		lua_add_code(lua, "vk_f11 = " + string(vk_f11));
		lua_add_code(lua, "vk_f12 = " + string(vk_f12));
		lua_add_code(lua, "vk_numpad0 = " + string(vk_numpad0));
		lua_add_code(lua, "vk_numpad1 = " + string(vk_numpad1));
		lua_add_code(lua, "vk_numpad2 = " + string(vk_numpad2));
		lua_add_code(lua, "vk_numpad3 = " + string(vk_numpad3));
		lua_add_code(lua, "vk_numpad4 = " + string(vk_numpad4));
		lua_add_code(lua, "vk_numpad5 = " + string(vk_numpad5));
		lua_add_code(lua, "vk_numpad6 = " + string(vk_numpad6));
		lua_add_code(lua, "vk_numpad7 = " + string(vk_numpad7));
		lua_add_code(lua, "vk_numpad8 = " + string(vk_numpad8));
		lua_add_code(lua, "vk_numpad9 = " + string(vk_numpad9));
		lua_add_code(lua, "vk_multiply = " + string(vk_multiply));
		lua_add_code(lua, "vk_divide = " + string(vk_divide));
		lua_add_code(lua, "vk_add = " + string(vk_add));
		lua_add_code(lua, "vk_subtract = " + string(vk_subtract));
		lua_add_code(lua, "vk_decimal = " + string(vk_decimal));
	
		lua_add_code(lua, "tb_text = " + string(TEXTBOX_INPUT.text));
		lua_add_code(lua, "tb_number = " + string(TEXTBOX_INPUT.number));
	
		lua_add_code(lua, "Panel = {};");
		lua_add_code(lua, "Animator = {};");
	}
	
	function __addon_lua_panel_variable(lua, panel) {
		lua_add_code(lua, 
			"Panel.mouse = {" + string(panel.mx) + ", " + string(panel.my) + "}\n" + 
			"Panel.x  = " + string(panel.x ) + "\n" + 
			"Panel.y  = " + string(panel.y ) + "\n" + 
			"Panel.w  = " + string(panel.w ) + "\n" + 
			"Panel.h  = " + string(panel.h ) + "\n" +
		
			"Panel.hoverable = " + string(panel.pHOVER) + "\n" +
			"Panel.clickable = " + string(panel.pFOCUS) + "\n" 
		);
	
		lua_add_code(lua, 
			"Animator.frame_current = " + string(ANIMATOR.current_frame) + "\n" + 
			"Animator.frame_total = " +   string(ANIMATOR.frames_total) + "\n" + 
			"Animator.frame_rate  = " +   string(ANIMATOR.framerate) + "\n"
		);
	}
#endregion
	
#region API
	function __addon_lua_setup_functions(lua) {
		for( var i = 0; i < array_length(global.__lua_functions); i++ ) {
			var _func = global.__lua_functions[i];
			lua_add_function(lua, _func[0], _func[1]);
		}
	}
	
	global.__lua_functions = [
		[ "print", print ], 
		
		[ "colour_get_blue", colour_get_blue ],
		[ "colour_get_green", colour_get_green ],
		[ "colour_get_red", colour_get_red ],
		[ "colour_get_hue", colour_get_hue ],
		[ "colour_get_saturation", colour_get_saturation ],
		[ "colour_get_value", colour_get_value ],
		[ "draw_getpixel", draw_getpixel ],
		[ "draw_getpixel_ext", draw_getpixel_ext ],
		[ "draw_get_colour", draw_get_colour ],
		[ "draw_get_alpha", draw_get_alpha ],

		[ "make_colour_hsv", make_colour_hsv ],
		[ "make_colour_rgb", make_colour_rgb ],
		[ "merge_colour", merge_colour ],

		[ "draw_clear", draw_clear ],
		[ "draw_clear_alpha", draw_clear_alpha ],
		[ "draw_set_alpha", draw_set_alpha ],
		[ "draw_set_colour", draw_set_colour ],

		// gpu
		[ "gpu_get_blendenable", gpu_get_blendenable],
		[ "gpu_get_ztestenable", gpu_get_ztestenable],
		[ "gpu_get_zfunc", gpu_get_zfunc],
		[ "gpu_get_zwriteenable", gpu_get_zwriteenable],
		[ "gpu_get_fog", gpu_get_fog],
		[ "gpu_get_cullmode", gpu_get_cullmode],
		[ "gpu_get_blendmode", gpu_get_blendmode],
		[ "gpu_get_blendmode_ext", gpu_get_blendmode_ext],
		[ "gpu_get_blendmode_ext_sepalpha", gpu_get_blendmode_ext_sepalpha],
		[ "gpu_get_blendmode_src", gpu_get_blendmode_src],
		[ "gpu_get_blendmode_dest", gpu_get_blendmode_dest],
		[ "gpu_get_blendmode_srcalpha", gpu_get_blendmode_srcalpha],
		[ "gpu_get_blendmode_destalpha", gpu_get_blendmode_destalpha],
		[ "gpu_get_colourwriteenable", gpu_get_colourwriteenable],
		[ "gpu_get_alphatestenable", gpu_get_alphatestenable],
		[ "gpu_get_alphatestref", gpu_get_alphatestref],
		[ "gpu_get_texfilter", gpu_get_texfilter],
		[ "gpu_get_texfilter_ext", gpu_get_texfilter_ext],
		[ "gpu_get_texrepeat", gpu_get_texrepeat],
		[ "gpu_get_texrepeat_ext", gpu_get_texrepeat_ext],

		[ "gpu_set_blendenable", gpu_set_blendenable],
		[ "gpu_set_ztestenable", gpu_set_ztestenable],
		[ "gpu_set_zfunc", gpu_set_zfunc],
		[ "gpu_set_zwriteenable", gpu_set_zwriteenable],
		[ "gpu_set_fog", gpu_set_fog],
		[ "gpu_set_cullmode", gpu_set_cullmode],
		[ "gpu_set_blendmode", gpu_set_blendmode],
		[ "gpu_set_blendmode_ext", gpu_set_blendmode_ext],
		[ "gpu_set_blendmode_ext_sepalpha", gpu_set_blendmode_ext_sepalpha],
		[ "gpu_set_colourwriteenable", gpu_set_colourwriteenable],
		[ "gpu_set_alphatestenable", gpu_set_alphatestenable],
		[ "gpu_set_alphatestref", gpu_set_alphatestref],
		[ "gpu_set_texfilter", gpu_set_texfilter],
		[ "gpu_set_texfilter_ext", gpu_set_texfilter_ext],
		[ "gpu_set_texrepeat", gpu_set_texrepeat],
		[ "gpu_set_texrepeat_ext", gpu_set_texrepeat_ext],

		[ "gpu_push_state", gpu_push_state],
		[ "gpu_pop_state", gpu_pop_state],
		[ "gpu_get_state", gpu_get_state],
		[ "gpu_set_state", gpu_set_state],

		// basic form
		[ "draw_arrow", draw_arrow ],
		[ "draw_circle", draw_circle ],
		[ "draw_circle_colour", draw_circle_colour ],
		[ "draw_ellipse", draw_ellipse ],
		[ "draw_ellipse_colour", draw_ellipse_colour ],
		[ "draw_line", draw_line ],
		[ "draw_line_colour", draw_line_colour ],
		[ "draw_line_width", draw_line_width ],
		[ "draw_line_width_colour", draw_line_width_colour ],
		[ "draw_point", draw_point ],
		[ "draw_point_colour", draw_point_colour ],
		[ "draw_rectangle", draw_rectangle ],
		[ "draw_rectangle_colour", draw_rectangle_colour ],
		[ "draw_roundrect", draw_roundrect ],
		[ "draw_roundrect_colour", draw_roundrect_colour ],
		[ "draw_roundrect_ext", draw_roundrect_ext ],
		[ "draw_roundrect_colour_ext", draw_roundrect_colour_ext ],
		[ "draw_triangle", draw_triangle ],
		[ "draw_triangle_colour", draw_triangle_colour ],

		[ "draw_set_circle_precision", draw_set_circle_precision ],
		[ "draw_button", draw_button ],
		[ "draw_healthbar", draw_healthbar ],
		[ "draw_path", draw_path ],

		//sprite
		[ "draw_self", draw_self ],
		[ "draw_sprite", draw_sprite ],
		[ "draw_sprite_ext", draw_sprite_ext ],
		[ "draw_sprite_general", draw_sprite_general ],
		[ "draw_sprite_part", draw_sprite_part ],
		[ "draw_sprite_part_ext", draw_sprite_part_ext ],
		[ "draw_sprite_stretched", draw_sprite_stretched ],
		[ "draw_sprite_stretched_ext", draw_sprite_stretched_ext ],
		[ "draw_sprite_pos", draw_sprite_pos ],
		[ "draw_sprite_tiled", draw_sprite_tiled ],
		[ "draw_sprite_tiled_ext", draw_sprite_tiled_ext ],

		// text
		[ "draw_set_font", draw_set_font ],
		[ "draw_set_halign", draw_set_halign ],
		[ "draw_set_valign", draw_set_valign ],
		[ "draw_get_font", draw_get_font ],
		[ "draw_get_halign", draw_get_halign ],
		[ "draw_get_valign", draw_get_valign ],
		[ "draw_set_text", draw_set_text ],

		[ "draw_text", draw_text_add ],
		[ "draw_text_ext", draw_text_ext_add ],
		[ "draw_text_colour", draw_text_colour ],
		[ "draw_text_transformed", draw_text_transformed ],
		[ "draw_text_ext_colour", draw_text_ext_colour ],
		[ "draw_text_ext_transformed", draw_text_ext_transformed ],
		[ "draw_text_transformed_colour", draw_text_transformed_colour ],
		[ "draw_text_ext_transformed_colour", draw_text_ext_transformed_colour ],

		//primitive
		[ "draw_primitive_begin", draw_primitive_begin ],
		[ "draw_primitive_begin_texture", draw_primitive_begin_texture ],
		[ "draw_primitive_end", draw_primitive_end ],
		[ "draw_vertex", draw_vertex ],
		[ "draw_vertex_colour", draw_vertex_colour ],
		[ "draw_vertex_texture", draw_vertex_texture ],
		[ "draw_vertex_texture_colour", draw_vertex_texture_colour ],

		[ "vertex_format_begin", vertex_format_begin ],
		[ "vertex_format_add_colour", vertex_format_add_colour ],
		[ "vertex_format_add_position", vertex_format_add_position ],
		[ "vertex_format_add_position_3d", vertex_format_add_position_3d ],
		[ "vertex_format_add_texcoord", vertex_format_add_texcoord ],
		[ "vertex_format_add_normal", vertex_format_add_normal ],
		[ "vertex_format_add_custom", vertex_format_add_custom ],
		[ "vertex_format_end", vertex_format_end ],
		[ "vertex_format_delete", vertex_format_delete ],

		[ "vertex_create_buffer", vertex_create_buffer ],
		[ "vertex_create_buffer_ext", vertex_create_buffer_ext ],
		[ "vertex_create_buffer_from_buffer", vertex_create_buffer_from_buffer ],
		[ "vertex_create_buffer_from_buffer_ext", vertex_create_buffer_from_buffer_ext ],
		[ "vertex_get_buffer_size", vertex_get_buffer_size ],
		[ "vertex_get_number", vertex_get_number ],
		[ "vertex_delete_buffer", vertex_delete_buffer ],
		[ "vertex_begin", vertex_begin ],
		[ "vertex_colour", vertex_colour ],
		[ "vertex_normal", vertex_normal ],
		[ "vertex_position", vertex_position ],
		[ "vertex_position_3d", vertex_position_3d ],
		[ "vertex_argb", vertex_argb ],
		[ "vertex_texcoord", vertex_texcoord ],
		[ "vertex_float1", vertex_float1 ],
		[ "vertex_float2", vertex_float2 ],
		[ "vertex_float3", vertex_float3 ],
		[ "vertex_float4", vertex_float4 ],
		[ "vertex_ubyte4", vertex_ubyte4 ],
		[ "vertex_end", vertex_end ],
		[ "vertex_freeze", vertex_freeze ],
		[ "vertex_submit", vertex_submit ],

		// surface
		[ "surface_exists", surface_exists ],
		[ "surface_create", surface_create ],
		[ "surface_create_ext", surface_create_ext ],
		[ "surface_resize", surface_resize ],
		[ "surface_set_target", surface_set_target ],
		[ "surface_set_target_ext", surface_set_target_ext ],
		[ "surface_get_target", surface_get_target ],
		[ "surface_get_target_ext", surface_get_target_ext ],
		[ "surface_reset_target", surface_reset_target ],
		[ "surface_copy", surface_copy ],
		[ "surface_copy_part", surface_copy_part ],
		[ "surface_depth_disable", surface_depth_disable ],
		[ "surface_get_height", surface_get_height ],
		[ "surface_get_width", surface_get_width ],
		[ "surface_get_texture", surface_get_texture ],
		[ "surface_get_depth_disable", surface_get_depth_disable ],
		[ "surface_getpixel", surface_getpixel ],
		[ "surface_getpixel_ext", surface_getpixel_ext ],
		[ "surface_get_format", surface_get_format ],
		[ "surface_format_is_supported", surface_format_is_supported ],
		[ "surface_free", surface_free ],
		[ "surface_save", surface_save ],
		[ "surface_save_part", surface_save_part ],
		[ "is_surface", is_surface ],

		[ "draw_surface", draw_surface ],
		[ "draw_surface_ext", draw_surface_ext ],
		[ "draw_surface_part", draw_surface_part ],
		[ "draw_surface_part_ext", draw_surface_part_ext ],
		[ "draw_surface_stretched", draw_surface_stretched ],
		[ "draw_surface_stretched_ext", draw_surface_stretched_ext ],
		[ "draw_surface_tiled", draw_surface_tiled ],
		[ "draw_surface_tiled_ext", draw_surface_tiled_ext ],
		[ "draw_surface_general", draw_surface_general ],

		[ "buffer_get_surface", buffer_get_surface ],
		[ "buffer_set_surface", buffer_set_surface ],

		    //variable
		[ "variable_instance_exists", variable_instance_exists ],
		[ "variable_instance_get_names", variable_instance_get_names ],
		[ "variable_instance_names_count", variable_instance_names_count ],
		[ "variable_instance_get", variable_instance_get ],
		[ "variable_instance_set", variable_instance_set ],
		[ "variable_global_exists", variable_global_exists ],
		[ "variable_global_get", variable_global_get ],
		[ "variable_global_set", variable_global_set ],

		[ "method", method ],
		[ "method_get_self", method_get_self ],
		[ "method_get_index", method_get_index ],
		[ "method_call", method_call ],

		[ "variable_struct_exists", variable_struct_exists ],
		[ "variable_struct_get", variable_struct_get ],
		[ "variable_struct_set", variable_struct_set ],
		[ "variable_struct_remove", variable_struct_remove ],
		[ "variable_struct_get_names", variable_struct_get_names ],
		[ "variable_struct_names_count", variable_struct_names_count ],
		[ "is_instanceof", is_instanceof ],
		[ "static_get", static_get ],
		[ "static_set", static_set ],
		[ "instanceof", instanceof ],

		[ "is_string", is_string ],
		[ "is_real", is_real ],
		[ "is_numeric", is_numeric ],
		[ "is_bool", is_bool ],
		[ "is_array", is_array ],
		[ "is_struct", is_struct ],
		[ "is_method", is_method ],
		[ "is_callable", is_callable ],
		[ "is_ptr", is_ptr ],
		[ "is_int32", is_int32 ],
		[ "is_int64", is_int64 ],
		[ "is_undefined", is_undefined ],
		[ "is_nan", is_nan ],
		[ "is_infinity", is_infinity ],
		[ "typeof", typeof ],
		[ "bool", bool ],
		[ "ptr", ptr ],
		[ "int64", int64 ],

		//array
		[ "array_create", array_create ],
		[ "array_copy", array_copy ],
		[ "array_equals", array_equals ],
		[ "array_get", array_get ],
		[ "array_set", array_set ],
		[ "array_push", array_push ],
		[ "array_pop", array_pop ],
		[ "array_insert", array_insert ],
		[ "array_delete", array_delete ],
		[ "array_get_index", array_get_index ],
		[ "array_contains", array_contains ],
		[ "array_contains_ext", array_contains_ext ],
		[ "array_sort", array_sort ],
		[ "array_reverse", array_reverse ],
		[ "array_shuffle", array_shuffle ],
		[ "array_length", array_length ],
		[ "array_resize", array_resize ],
		[ "array_first", array_first ],
		[ "array_last", array_last ],

		[ "array_find_index", array_find_index ],
		[ "array_any", array_any ],
		[ "array_all", array_all ],
		[ "array_foreach", array_foreach ],
		[ "array_reduce", array_reduce ],
		[ "array_concat", array_concat ],
		[ "array_union", array_union ],
		[ "array_intersection", array_intersection ],
		[ "array_filter", array_filter ],
		[ "array_map", array_map ],
		[ "array_unique", array_unique ],
		[ "array_copy_while", array_copy_while ],

		[ "array_create_ext", array_create_ext ],
		[ "array_filter_ext", array_filter_ext ],
		[ "array_map_ext", array_map_ext ],
		[ "array_unique_ext", array_unique_ext ],
		[ "array_reverse_ext", array_reverse_ext ],
		[ "array_shuffle_ext", array_shuffle_ext ],

		//window
		[ "window_center", window_center ],
		[ "window_handle", window_handle ],
		[ "window_get_caption", window_get_caption ],
		[ "window_get_colour", window_get_colour ],
		[ "window_get_fullscreen", window_get_fullscreen ],
		[ "window_get_width", window_get_width ],
		[ "window_get_height", window_get_height ],
		[ "window_get_x", window_get_x ],
		[ "window_get_y", window_get_y ],
		[ "window_get_cursor", window_get_cursor ],
		[ "window_get_visible_rects", window_get_visible_rects ],
		[ "window_mouse_get_x", window_mouse_get_x ],
		[ "window_mouse_get_y", window_mouse_get_y ],
		[ "window_mouse_set", window_mouse_set ],
		[ "window_set_caption", window_set_caption ],
		[ "window_set_colour", window_set_colour ],
		[ "window_set_fullscreen", window_set_fullscreen ],
		[ "window_set_position", window_set_position ],
		[ "window_set_size", window_set_size ],
		[ "window_set_rectangle", window_set_rectangle ],
		[ "window_set_cursor", window_set_cursor ],
		[ "window_set_min_width", window_set_min_width ],
		[ "window_set_max_width", window_set_max_width ],
		[ "window_set_min_height", window_set_min_height ],
		[ "window_set_max_height", window_set_max_height ],
		[ "window_has_focus", window_has_focus ],
		[ "window_device", window_device ],
		[ "window_view_mouse_get_x", window_view_mouse_get_x ],
		[ "window_view_mouse_get_y", window_view_mouse_get_y ],
		[ "window_views_mouse_get_x", window_views_mouse_get_x ],
		[ "window_views_mouse_get_y", window_views_mouse_get_y ],

		//display
		[ "display_reset", display_reset ],
		[ "display_get_width", display_get_width ],
		[ "display_get_height", display_get_height ],
		[ "display_get_orientation", display_get_orientation ],
		[ "display_get_dpi_x", display_get_dpi_x ],
		[ "display_get_dpi_y", display_get_dpi_y ],
		[ "display_get_gui_width", display_get_gui_width ],
		[ "display_get_gui_height", display_get_gui_height ],
		[ "display_get_timing_method", display_get_timing_method ],
		[ "display_get_sleep_margin", display_get_sleep_margin ],
		[ "display_get_frequency", display_get_frequency ],
		[ "display_mouse_get_x", display_mouse_get_x ],
		[ "display_mouse_get_y", display_mouse_get_y ],
		[ "display_mouse_set", display_mouse_set ],
		[ "display_set_gui_size", display_set_gui_size ],
		[ "display_set_gui_maximise", display_set_gui_maximise ],
		[ "display_set_ui_visibility", display_set_ui_visibility ],
		[ "display_set_timing_method", display_set_timing_method ],
		[ "display_set_sleep_margin", display_set_sleep_margin ],

		//keyboard
		[ "io_clear", io_clear ],
		[ "keyboard_check", keyboard_check ],
		[ "keyboard_check_pressed", keyboard_check_pressed ],
		[ "keyboard_check_released", keyboard_check_released ],
		[ "keyboard_check_direct", keyboard_check_direct ],
		[ "keyboard_clear", keyboard_clear ],
		[ "keyboard_set_map", keyboard_set_map ],
		[ "keyboard_get_map", keyboard_get_map ],
		[ "keyboard_unset_map", keyboard_unset_map ],
		[ "keyboard_set_numlock", keyboard_set_numlock ],
		[ "keyboard_get_numlock", keyboard_get_numlock ],

		[ "keyboard_key",		function() { return keyboard_key; } ],
		[ "keyboard_lastkey",	function() { return keyboard_lastkey; } ],
		[ "keyboard_lastchar",	function() { return keyboard_lastchar; } ],
		[ "keyboard_string",	function() { return keyboard_string; } ],

		[ "mouse_button",	function() { return mouse_button; } ],
		[ "mouse_x",		function() { return mouse_x; } ],
		[ "mouse_y",		function() { return mouse_y; } ],
		[ "mouse_check_button", mouse_check_button ],
		[ "mouse_check_button_pressed", mouse_check_button_pressed ],
		[ "mouse_check_button_released", mouse_check_button_released ],
		[ "mouse_clear", mouse_clear ],

		[ "window_mouse_get_x", window_mouse_get_x ],
		[ "window_mouse_get_y", window_mouse_get_y ],
		[ "window_mouse_set", window_mouse_set ],

		[ "gamepad_is_supported", gamepad_is_supported ],
		[ "gamepad_is_connected", gamepad_is_connected ],
		[ "gamepad_get_guid", gamepad_get_guid ],
		[ "gamepad_get_device_count", gamepad_get_device_count ],
		[ "gamepad_get_description", gamepad_get_description ],
		[ "gamepad_get_button_threshold", gamepad_get_button_threshold ],
		[ "gamepad_get_axis_deadzone", gamepad_get_axis_deadzone ],
		[ "gamepad_get_option", gamepad_get_option ],
		[ "gamepad_set_button_threshold", gamepad_set_button_threshold ],
		[ "gamepad_set_axis_deadzone", gamepad_set_axis_deadzone ],
		[ "gamepad_set_vibration", gamepad_set_vibration ],
		[ "gamepad_set_colour", gamepad_set_colour ],
		[ "gamepad_set_option", gamepad_set_option ],
		[ "gamepad_axis_count", gamepad_axis_count ],
		[ "gamepad_axis_value", gamepad_axis_value ],
		[ "gamepad_button_check", gamepad_button_check ],
		[ "gamepad_button_check_pressed", gamepad_button_check_pressed ],
		[ "gamepad_button_check_released", gamepad_button_check_released ],
		[ "gamepad_button_count", gamepad_button_count ],
		[ "gamepad_button_value", gamepad_button_value ],
		[ "gamepad_hat_count", gamepad_hat_count ],
		[ "gamepad_hat_value", gamepad_hat_value ],

		//string
		[ "string", string ],
		[ "string_ext", string_ext ],
		[ "ansi_char", ansi_char ],
		[ "chr", chr ],
		[ "ord", ord ],
		[ "real", real ],
		[ "string_byte_at", string_byte_at ],
		[ "string_byte_length", string_byte_length ],
		[ "string_set_byte_at", string_set_byte_at ],
		[ "string_char_at", string_char_at ],
		[ "string_ord_at", string_ord_at ],
		[ "string_length", string_length ],
		[ "string_pos", string_pos ],
		[ "string_pos_ext", string_pos_ext ],
		[ "string_last_pos", string_last_pos ],
		[ "string_last_pos_ext", string_last_pos_ext ],
		[ "string_starts_with", string_starts_with ],
		[ "string_ends_with", string_ends_with ],
		[ "string_count", string_count ],
		[ "string_copy", string_copy ],
		[ "string_delete", string_delete ],
		[ "string_digits", string_digits ],
		[ "string_format", string_format ],
		[ "string_insert", string_insert ],
		[ "string_letters", string_letters ],
		[ "string_lettersdigits", string_lettersdigits ],
		[ "string_lower", string_lower ],
		[ "string_repeat", string_repeat ],
		[ "string_replace", string_replace ],
		[ "string_replace_all", string_replace_all ],
		[ "string_upper", string_upper ],
		[ "string_hash_to_newline", string_hash_to_newline ],
		[ "string_trim", string_trim ],
		[ "string_trim_start", string_trim_start ],
		[ "string_trim_end", string_trim_end ],
		[ "string_split", string_split ],
		[ "string_split_ext", string_split_ext ],
		[ "string_join", string_join ],
		[ "string_join_ext", string_join_ext ],
		[ "string_concat", string_concat ],
		[ "string_concat_ext", string_concat_ext ],
		[ "string_width", string_width ],
		[ "string_width_ext", string_width_ext ],
		[ "string_height", string_height ],
		[ "string_height_ext", string_height_ext ],
		[ "string_foreach", string_foreach ],

		//date time
		[ "date_set_timezone", date_set_timezone ],
		[ "date_get_timezone", date_get_timezone ],

		[ "current_time",	 function() { return current_time } ],
		[ "current_second",  function() { return current_second } ],
		[ "current_minute",  function() { return current_minute } ],
		[ "current_hour",	 function() { return current_hour } ],
		[ "current_day",	 function() { return current_day } ],
		[ "current_weekday", function() { return current_weekday } ],
		[ "current_month",	 function() { return current_month } ],
		[ "current_year",	 function() { return current_year } ],

		[ "date_create_datetime", date_create_datetime ],
		[ "date_current_datetime", date_current_datetime ],
		[ "date_compare_date", date_compare_date ],
		[ "date_compare_datetime", date_compare_datetime ],
		[ "date_compare_time", date_compare_time ],
		[ "date_valid_datetime", date_valid_datetime ],
		[ "date_date_of", date_date_of ],
		[ "date_time_of", date_time_of ],
		[ "date_is_today", date_is_today ],
		[ "date_leap_year", date_leap_year ],
		[ "date_date_string", date_date_string ],
		[ "date_datetime_string", date_datetime_string ],
		[ "date_time_string", date_time_string ],
		[ "date_second_span", date_second_span ],
		[ "date_minute_span", date_minute_span ],
		[ "date_hour_span", date_hour_span ],
		[ "date_day_span", date_day_span ],
		[ "date_week_span", date_week_span ],
		[ "date_month_span", date_month_span ],
		[ "date_year_span", date_year_span ],
		[ "date_days_in_month", date_days_in_month ],
		[ "date_days_in_year", date_days_in_year ],
		[ "date_get_second", date_get_second ],
		[ "date_get_minute", date_get_minute ],
		[ "date_get_hour", date_get_hour ],
		[ "date_get_day", date_get_day ],
		[ "date_get_weekday", date_get_weekday ],
		[ "date_get_week", date_get_week ],
		[ "date_get_month", date_get_month ],
		[ "date_get_year", date_get_year ],
		[ "date_get_second_of_year", date_get_second_of_year ],
		[ "date_get_minute_of_year", date_get_minute_of_year ],
		[ "date_get_hour_of_year", date_get_hour_of_year ],
		[ "date_get_day_of_year", date_get_day_of_year ],
		[ "date_inc_second", date_inc_second ],
		[ "date_inc_minute", date_inc_minute ],
		[ "date_inc_hour", date_inc_hour ],
		[ "date_inc_day", date_inc_day ],
		[ "date_inc_week", date_inc_week ],
		[ "date_inc_month", date_inc_month ],
		[ "date_inc_year", date_inc_year ],

		[ "get_timer", get_timer ],
		[ "delta_time", function() { return delta_time } ],

		//number
		[ "choose", choose ], 
		[ "random", random ], 
		[ "random_range", random_range ], 
		[ "irandom", irandom ], 
		[ "irandom_range", irandom_range ], 
		[ "random_set_seed", random_set_seed ], 
		[ "random_get_seed", random_get_seed ], 
		[ "randomise", randomise ], 

		[ "round", round ], 
		[ "floor", floor ], 
		[ "frac", frac ], 
		[ "abs", abs ], 
		[ "sign", sign ], 
		[ "ceil", ceil ], 
		[ "max", max ], 
		[ "mean", mean ], 
		[ "median", median ], 
		[ "min", min ], 
		[ "lerp", lerp ], 
		[ "clamp", clamp ], 

		[ "exp", exp ], 
		[ "ln", ln ], 
		[ "power", power ], 
		[ "sqr", sqr ], 
		[ "sqrt", sqrt ], 
		[ "log2", log2 ], 
		[ "log10", log10 ], 
		[ "logn", logn ], 

		[ "arccos", arccos ],
		[ "arcsin", arcsin ],
		[ "arctan", arctan ],
		[ "arctan2", arctan2 ],
		[ "cos", cos ],
		[ "sin", sin ],
		[ "tan", tan ],
		[ "dcos", dcos ],
		[ "dsin", dsin ],
		[ "dtan", dtan ],
		[ "darccos", darccos ],
		[ "darcsin", darcsin ],
		[ "darctan", darctan ],
		[ "darctan2", darctan2 ],
		[ "degtorad", degtorad ],
		[ "radtodeg", radtodeg ],

		[ "point_direction", point_direction ],
		[ "point_distance", point_distance ],
		[ "point_distance_3d", point_distance_3d ],
		[ "distance_to_object", distance_to_object ],
		[ "distance_to_point", distance_to_point ],
		[ "dot_product", dot_product ],
		[ "dot_product_3d", dot_product_3d ],
		[ "dot_product_normalised", dot_product_normalised ],
		[ "dot_product_3d_normalised", dot_product_3d_normalised ],
		[ "angle_difference", angle_difference ],
		[ "lengthdir_x", lengthdir_x ],
		[ "lengthdir_y", lengthdir_y ],

		[ "matrix_get", matrix_get ],
		[ "matrix_set", matrix_set ],
		[ "matrix_build", matrix_build ],
		[ "matrix_multiply", matrix_multiply ],
		[ "matrix_build_identity", matrix_build_identity ],
		[ "matrix_build_lookat", matrix_build_lookat ],
		[ "matrix_build_projection_ortho", matrix_build_projection_ortho ],
		[ "matrix_build_projection_perspective", matrix_build_projection_perspective ],
		[ "matrix_build_projection_perspective_fov", matrix_build_projection_perspective_fov ],
		[ "matrix_transform_vertex", matrix_transform_vertex ],

		[ "matrix_stack_is_empty", matrix_stack_is_empty ],
		[ "matrix_stack_clear", matrix_stack_clear ],
		[ "matrix_stack_set", matrix_stack_set ],
		[ "matrix_stack_push", matrix_stack_push ],
		[ "matrix_stack_pop", matrix_stack_pop ],
		[ "matrix_stack_top", matrix_stack_top ],

		//file
		[ "file_exists", file_exists ],
		[ "file_delete", file_delete ],
		[ "file_rename", file_rename ],
		[ "file_copy", file_copy ],
		[ "file_find_first", file_find_first ],
		[ "file_find_next", file_find_next ],
		[ "file_find_close", file_find_close ],
		[ "file_attributes", file_attributes ],

		[ "filename_name", filename_name ],
		[ "filename_path", filename_path ],
		[ "filename_dir", filename_dir ],
		[ "filename_drive", filename_drive ],
		[ "filename_ext", filename_ext ],
		[ "filename_change_ext", filename_change_ext ],

		[ "get_open_filename", get_open_filename ],
		[ "get_open_filename_ext", get_open_filename_ext ],
		[ "get_save_filename", get_save_filename ],
		[ "get_save_filename_ext", get_save_filename_ext ],

		[ "ini_open", ini_open ],
		[ "ini_close", ini_close ],
		[ "ini_write_real", ini_write_real ],
		[ "ini_write_string", ini_write_string ],
		[ "ini_read_real", ini_read_real ],
		[ "ini_read_string", ini_read_string ],
		[ "ini_key_exists", ini_key_exists ],
		[ "ini_section_exists", ini_section_exists ],
		[ "ini_key_delete", ini_key_delete ],
		[ "ini_section_delete", ini_section_delete ],
		[ "ini_open_from_string", ini_open_from_string ],

		[ "file_text_open_read", file_text_open_read ],
		[ "file_text_open_write", file_text_open_write ],
		[ "file_text_open_append", file_text_open_append ],
		[ "file_text_open_from_string", file_text_open_from_string ],
		[ "file_text_read_real", file_text_read_real ],
		[ "file_text_read_string", file_text_read_string ],
		[ "file_text_readln", file_text_readln ],
		[ "file_text_write_real", file_text_write_real ],
		[ "file_text_write_string", file_text_write_string ],
		[ "file_text_writeln", file_text_writeln ],
		[ "file_text_eoln", file_text_eoln ],
		[ "file_text_eof", file_text_eof ],
		[ "file_text_close", file_text_close ],

		[ "file_bin_open", file_bin_open ],
		[ "file_bin_rewrite", file_bin_rewrite ],
		[ "file_bin_close", file_bin_close ],
		[ "file_bin_size", file_bin_size ],
		[ "file_bin_position", file_bin_position ],
		[ "file_bin_seek", file_bin_seek ],
		[ "file_bin_write_byte", file_bin_write_byte ],
		[ "file_bin_read_byte", file_bin_read_byte ],

		[ "directory_exists", directory_exists ],
		[ "directory_create", directory_create ],
		[ "directory_destroy", directory_destroy ],
		[ "temp_directory",    function() { return temp_directory } ],
		[ "working_directory", function() { return working_directory } ],
		[ "program_directory", function() { return program_directory } ],

		[ "json_encode", json_encode ],
		[ "json_decode", json_decode ],
		[ "json_stringify", json_stringify ],
		[ "json_parse", json_parse ],

		//buffer
		[ "buffer_exists", buffer_exists ],
		[ "buffer_create", buffer_create ],
		[ "buffer_create_from_vertex_buffer", buffer_create_from_vertex_buffer ],
		[ "buffer_create_from_vertex_buffer_ext", buffer_create_from_vertex_buffer_ext ],
		[ "buffer_delete", buffer_delete ],
		[ "buffer_read", buffer_read ],
		[ "buffer_write", buffer_write ],
		[ "buffer_fill", buffer_fill ],
		[ "buffer_seek", buffer_seek ],
		[ "buffer_tell", buffer_tell ],
		[ "buffer_peek", buffer_peek ],
		[ "buffer_poke", buffer_poke ],
		[ "buffer_save", buffer_save ],
		[ "buffer_save_ext", buffer_save_ext ],
		[ "buffer_save_async", buffer_save_async ],
		[ "buffer_load", buffer_load ],
		[ "buffer_load_ext", buffer_load_ext ],
		[ "buffer_load_async", buffer_load_async ],
		[ "buffer_load_partial", buffer_load_partial ],
		[ "buffer_compress", buffer_compress ],
		[ "buffer_decompress", buffer_decompress ],
		[ "buffer_async_group_begin", buffer_async_group_begin ],
		[ "buffer_async_group_option", buffer_async_group_option ],
		[ "buffer_async_group_end", buffer_async_group_end ],
		[ "buffer_copy", buffer_copy ],
		[ "buffer_copy_from_vertex_buffer", buffer_copy_from_vertex_buffer ],
		[ "buffer_get_type", buffer_get_type ],
		[ "buffer_get_alignment", buffer_get_alignment ],
		[ "buffer_get_address", buffer_get_address ],
		[ "buffer_get_size", buffer_get_size ],
		[ "buffer_get_surface", buffer_get_surface ],
		[ "buffer_set_surface", buffer_set_surface ],
		[ "buffer_resize", buffer_resize ],
		[ "buffer_sizeof", buffer_sizeof ],
		[ "buffer_md5", buffer_md5 ],
		[ "buffer_sha1", buffer_sha1 ],
		[ "buffer_crc32", buffer_crc32 ],
		[ "buffer_base64_encode", buffer_base64_encode ],
		[ "buffer_base64_decode", buffer_base64_decode ],
		[ "buffer_base64_decode_ext", buffer_base64_decode_ext ],
		[ "buffer_set_used_size", buffer_set_used_size ],

		//os
		[ "os_browser", function() { return os_browser } ],
		[ "os_device",	function() { return os_device } ],
		[ "os_type",	function() { return os_type } ],
		[ "os_version", function() { return os_version } ],
		[ "os_is_paused", os_is_paused ],
		[ "os_is_network_connected", os_is_network_connected ],
		[ "os_get_config", os_get_config ],
		[ "os_get_language", os_get_language ],
		[ "os_get_region", os_get_region ],
		[ "os_get_info", os_get_info ],
		[ "os_powersave_enable", os_powersave_enable ],
		[ "os_lock_orientation", os_lock_orientation ],
		[ "os_check_permission", os_check_permission ],
		[ "os_request_permission", os_request_permission ],

		//debug
		[ "print", print ],
		[ "noti_error", noti_error ],
		[ "noti_warning", noti_warning ],
		
		//panel
		[ "panel_get", function(type) {
			switch(type) {
				case "animation" :	return PANEL_ANIMATION; 
				case "collection" : return PANEL_COLLECTION; 
				case "graph" :		return PANEL_GRAPH; 
				case "inspector" :	return PANEL_INSPECTOR; 
				case "main" :		return PANEL_MAIN; 
			}
		} ],
		
		[ "draw_text_set_format",	function(ind) { 
			switch(ind) {
				case 0 : draw_set_font(f_h3);  draw_set_color(COLORS._main_text); break;
				case 1 : draw_set_font(f_p0);  draw_set_color(COLORS._main_text); break;
				case 2 : draw_set_font(f_p1);  draw_set_color(COLORS._main_text_sub); break;
				case 3 : draw_set_font(f_p2);  draw_set_color(COLORS._main_text_sub); break;
				case 4 : draw_set_font(f_p3);  draw_set_color(COLORS._main_text_sub); break;
			}
		}], 
		
		//nodes
		[ "node_get",	function(nodeId) { 
			if(!ds_map_exists(NODE_NAME_MAP, nodeId)) return 0;
			return NODE_NAME_MAP[? nodeId];
		}], 
		
		[ "node_get_input_value", function(nodeId, input) { 
			if(!ds_map_exists(NODE_NAME_MAP, nodeId)) return 0;
			var node = NODE_NAME_MAP[? nodeId];
			
			if(!ds_map_exists(node.inputMap, input)) return 0;
			return node.inputMap[? input].getValue();
		}], 
		
		[ "node_set_input_value", function(nodeId, input, value) { 
			if(!ds_map_exists(NODE_NAME_MAP, nodeId)) return 0;
			var node = NODE_NAME_MAP[? nodeId];
			
			if(!ds_map_exists(node.inputMap, input)) return 0;
			return node.inputMap[? input].setValue(value);
		}], 
		
		[ "node_get_output_value", function(nodeId, input) { 
			if(!ds_map_exists(NODE_NAME_MAP, nodeId)) return 0;
			var node = NODE_NAME_MAP[? nodeId];
			
			if(!ds_map_exists(node.outputMap, input)) return 0;
			return node.outputMap[? input].getValue();
		}],
		
		[ "get_hovering_element", function() { return HOVERING_ELEMENT; }],
	];
#endregion

#region widget manager
	global.__lua_widget_functions = [
		[ "__widget_wake",   function(wd, hover, focus) { 
			if(!ds_map_exists(global.ADDON_WIDGET, wd)) return;
			
			global.ADDON_WIDGET[? wd].setActiveFocus(focus, hover);
		} ],
		
		[ "__textBox",   function(type, onModify) { 
			var wd  = new textBox(type, onModify);
			var key = UUID_generate();
			global.ADDON_WIDGET[? key] = wd;
			
			return key;
		} ],
		
		[ "__textBox_draw",   function(wd, _x, _y, _w, _h, _text, _m) { 
			if(!ds_map_exists(global.ADDON_WIDGET, wd)) return;
			
			global.ADDON_WIDGET[? wd].draw(_x, _y, _w, _h, _text, _m);
		} ],
		
		[ "__textBox_apply",   function(wd) { 
			if(!ds_map_exists(global.ADDON_WIDGET, wd)) return;
			
			global.ADDON_WIDGET[? wd].apply();
			return global.ADDON_WIDGET[? wd].current_value;
		} ],
		
@"
TextBox = {}
TextBox.new = function(type, onModify) 
	local self = {}
	
	self.id = __textBox(type, onModify)
	
	function self.draw(self, _x, _y, _w, _h, _text) 
		__widget_wake(self.id, Panel.hoverable, Panel.clickable)
		__textBox_draw(self.id, _x, _y, _w, _h, _text, Panel.mouse)
		
		if(keyboard_check_pressed(vk_enter) == 1) then
			onModify(__textBox_apply(self.id))
		end
	end
	
	return self
end",
		
		[ "__vectorBox",   function(size, onModify) { 
			var wd  = new vectorBox(size, onModify);
			var key = UUID_generate();
			global.ADDON_WIDGET[? key] = wd;
			
			return key;
		} ],
		
		[ "__vectorBox_draw",   function(wd, _x, _y, _w, _h, _vector, _m) { 
			if(!ds_map_exists(global.ADDON_WIDGET, wd)) return;
			
			global.ADDON_WIDGET[? wd].draw(_x, _y, _w, _h, _vector, _m);
		} ],
		
		[ "__vectorBox_apply",   function(wd) { 
			if(!ds_map_exists(global.ADDON_WIDGET, wd)) return;
			
			global.ADDON_WIDGET[? wd].apply();
			return global.ADDON_WIDGET[? wd].current_value;
		} ],

@"
VectorBox = {}
VectorBox.new = function(size, onModify) 
	local self = {}
	
	self.id = __vectorBox(size, onModify)
	
	function self.draw(self, _x, _y, _w, _h, _vector) 
		__widget_wake(self.id, Panel.hoverable, Panel.clickable)
		__vectorBox_draw(self.id, _x, _y, _w, _h, _vector, Panel.mouse)
		
		if(keyboard_check_pressed(vk_enter) == 1) then
			onModify(__vectorBox_apply(self.id))
		end
	end
	
	return self
end",

		[ "__checkBox",   function(onModify) { 
			var wd  = new checkBox(onModify);
			var key = UUID_generate();
			global.ADDON_WIDGET[? key] = wd;
			
			return key;
		} ],
		
		[ "__checkBox_draw",   function(wd, _x, _y, _value, _m) { 
			if(!ds_map_exists(global.ADDON_WIDGET, wd)) return;
			
			global.ADDON_WIDGET[? wd].draw(_x, _y, _value);
		} ],
		
		[ "__checkBox_apply",   function(wd) { 
			if(!ds_map_exists(global.ADDON_WIDGET, wd)) return;
			
			global.ADDON_WIDGET[? wd].trigger();
			return true;
		} ],
		
		[ "__checkBox_trigger",   function(wd) { 
			if(!ds_map_exists(global.ADDON_WIDGET, wd)) return;
			
			return global.ADDON_WIDGET[? wd].isTriggered();
		} ],

@"
CheckBox = {}
CheckBox.new = function(onModify) 
	local self = {}
	
	self.id = __checkBox(onModify)
	
	function self.draw(self, _x, _y, _value) 
		__widget_wake(self.id, Panel.hoverable, Panel.clickable)
		__checkBox_draw(self.id, _x, _y, _value, Panel.mouse)
		
		if(__checkBox_trigger()) then
			__checkBox_apply(self.id)
			onModify()
		end
	end
	
	return self
end",

		[ "__button",   function(onModify, txt = "") { 
			var wd  = new button(onModify).setText(txt);
			var key = UUID_generate();
			global.ADDON_WIDGET[? key] = wd;
			
			return key;
		} ],

		[ "__button_draw",   function(wd, _x, _y, _w, _h, _m) { 
			if(!ds_map_exists(global.ADDON_WIDGET, wd)) return;
			
			global.ADDON_WIDGET[? wd].draw(_x, _y, _w, _h);
		} ],
		
		[ "__button_apply",   function(wd) { 
			if(!ds_map_exists(global.ADDON_WIDGET, wd)) return;
			
			global.ADDON_WIDGET[? wd].trigger();
			return true;
		} ],
		
		[ "__button_trigger",   function(wd) { 
			if(!ds_map_exists(global.ADDON_WIDGET, wd)) return;
			
			return global.ADDON_WIDGET[? wd].isTriggered();
		} ],

@"
Button = {}
Button.new = function(onModify, txt) 
	local self = {}
	
	self.id = __button(onModify, txt)
	
	function self.draw(self, _x, _y, _w, _h) 
		__widget_wake(self.id, Panel.hoverable, Panel.clickable)
		__button_draw(self.id, _x, _y, _w, _h, Panel.mouse)
		
		if(__button_trigger()) then
			__button_apply(self.id)
			onModify()
		end
	end
	
	return self
end",

		[ "__button_color",   function(onModify, txt = "") { 
			var wd  = new button(onModify).setText(txt);
			var key = UUID_generate();
			global.ADDON_WIDGET[? key] = wd;
			
			return key;
		} ],

		[ "__button_color_draw",   function(wd, _x, _y, _w, _h, _value, _m) { 
			if(!ds_map_exists(global.ADDON_WIDGET, wd)) return;
			
			global.ADDON_WIDGET[? wd].draw(_x, _y, _w, _h, _value);
		} ],
		
		[ "__button_color_apply",   function(wd) { 
			if(!ds_map_exists(global.ADDON_WIDGET, wd)) return;
			
			global.ADDON_WIDGET[? wd].trigger();
			return global.ADDON_WIDGET[? wd].current_value;
		} ],
		
		[ "__button_color_trigger",   function(wd) { 
			if(!ds_map_exists(global.ADDON_WIDGET, wd)) return;
			
			return global.ADDON_WIDGET[? wd].isTriggered();
		} ],

@"
ButtonColor = {}
ButtonColor.new = function(onModify, txt) 
	local self = {}
	
	self.id = __button_color(onModify, txt)
	
	function self.draw(self, _x, _y, _w, _h, _value) 
		__widget_wake(self.id, Panel.hoverable, Panel.clickable)
		__button_color_draw(self.id, _x, _y, _w, _h, _value, Panel.mouse)
		
		if(__button_color_trigger()) then
			onModify(__button_color_apply(self.id))
		end
	end
	
	return self
end",

	];
	
	function __addon_lua_setup_widget(lua, context) {
		for( var i = 0; i < array_length(global.__lua_widget_functions); i++ ) {
			var _func = global.__lua_widget_functions[i];
			if(is_string(_func)) {
				lua_add_code(lua, _func);
			} else if(is_array(_func))
				lua_add_function(lua, _func[0], _func[1]);
		}
	}
#endregion