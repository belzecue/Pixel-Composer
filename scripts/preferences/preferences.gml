#region preference
	globalvar PREFERENCES, PREFERENCES_DEF, HOTKEYS_DATA, PREFERENCES_DIR;
	PREFERENCES  = {};
	HOTKEYS_DATA = {};
	
	#region ////////////////////////////////////////////////////////////////////// GENERAL UI //////////////////////////////////////////////////////////////////////
												
		PREFERENCES.display_scaling					= 1;
		PREFERENCES.window_width					= 1600;
		PREFERENCES.window_height					= 800;
		PREFERENCES.window_maximize					= false;
		PREFERENCES.window_monitor					= "";
		PREFERENCES.window_fix					    = false;
		PREFERENCES.window_fix_width				= 1600;
		PREFERENCES.window_fix_height				= 800;
		
		PREFERENCES.theme							= "default";
		PREFERENCES.local							= "en";
		PREFERENCES.font_overwrite					= "";
		
		PREFERENCES.ui_framerate					= 120;
		PREFERENCES.ui_framerate_non_focus			= 10;
		PREFERENCES.path_resolution					= 32;
		PREFERENCES.move_directory					= false;
		
		PREFERENCES.notification_time				= 180;
		PREFERENCES.notify_load_version				= true;
		PREFERENCES.show_crash_dialog				= false;
		
		PREFERENCES.test_mode						= false;
		PREFERENCES.auto_save_time					= 300;
		PREFERENCES.use_legacy_exception			= false;
	
		PREFERENCES.caret_blink						= 0.75;
	
		PREFERENCES.textbox_shake					= 0;
		PREFERENCES.textbox_particle				= 0;
	
	#endregion
			
	#region ////////////////////////////////////////////////////////////////////////// IO //////////////////////////////////////////////////////////////////////////
				
		PREFERENCES.double_click_delay				= 0.25;
		PREFERENCES.mouse_wheel_speed				= 1.00;
		
		PREFERENCES.pen_pool_delay					= 1;
		PREFERENCES.slider_lock_mouse				= true;
		
		PREFERENCES.keyboard_repeat_start			= 0.50;
		PREFERENCES.keyboard_repeat_speed			= 0.10;
		PREFERENCES.keyboard_double_delay			= 0.25;
		
	#endregion
	
	#region ///////////////////////////////////////////////////////////////////////// DIALOG ////////////////////////////////////////////////////////////////////////
		
		PREFERENCES.node_recents_amount				= 20;
			
		PREFERENCES.show_splash						= true;
		PREFERENCES.splash_expand_recent			= false;
	
		PREFERENCES.dialog_add_node_grouping		= true;
		PREFERENCES.dialog_add_node_view			= 0;
	
		PREFERENCES.dialog_add_node_w				= 532;
		PREFERENCES.dialog_add_node_h				= 400;
		PREFERENCES.dialog_add_node_search_high		= true;
		
		PREFERENCES.add_node_remember				= true;
		
		PREFERENCES.file_explorer_view				= FILE_EXPLORER_VIEW.list;
	
	#endregion
	
	#region //////////////////////////////////////////////////////////////////////// PANEL /////////////////////////////////////////////////////////////////////////
	
		PREFERENCES.panel_layout_file				= "Vertical";
	
		PREFERENCES.panel_graph_dragging			= MOD_KEY.alt;
		PREFERENCES.panel_graph_group_require_shift	= true;
	
		PREFERENCES.panel_preview_dragging			= MOD_KEY.alt;
		PREFERENCES.panel_preview_show_real_fps		= false;
		// PREFERENCES.panel_preview_tran_colors		= [  ];
	
		PREFERENCES.panel_menu_resource_monitor		= false;
		PREFERENCES.panel_menu_right_control		= os_type == os_windows;
	
		PREFERENCES.panel_menu_palette_node_size    = 20;
	
		PREFERENCES.inspector_focus_on_double_click	= true;
		PREFERENCES.inspector_view_default			= 1;
	
		PREFERENCES.node_show_render_status			= false;
		PREFERENCES.node_show_time					= true;
		
		PREFERENCES.expand_hover					= false;
	
		PREFERENCES.graph_zoom_smoooth				= 4;
		PREFERENCES.graph_open_group_in_tab			= false;
	
		PREFERENCES.connection_line_width			= 2;
		PREFERENCES.connection_line_sample			= 1;
		PREFERENCES.connection_line_corner			= 8;
		PREFERENCES.connection_line_aa				= 2;
		PREFERENCES.connection_line_transition		= true;
		PREFERENCES.connection_line_highlight		= 0;
		PREFERENCES.connection_line_highlight_fade	= 0.75;
		PREFERENCES.connection_line_highlight_all	= false;
		PREFERENCES.curve_connection_line			= 1;
		
		PREFERENCES.collection_animated				= true;
		PREFERENCES.collection_preview_speed		= 60;
		PREFERENCES.collection_scale				= 1;
		
		PREFERENCES.palette_stretch				    = false;
		
		PREFERENCES.pan_mouse_key					= mb_middle;
	#endregion
	
	#region //////////////////////////////////////////////////////////////////////// WIDGET ////////////////////////////////////////////////////////////////////////
	
		PREFERENCES.widget_autocomplete_delay       = 500;
		PREFERENCES.alt_picker						= true;
	
	#endregion
	
	#region //////////////////////////////////////////////////////////////////////// NODES /////////////////////////////////////////////////////////////////////////
	
		PREFERENCES.node_param_show					= false;
		PREFERENCES.node_param_width				= 192;
		PREFERENCES.node_3d_preview_size			= 256;
	
	#endregion
	
	#region //////////////////////////////////////////////////////////////////////// SAVE //////////////////////////////////////////////////////////////////////////
	
		PREFERENCES.save_file_minify				= true;
		PREFERENCES.save_backup						= 1;
		PREFERENCES.save_layout						= false;
	
	#endregion
	
	
	#region //////////////////////////////////////////////////////////////////////// MISC //////////////////////////////////////////////////////////////////////////
		
		PREFERENCES.render_all_export				= true;
		PREFERENCES.clear_temp_on_close				= true;
	
		PREFERENCES.show_supporter_icon				= true;
		PREFERENCES.welcome_file_order				= [ "Getting started", "Sample Projects" ];
		PREFERENCES.welcome_file_closed				= [];
	
	#endregion
	
	#region //////////////////////////////////////////////////////////////////////// PATHS /////////////////////////////////////////////////////////////////////////
	
		PREFERENCES.temp_path			= "%DIR%/temp/";
		PREFERENCES.ImageMagick_path	= "%APP%/imagemagick/";
		PREFERENCES.webp_path			= "%APP%/webp/";
		PREFERENCES.gifski_path			= "%APP%/gifski/";
		PREFERENCES.ffmpeg_path			= "%APP%/ffmpeg/";
		
		PREFERENCES.file_explorer       = "";
		PREFERENCES.dialog_path         = "";
		
		PREFERENCES.path_assets         = [];
		PREFERENCES.path_fonts          = [];
		
		PREFERENCES.versions			= {};
	
	#endregion
	
	PREFERENCES_DEF = variable_clone(PREFERENCES);
#endregion

#region project attributes
	globalvar PROJECT_ATTRIBUTES;
	
	PROJECT_ATTRIBUTES = {}
	
	PROJECT_ATTRIBUTES.strict            = false;
	PROJECT_ATTRIBUTES.surface_dimension = [ 32, 32 ];
	PROJECT_ATTRIBUTES.palette           = [ cola(c_white), cola(c_black) ];
	PROJECT_ATTRIBUTES.palette_fix       = false;
#endregion

#region recent files
	globalvar RECENT_FILES, RECENT_FILE_DATA;
	RECENT_FILES	 = ds_list_create();
	RECENT_FILE_DATA = ds_list_create();
	
	function RECENT_SAVE() {
		var map = ds_map_create();
		var l   = ds_list_create();
		ds_list_copy(l, RECENT_FILES);
		ds_map_add_list(map, "Recents", l);
		
		var path = DIRECTORY + "recent.json";
		var file = file_text_open_write(path);
		file_text_write_string(file, json_encode_minify(map));
		file_text_close(file);
		ds_map_destroy(map);
	}
	
	function RECENT_LOAD() {
		var path = DIRECTORY + "recent.json";
		if(!file_exists_empty(path)) return;
		
		var file = file_text_open_read(path);
		var load_str = "";
		while(!file_text_eof(file)) {
			load_str += file_text_readln(file);
		}
		file_text_close(file);
		var map = json_decode(load_str);
		
		if(ds_map_exists(map, "Recents")) {
			var l = map[? "Recents"];
			ds_list_clear(RECENT_FILES);
			
			for(var i = 0; i < ds_list_size(l); i++) {
				if(!file_exists_empty(l[| i])) continue;
				ds_list_add(RECENT_FILES, l[| i]);
			}
		}
		
		RECENT_REFRESH();
	}
	
	function RECENT_REFRESH() {
		for( var i = 0; i < ds_list_size(RECENT_FILE_DATA); i++ ) {
			var d = RECENT_FILE_DATA[| i];
			if(sprite_exists(d.spr)) sprite_delete(d.spr);
			if(surface_exists(d.thumbnail)) surface_free(d.thumbnail);
		}
		
		ds_list_clear(RECENT_FILE_DATA);
		
		for( var i = 0; i < ds_list_size(RECENT_FILES); i++ ) {
			var p = RECENT_FILES[| i];
			RECENT_FILE_DATA[| i] = new FileObject(filename_name_only(p), p);
		}
	}
#endregion

#region save load
	globalvar PREF_VERSION, PREF_UPDATES;
	PREF_VERSION = 1_17_1;
	PREF_UPDATES = [
		{
			version: 0,
			exists: function() /*=>*/  {return file_exists(DIRECTORY + "keys.json")},
			update: function() /*=>*/ {
				var _pth_k = DIRECTORY + "keys.json";
				var _pth_h = DIRECTORY + "hotkeys.json";
				var _pth_d = DIRECTORY + "default_project.json";
				
				if(file_exists(_pth_k)) file_copy(_pth_k, PREFERENCES_DIR + "keys.json");
				if(file_exists(_pth_h)) file_copy(_pth_h, PREFERENCES_DIR + "hotkeys.json");
				if(file_exists(_pth_d)) file_copy(_pth_d, PREFERENCES_DIR + "default_project.json");
			}
		}
	];
	
	function PREF_UPDATE() {
		directory_verify(PREFERENCES_DIR);
		var _oldest = -1;
		
		for (var i = 0, n = array_length(PREF_UPDATES); i < n; i++) {
			var _pf = PREF_UPDATES[i];
			if(_pf.exists()) {
				_oldest = i;
				break;
			}
		}
		
		if(_oldest == -1) return;
		for(var i = _oldest; i >= 0; i--) {
			var _pf = PREF_UPDATES[i];
			_pf.update();
		}
	}
	
	function PREF_SAVE() {
		if(IS_CMD) return;
		
		directory_verify($"{DIRECTORY}Preferences");
		directory_verify($"{DIRECTORY}Preferences/{PREF_VERSION}");
		
		PREFERENCES.window_maximize	= window_is_maximized;
		PREFERENCES.window_width	= max(960, window_minimize_size[0]);
		PREFERENCES.window_height	= max(600, window_minimize_size[1]);
		PREFERENCES.window_monitor  = window_monitor;
		
		json_save_struct(PREFERENCES_DIR + "keys.json",             PREFERENCES);
		json_save_struct(PREFERENCES_DIR + "default_project.json",  PROJECT_ATTRIBUTES);
		json_save_struct(DIRECTORY + "Nodes/fav.json",              global.FAV_NODES);
		json_save_struct(DIRECTORY + "Nodes/recent.json",           global.RECENT_NODES);
		
		hotkey_serialize();
	}
	
	function PREF_LOAD() {
		directory_verify($"{DIRECTORY}Preferences");
		if(!directory_exists(PREFERENCES_DIR)) PREF_UPDATE();
		
		var path = PREFERENCES_DIR + "keys.json";
		if(file_exists(path)) {
			var map = json_load_struct(path);
			if(struct_has(map, "preferences")) struct_override(PREFERENCES, map.preferences);
			else                               struct_override(PREFERENCES, map);
		}
		
		if(!directory_exists($"{DIRECTORY}Themes/{PREFERENCES.theme}"))
			PREFERENCES.theme = "default";
			
		LOCALE_DEF = PREFERENCES.local == "en";
		THEME_DEF  = PREFERENCES.theme == "default";
		FONT_DEF   = PREFERENCES.theme == "default" && PREFERENCES.local == "en" && PREFERENCES.display_scaling == 1;
		
		directory_verify(filepath_resolve(PREFERENCES.temp_path));
		
		if(PREFERENCES.move_directory) directory_set_current_working(DIRECTORY);
		
		var f = json_load_struct(PREFERENCES_DIR + "default_project.json");
		struct_override(PROJECT_ATTRIBUTES, f);
		
		hotkey_deserialize();
	}
	
	function PREF_APPLY() {
		if(PREFERENCES.double_click_delay > 1)
			PREFERENCES.double_click_delay /= 60;
		
		TESTING = struct_try_get(PREFERENCES, "test_mode", false);
		if(TESTING && GM_build_type == "run") {
			log_message("PREFERENCE", "Test mode enabled");
			instance_create_depth(0, 0, 0, addon_key_displayer);
		}
		
		if(PREFERENCES.use_legacy_exception) resetException();
		else                                 setException();
		
		var ww = PREFERENCES.window_fix? PREFERENCES.window_fix_width : PREFERENCES.window_width;
		var hh = PREFERENCES.window_fix? PREFERENCES.window_fix_height : PREFERENCES.window_height;
		window_minimize_size = [ ww, hh ];
		
		if(OS == os_macosx) {
			
			window_set_rectangle(display_get_width() / 2 - ww / 2, display_get_height() / 2 - hh / 2, ww, hh);
			
			if(PREFERENCES.window_maximize)
				winMan_Maximize();
				
		} else if(!LOADING) {
			var _monitors = display_measure_all();
			var _monitor  = noone;
			
			if(is_array(_monitors))
			for( var i = 0, n = array_length(_monitors); i < n; i++ ) {
				var _m = _monitors[i];
				if(!is_array(_m) || array_length(_m) < 10) continue;
				
				if(PREFERENCES.window_monitor == _m[9]) 
					_monitor = _m;
			}
			
			if(is_array(_monitor) && array_length(_monitor) >= 8)
				window_set_rectangle(_monitor[0] + _monitor[2] / 2 - ww / 2, _monitor[1] + _monitor[3] / 2 - hh / 2, ww, hh);
			else
				window_set_rectangle(display_get_width() / 2 - ww / 2, display_get_height() / 2 - hh / 2, ww, hh);
			
			if(PREFERENCES.window_maximize)
				winMan_Maximize();
					
			gameframe_set_shadow(true);
		}
		
		window_refresh();
		game_set_speed(PREFERENCES.ui_framerate, gamespeed_fps);
		
		var grav = struct_try_get(PREFERENCES, "physics_gravity", [ 0, 10 ]);
		physics_world_gravity(array_safe_get_fast(grav, 0, 0), array_safe_get_fast(grav, 1, 10));
	}
#endregion
