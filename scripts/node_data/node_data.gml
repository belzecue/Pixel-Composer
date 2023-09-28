global.loop_nodes = [ "Node_Iterate", "Node_Iterate_Each" ];

function Node(_x, _y, _group = PANEL_GRAPH.getCurrentContext()) : __Node_Base(_x, _y) constructor {
	#region ---- main & active ----
		active  = true;
		renderActive = true;
	
		node_id = UUID_generate();
	
		group   = _group;
		manual_deletable	 = true;
		destroy_when_upgroup = false;
		ds_list_add(PANEL_GRAPH.getNodeList(_group), self);
	
		active_index = -1;
		active_range = [ 0, PROJECT.animator.frames_total - 1 ];
	#endregion
	
	static resetInternalName = function() { #region
		var str = string_replace_all(name, " ", "_");
			str = string_replace_all(str,  "/", "");
			str = string_replace_all(str,  "-", "");
		
		ds_map_delete(PROJECT.nodeNameMap, internalName);
		internalName = str + string(irandom_range(10000, 99999)); 
		PROJECT.nodeNameMap[? internalName] = self;
	} #endregion
	
	if(!LOADING && !APPENDING) { #region
		recordAction(ACTION_TYPE.node_added, self);
		PROJECT.nodeMap[? node_id] = self;
		PROJECT.modified = true;
		
		//print($"Adding node {node_id} to {PROJECT.path} [{ds_map_size(PROJECT.nodeMap)}]");
		
		run_in(1, function() { 
			if(display_name != "") return;
			resetInternalName();
			display_name = __txt_node_name(instanceof(self), name);
		});
	} #endregion
	
	#region ---- display ----
		color   = c_white;
		icon    = noone;
		bg_spr  = THEME.node_bg;
		bg_sel_spr	  = THEME.node_active;
	
		name = "";
		display_name = "";
		internalName = "";
	
		tooltip = "";
		x = _x;
		y = _y;
	
		w = 128;
		h = 128;
		min_h = 0;
		draw_padding = 4;
		auto_height  = true;
		
		display_parameter = {};
		
		draw_name = true;
		draggable = true;
		
		draw_graph_culled = false;
		
		badgePreview = 0;
		badgeInspect = 0;
		
		active_draw_index = -1;
		
		draw_droppable = false;
		
		junction_draw_pad_y = 32;
	#endregion
	
	#region ---- junctions ----
		inputs  = ds_list_create();
		outputs = ds_list_create();
		inputMap  = ds_map_create();
		outputMap = ds_map_create();
	
		input_display_list		= -1;
		output_display_list		= -1;
		inspector_display_list	= -1;
		is_dynamic_output		= false;
		
		inspectInput1 = nodeValue("Toggle execution", self, JUNCTION_CONNECT.input, VALUE_TYPE.action, false).setVisible(true, true);
		inspectInput2 = nodeValue("Toggle execution", self, JUNCTION_CONNECT.input, VALUE_TYPE.action, false).setVisible(true, true);
		
		autoUpdatedTrigger = true;
		updatedTrigger = nodeValue("Updated", self, JUNCTION_CONNECT.output, VALUE_TYPE.trigger, false).setVisible(true, true);
		
		insp1UpdateTooltip  = __txtx("panel_inspector_execute", "Execute node");
		insp1UpdateIcon     = [ THEME.sequence_control, 1, COLORS._main_value_positive ];
	
		insp2UpdateTooltip = __txtx("panel_inspector_execute", "Execute node");
		insp2UpdateIcon    = [ THEME.sequence_control, 1, COLORS._main_value_positive ];
		
		is_dynamic_input  = false;
		auto_input		  = false;
		input_display_len = 0;
		input_fix_len	  = 0;
		data_length       = 1;
	#endregion
	
	#region --- attributes ----
		attributes		 = {
			show_update_trigger: false
		};
		
		attributeEditors = [
			"Node",
			["Update trigger", function() { return attributes.show_update_trigger; }, new checkBox(function() { attributes.show_update_trigger = !attributes.show_update_trigger; }) ]
		];
	#endregion
	
	#region ---- preview ----
		show_input_name  = false;
		show_output_name = false;
	
		inspecting	  = false;
		previewing	  = 0;
	
		preview_surface	= noone;
		preview_amount  = 0;
		previewable		= true;
		preview_speed	= 0;
		preview_index	= 0;
		preview_channel = 0;
		preview_alpha	= 1;
		preview_x		= 0;
		preview_y		= 0;
	
		preview_mx = 0;
		preview_my = 0;
	#endregion
	
	#region ---- rendering ----
		rendered         = false;
		update_on_frame  = false;
		render_time		 = 0;
		auto_render_time = true;
		updated			 = false;
	
		use_cache			= false;
		clearCacheOnChange	= true;
		cached_output	= [];
		cache_result	= [];
		temp_surface    = [];
	#endregion
	
	#region ---- timeline ----
		anim_priority = ds_map_size(PROJECT.nodeMap);
		
		anim_show		= true;
		dopesheet_color = COLORS.panel_animation_dope_blend_default;
		dopesheet_y		= 0;
	#endregion
	
	#region ---- notification ----
		value_validation = array_create(3);
	
		error_noti_update	 = noone;
		error_update_enabled = false;
		manual_updated		 = false;
	#endregion
	
	#region ---- tools ----
		tools			= -1;
		isTool			= false;
		tool_settings	= [];
		tool_attribute	= {};
	#endregion
	
	#region ---- 3d ----
		is_3D = false;
	#endregion
	
	static createNewInput = noone;
	
	static initTooltip = function() { #region
		var type_self/*:string*/ = instanceof(self);
		if(!struct_has(global.NODE_GUIDE, type_self)) return;
		
		var _n = global.NODE_GUIDE[$ type_self];
		var _ins = _n.inputs;
		var _ots = _n.outputs;
		
		var amo = min(ds_list_size(inputs), array_length(_ins));
		for( var i = 0; i < amo; i++ ) {
			inputs[| i].name    = _ins[i].name;
			inputs[| i].tooltip = _ins[i].tooltip;
		}
		
		var amo = min(ds_list_size(outputs), array_length(_ots));
		for( var i = 0; i < amo; i++ ) {
			outputs[| i].name    = _ots[i].name;
			outputs[| i].tooltip = _ots[i].tooltip;
		}
	} #endregion
	run_in(1, initTooltip);
	
	static resetDefault = function() { #region
		var folder = instanceof(self);
		if(!ds_map_exists(global.PRESETS_MAP, folder)) return;
		
		var pres = global.PRESETS_MAP[? folder];
		for( var i = 0, n = array_length(pres); i < n; i++ ) {
			var preset = pres[i];
			if(preset.name != "_default") continue;
			
			deserialize(preset.content, true, true);
			applyDeserialize(true);
		}
		
		doUpdate();
	} #endregion
	if(!APPENDING && !LOADING)
		run_in(1, method(self, resetDefault));
	
	static getInputJunctionIndex = function(index) { #region
		if(input_display_list == -1)
			return index;
		
		var jun_list_arr = input_display_list[index];
		if(is_array(jun_list_arr)) return noone;
		if(is_struct(jun_list_arr)) return noone;
		return jun_list_arr;
	} #endregion
	
	static getOutputJunctionIndex = function(index) { #region
		if(output_display_list == -1)
			return index;
		return output_display_list[index];
	} #endregion
	
	static setHeight = function() { #region
		var _hi = ui(junction_draw_pad_y);
		var _ho = ui(junction_draw_pad_y);
		
		for( var i = 0; i < ds_list_size(inputs); i++ )
			if(inputs[| i].isVisible()) _hi += 24;
		
		for( var i = 0; i < ds_list_size(outputs); i++ )
			if(outputs[| i].isVisible()) _ho += 24;
		
		h = max(min_h, (preview_surface && previewable)? 128 : 0, _hi, _ho);
	} #endregion
	
	onSetDisplayName = noone;
	static setDisplayName = function(_name) { #region
		display_name = _name;
		internalName = string_replace_all(display_name, " ", "_");
		refreshNodeMap();
		
		if(onSetDisplayName != noone)
			onSetDisplayName();
		
		return self;
	} #endregion
	
	static setIsDynamicInput = function(_data_length = 1, _auto_input = true) { #region
		is_dynamic_input	= true;						
		auto_input			= _auto_input;
		input_display_len	= input_display_list == -1? 0 : array_length(input_display_list);
		input_fix_len		= ds_list_size(inputs);
		data_length			= _data_length;
	} #endregion
	
	static getOutput = function(junc = noone) { #region
		for( var i = 0; i < ds_list_size(outputs); i++ ) {
			if(!outputs[| i].visible) continue;
			if(junc != noone && !junc.isConnectable(outputs[| i], true)) continue;
			
			return outputs[| i];
		}
		return noone;
	} #endregion
	
	static getInput = function(junc = noone) { #region
		for( var i = 0; i < ds_list_size(inputs); i++ ) {
			if(!inputs[| i].visible) continue;
			if(inputs[| i].value_from != noone) continue;
			if(junc != noone && !inputs[| i].isConnectable(junc, true)) continue;
			
			return inputs[| i];
		}
		return noone;
	} #endregion
	
	static getFullName = function() { #region
		return display_name == ""? name : "[" + name + "] " + display_name;
	} #endregion
	
	static addInput = function(junctionFrom) { #region
		var targ = getInput(junctionFrom);
		if(targ == noone) return;
		
		targ.setFrom(junctionFrom);
	} #endregion
	
	static isAnimated = function() { #region
		for(var i = 0; i < ds_list_size(inputs); i++) {
			if(inputs[| i].isAnimated())
				return true;
		}
		return false;
	} #endregion
	
	static isInLoop = function() { #region
		return array_exists(global.loop_nodes, instanceof(group));
	} #endregion
	
	static move = function(_x, _y) { #region
		if(x == _x && y == _y) return;
		
		x = _x;
		y = _y; 
		if(!LOADING) PROJECT.modified = true;
	} #endregion
	
	#region ++++ inspector update ++++
	static inspector1Update = function() {
		if(error_update_enabled && error_noti_update != noone)
			noti_remove(error_noti_update);
		error_noti_update = noone;
		
		onInspector1Update();
	}
	static onInspector1Update = noone;
	static hasInspector1Update = function() { return onInspector1Update != noone; }
	
	static inspector2Update = function() { onInspector2Update(); }
	static onInspector2Update = noone;
	static hasInspector2Update = function() { return onInspector2Update != noone; }
	#endregion
	
	static stepBegin = function() { #region
		if(use_cache) cacheArrayCheck();
		var willUpdate = false;
		
		if(PROJECT.animator.frame_progress) {
			if(update_on_frame) willUpdate = true;
			if(isAnimated()) willUpdate = true;
				
			if(willUpdate) {
				setRenderStatus(false);
				UPDATE |= RENDER_TYPE.partial;
			}
		}
		
		if(auto_height)
			setHeight();
		
		doStepBegin();
		
		if(hasInspector1Update()) inspectInput1.name = insp1UpdateTooltip;
		if(hasInspector2Update()) inspectInput2.name = insp2UpdateTooltip;
		
		updatedTrigger.setValue(false);
	} #endregion
	
	static doStepBegin = function() {}
	
	static triggerCheck = function() { _triggerCheck(); }
	
	static _triggerCheck = function() { #region
		for( var i = 0; i < ds_list_size(inputs); i++ ) {
			if(inputs[| i].type != VALUE_TYPE.trigger) continue;
			if(!is_instanceof(inputs[| i].editWidget, buttonClass)) continue;
			
			var trig = inputs[| i].getValue();
			if(trig) {
				inputs[| i].editWidget.onClick();
				inputs[| i].setValue(false);
			}
		}
		
		if(hasInspector1Update()) {
			var trig = inspectInput1.getValue();
			if(trig) {
				onInspector1Update();
				inspectInput1.setValue(false);
			}
		}
		
		if(hasInspector2Update()) {
			var trig = inspectInput2.getValue();
			if(trig) {
				onInspector2Update();
				inspectInput2.setValue(false);
			}
		}
	} #endregion
	
	static step = function() {}
	static focusStep = function() {}
	static inspectorStep = function() {}
	
	static doUpdate = function() { #region
		if(SAFE_MODE)    return;
		if(NODE_EXTRACT) return;
		
		var sBase = surface_get_target();
		LOG_BLOCK_START();
		LOG_IF(global.FLAG.render, $">>>>>>>>>> DoUpdate called from {internalName} <<<<<<<<<<");
		
		try {
			var t = get_timer();
			
			if(!is_instanceof(self, Node_Collection)) 
				setRenderStatus(true);
				
			update();																						///UPDATE
				
			if(!is_instanceof(self, Node_Collection))
				render_time = get_timer() - t;
		} catch(exception) {
			var sCurr = surface_get_target();
			while(surface_get_target() != sBase)
				surface_reset_target();
			
			log_warning("RENDER", exception_print(exception), self);
		}
		
		if(!use_cache && PROJECT.onion_skin) {
			for( var i = 0; i < ds_list_size(outputs); i++ ) {
				if(outputs[| i].type != VALUE_TYPE.surface) continue;
				cacheCurrentFrame(outputs[| i].getValue());
				break;
			}
		}
		
		if(hasInspector1Update()) {
			var trigger = inspectInput1.getValue();
			if(trigger) onInspector1Update();
		}
		
		if(hasInspector2Update()) {
			var trigger = inspectInput2.getValue();
			if(trigger) onInspector2Update();
		}
		
		if(autoUpdatedTrigger) updatedTrigger.setValue(true);
		LOG_BLOCK_END();
	} #endregion
	
	static valueUpdate = function(index) { #region
		if(error_update_enabled && error_noti_update == noone)
			error_noti_update = noti_error(getFullName() + " node require manual execution.",, self);
		
		onValueUpdate(index);
	} #endregion
	
	static onValueUpdate = function(index = 0) {}
	static onValueFromUpdate = function(index) {}
	
	static triggerRender = function() { #region
		LOG_BLOCK_START();
		LOG_IF(global.FLAG.render, $"Trigger render for {internalName}");
		
		setRenderStatus(false);
		UPDATE |= RENDER_TYPE.partial;
		
		if(is_instanceof(group, Node_Collection) && group.reset_all_child) {
			group.resetRender();
		} else {
			resetRender();
			
			var nodes = getNextNodesRaw();
			for(var i = 0; i < array_length(nodes); i++)
				nodes[i].triggerRender();
		}
		
		LOG_BLOCK_END();
	} #endregion
	
	static resetRender = function() { setRenderStatus(false); }
	static isRenderActive = function() { return renderActive || (PREF_MAP[? "render_all_export"] && PROJECT.animator.rendering); }
	
	static isRenderable = function(log = false) { #region //Check if every input is ready (updated)
		if(!active)	return false;
		if(!isRenderActive()) return false;
		
		//if(group && struct_has(group, "iterationStatus") && group.iterationStatus() == ITERATION_STATUS.complete) return false;
		
		for(var j = 0; j < ds_list_size(inputs); j++) {
			var _in = inputs[| j];
			if( _in.type == VALUE_TYPE.node) continue;
			
			var val_from = _in.value_from;
			if( val_from == noone) continue;
			if(!val_from.node.active) continue;
			if(!val_from.node.isRenderActive()) continue;
			if!(val_from.node.rendered || val_from.node.update_on_frame) {
				LOG_LINE_IF(global.FLAG.render, $"Node {internalName} is not renderable because input {val_from.node.internalName} is not rendered ({val_from.node.rendered})");
				return false;
			}
		}
		
		return true;
	} #endregion
	
	static getNextNodesRaw = function() { return getNextNodes(); }
	
	static getNextNodes = function() { #region
		var nodes = [];
		var nodeNames = [];
		
		LOG_BLOCK_START();
		LOG_IF(global.FLAG.render, $"→→→→→ Call get next node from: {internalName}");
		LOG_BLOCK_START();
		
		for(var i = 0; i < ds_list_size(outputs); i++) {
			var _ot = outputs[| i];
			if(!_ot.forward) continue;
			
			var _tos = _ot.getJunctionTo();
			
			for( var j = 0; j < array_length(_tos); j++ ) {
				var _to = _tos[j];
				
				array_push(nodes, _to.node);
				array_push(nodeNames, _to.node.internalName);
				
				//LOG_IF(global.FLAG.render, $"→→ Check output: {_ot.name} connect to node {_to.node.internalName}");
			}
		}	
		
		LOG_IF(global.FLAG.render, $"→→ Push {nodeNames} to stack.");
		
		LOG_BLOCK_END();
		LOG_BLOCK_END();
		return nodes;
	} #endregion
	
	static isTerminal = function() { #region
		for( var i = 0; i < ds_list_size(outputs); i++ ) {
			var _to = outputs[| i].getJunctionTo();
			if(array_length(_to)) return false;
		}
		
		return true;
	} #endregion
	
	static onInspect = function() {}
	
	static setRenderStatus = function(result) { #region
		LOG_LINE_IF(global.FLAG.render, $"Set render status for {internalName} : {result}");
		
		rendered = result;
	} #endregion
	
	static pointIn = function(_x, _y, _mx, _my, _s) { #region
		var xx = x * _s + _x;
		var yy = y * _s + _y;
		
		return point_in_rectangle(_mx, _my, xx, yy, xx + w * _s, yy + h * _s);
	} #endregion
	
	static cullCheck = function(_x, _y, _s, minx, miny, maxx, maxy) { #region
		var x0 = x * _s + _x;
		var y0 = y * _s + _y;
		var x1 = (x + w) * _s + _x;
		var y1 = (y + h) * _s + _y;
		
		draw_graph_culled = !rectangle_in_rectangle(minx, miny, maxx, maxy, x0, y0, x1, y1);
	} #endregion
	
	static preDraw = function(_x, _y, _s) { #region
		var xx = x * _s + _x;
		var yy = y * _s + _y;
		var jun;
		
		var inspCount = hasInspector1Update() + hasInspector2Update();
		var ind = 1;
		if(hasInspector1Update()) {
			inspectInput1.x = xx + w * _s * ind / (inspCount + 1);
			inspectInput1.y = yy;
			ind++;
		}
		
		if(hasInspector2Update()) {
			inspectInput2.x = xx + w * _s * ind / (inspCount + 1);
			inspectInput2.y = yy;
			ind++;
		}
		
		updatedTrigger.x = xx + w * _s;
		updatedTrigger.y = yy + 10;
		
		var inamo = input_display_list == -1? ds_list_size(inputs) : array_length(input_display_list);
		var _in = yy + ui(junction_draw_pad_y) * _s;
		
		for(var i = 0; i < inamo; i++) {
			var idx = getInputJunctionIndex(i);
			if(idx == noone) continue;
			
			jun = ds_list_get(inputs, idx, noone);
			if(jun == noone || is_undefined(jun)) continue;
			jun.x = xx;
			jun.y = _in;
			_in += 24 * _s * jun.isVisible();
		}
		
		var outamo = output_display_list == -1? ds_list_size(outputs) : array_length(output_display_list);
		
		 xx = xx + w * _s;
		_in = yy + ui(junction_draw_pad_y) * _s;
		for(var i = 0; i < outamo; i++) {
			var idx = getOutputJunctionIndex(i);
			jun = outputs[| idx];
			
			jun.x = xx;
			jun.y = _in;
			_in += 24 * _s * jun.isVisible();
		}
	} #endregion
	
	static drawNodeBase = function(xx, yy, _s) { #region
		if(draw_graph_culled) return;
		if(!active) return;
		var aa = 0.25 + 0.5 * renderActive;
		draw_sprite_stretched_ext(bg_spr, 0, xx, yy, w * _s, h * _s, color, aa);
	} #endregion 
	
	static drawGetBbox = function(xx, yy, _s) { #region
		var pad_label = draw_name && display_parameter.avoid_label;
		
		var _w = w;
		var _h = h;
		
		_w *= display_parameter.preview_scale / 100 * _s;
		_h *= display_parameter.preview_scale / 100 * _s;
		
		_w -= draw_padding * 2;
		_h -= draw_padding * 2 + 20 * pad_label;
		
		var _xc = xx +  w * _s / 2;
		var _yc = yy + (h * _s + 20 * pad_label) / 2;
		
		var x0 = _xc - _w / 2;
		var x1 = _xc + _w / 2;
		var y0 = _yc - _h / 2;
		var y1 = _yc + _h / 2;
		
		return BBOX().fromPoints(x0, y0, x1, y1);
	} #endregion
	
	static drawNodeName = function(xx, yy, _s) { #region
		if(draw_graph_culled) return;
		if(!active) return;
		
		draw_name = false;
		var _name = display_name == ""? name : display_name;
		if(_name == "") return;
		if(_s < 0.75) return;
		draw_name = true;
		
		var aa = 0.25 + 0.5 * renderActive;
		draw_sprite_stretched_ext(THEME.node_bg_name, 0, xx, yy, w * _s, ui(20), color, aa);
		
		var cc = COLORS._main_text;
		if(PREF_MAP[? "node_show_render_status"] && !rendered)
			cc = isRenderable()? COLORS._main_value_positive : COLORS._main_value_negative;
		
		draw_set_text(f_p1, fa_left, fa_center, cc);
		
		if(hasInspector1Update()) icon = THEME.refresh_s;
		var ts = clamp(power(_s, 0.5), 0.5, 1);
		
		var aa = 0.5 + 0.5 * renderActive;
		draw_set_alpha(aa);
		
		if(icon && _s > 0.75) {
			draw_sprite_ui_uniform(icon, 0, xx + ui(12), yy + ui(10),,, aa);	
			draw_text_cut(xx + ui(24), yy + ui(10), _name, w * _s - ui(24), ts);
		} else
			draw_text_cut(xx + ui(8), yy + ui(10), _name, w * _s - ui(8), ts);
			
		draw_set_alpha(1);
	} #endregion
	
	static drawJunctions = function(_x, _y, _mx, _my, _s) { #region
		if(!active) return;
		var hover = noone;
		var amo = input_display_list == -1? ds_list_size(inputs) : array_length(input_display_list);
		var jun;
		
		for(var i = 0; i < amo; i++) {
			var ind = getInputJunctionIndex(i);
			if(ind == noone) continue;
			jun = ds_list_get(inputs, ind, noone);
			if(jun == noone || is_undefined(jun)) continue;
			
			if(jun.drawJunction(_s, _mx, _my))
				hover = jun;
		}
		
		for(var i = 0; i < ds_list_size(outputs); i++) {
			jun = outputs[| i];
			
			if(jun.drawJunction(_s, _mx, _my))
				hover = jun;
		}
		
		if(hasInspector1Update() && inspectInput1.drawJunction(_s, _mx, _my))
			hover = inspectInput1;
			
		if(hasInspector2Update() && inspectInput2.drawJunction(_s, _mx, _my))
			hover = inspectInput2;
		
		if(attributes.show_update_trigger && updatedTrigger.drawJunction(_s, _mx, _my))
			hover = updatedTrigger;
		
		return hover;
	} #endregion
	
	static drawJunctionNames = function(_x, _y, _mx, _my, _s) { #region
		if(draw_graph_culled) return;
		if(!active) return;
		var amo = input_display_list == -1? ds_list_size(inputs) : array_length(input_display_list);
		var jun;
		
		var xx = x * _s + _x;
		var yy = y * _s + _y;
		
		show_input_name  = PANEL_GRAPH.pHOVER && point_in_rectangle(_mx, _my, xx - 8 * _s, yy + 20 * _s, xx + 8 * _s, yy + h * _s);
		show_output_name = PANEL_GRAPH.pHOVER && point_in_rectangle(_mx, _my, xx + (w - 8) * _s, yy + 20 * _s, xx + (w + 8) * _s, yy + h * _s);
		
		if(show_input_name) {
			for(var i = 0; i < amo; i++) {
				var ind = getInputJunctionIndex(i);
				if(ind == noone) continue;
				if(!inputs[| ind]) continue;
				
				inputs[| ind].drawNameBG(_s);
			}
			
			for(var i = 0; i < amo; i++) {
				var ind = getInputJunctionIndex(i);
				if(ind == noone) continue;
				if(!inputs[| ind]) continue;
				
				inputs[| ind].drawName(_s, _mx, _my);
			}
		}
		
		if(show_output_name) {
			for(var i = 0; i < ds_list_size(outputs); i++)
				outputs[| i].drawNameBG(_s);
			
			for(var i = 0; i < ds_list_size(outputs); i++)
				outputs[| i].drawName(_s, _mx, _my);
		}
		
		if(hasInspector1Update() && PANEL_GRAPH.pHOVER && point_in_circle(_mx, _my, inspectInput1.x, inspectInput1.y, 10)) {
			inspectInput1.drawNameBG(_s);
			inspectInput1.drawName(_s, _mx, _my);
		}
		
		if(hasInspector2Update() && PANEL_GRAPH.pHOVER && point_in_circle(_mx, _my, inspectInput2.x, inspectInput2.y, 10)) {
			inspectInput2.drawNameBG(_s);
			inspectInput2.drawName(_s, _mx, _my);
		}
	} #endregion
	
	static drawConnections = function(params = {}) { #region
		if(!active) return;
		
		var hovering = noone;
		var drawLineIndex = 1;
		
		for(var i = 0; i < ds_list_size(outputs); i++) {
			var jun       = outputs[| i];
			var connected = false;
			
			for( var j = 0; j < ds_list_size(jun.value_to); j++ ) {
				if(jun.value_to[| j].value_from == jun) 
					connected = true;
			}
			
			if(connected) {
				jun.drawLineIndex = drawLineIndex;
				drawLineIndex += 0.5;
			}
		}
		
		var st = 0;
		if(hasInspector1Update()) st = -1;
		if(hasInspector2Update()) st = -2;
		
		var _inputs = [];
		var drawLineIndex = 1;
		for(var i = st; i < ds_list_size(inputs); i++) {
			var jun;
			if(i == -1)			jun = inspectInput1;
			else if(i == -2)	jun = inspectInput2;
			else				jun = inputs[| i];
			
			if(jun.value_from == noone) continue;
			if(!jun.value_from.node.active) continue;
			if(!jun.isVisible()) continue;
			
			if(i >= 0)
				array_push(_inputs, jun);
		}
		
		var len = array_length(_inputs);
		for( var i = 0; i < len; i++ )
			_inputs[i].drawLineIndex = 1 + (i > len / 2? (len - 1 - i) : i) * 0.5;
		
		for(var i = st; i < ds_list_size(inputs); i++) {
			var jun;
			if(i == -1)			jun = inspectInput1;
			else if(i == -2)	jun = inspectInput2;
			else				jun = inputs[| i];
			
			var hov = jun.drawConnections(params);
			if(hov) hovering = hov;
		}
		
		return hovering;
	} #endregion
	
	static getGraphPreviewSurface = function() { #region
		var _node = outputs[| preview_channel];
		switch(_node.type) {
			case VALUE_TYPE.surface :
			case VALUE_TYPE.dynaSurface :
				return _node.getValue();
		}
		
		return noone;
	} #endregion
	
	static drawPreview = function(xx, yy, _s) { #region
		if(draw_graph_culled) return;
		if(!active) return;
		
		var surf = getGraphPreviewSurface();
		if(surf == noone) return;
		
		preview_amount = 0;
		if(is_array(surf)) {
			if(array_length(surf) == 0) return;
			preview_amount = array_length(surf);
			
			if(preview_speed != 0) {
				preview_index += preview_speed;
				if(preview_index <= 0)
					preview_index = array_length(surf) - 1;
			}
			
			if(floor(preview_index) > array_length(surf) - 1) preview_index = 0;
			surf = surf[preview_index];
		}
		
		preview_surface = is_surface(surf)? surf : noone;
		if(preview_surface == noone) return;
		
		var bbox = drawGetBbox(xx, yy, _s);
		var aa   = 0.5 + 0.5 * renderActive;
		
		draw_surface_bbox(preview_surface, bbox, c_white, aa);
	} #endregion
	
	static getNodeDimension = function(showFormat = true) { #region
		if(!is_surface(preview_surface)) {	
			if(ds_list_size(outputs))
				return "[" + array_shape(outputs[| 0].getValue()) + "]";
			return "";
		}
		
		var pw = surface_get_width_safe(preview_surface);
		var ph = surface_get_height_safe(preview_surface);
		var format = surface_get_format(preview_surface);
		
		var txt = "[" + string(pw) + " x " + string(ph) + " ";
		if(preview_amount) txt = string(preview_amount) + " x " + txt;
		
		switch(format) {
			case surface_rgba4unorm	 : txt += showFormat? "4RGBA"	: "4R";  break;
			case surface_rgba8unorm	 : txt += showFormat? "8RGBA"	: "8R";  break;
			case surface_rgba16float : txt += showFormat? "16RGBA"	: "16R"; break;
			case surface_rgba32float : txt += showFormat? "32RGBA"	: "32R"; break;
			case surface_r8unorm	 : txt += showFormat? "8BW"		: "8B";  break;
			case surface_r16float	 : txt += showFormat? "16BW"	: "16B"; break;
			case surface_r32float	 : txt += showFormat? "32BW"	: "32B"; break;
		}
		
		txt += "]";
		
		return txt;
	} #endregion
	
	static drawDimension = function(xx, yy, _s) { #region
		if(draw_graph_culled) return;
		if(!active) return;
		if(_s * w < 64) return;
		
		draw_set_text(f_p2, fa_center, fa_top, COLORS.panel_graph_node_dimension);
		var tx = xx + w * _s / 2;
		var ty = yy + (h + 4) * _s - 2;
		
		if(display_parameter.show_dimension) {
			var txt = string(getNodeDimension(_s > 0.65));
			draw_text(round(tx), round(ty), txt);
			ty += string_height(txt) - 2;
		}
		
		draw_set_font(f_p3);
		
		if(display_parameter.show_compute) {
			var rt, unit;
			if(render_time < 1000) {
				rt = round(render_time / 10) * 10;
				unit = "us";
				draw_set_color(COLORS.speed[2]);
			} else if(render_time < 1000000) {
				rt = string_format(render_time / 1000, -1, 2);
				unit = "ms";
				draw_set_color(COLORS.speed[1]);
			} else {
				rt = string_format(render_time / 1000000, -1, 2);
				unit = "s";
				draw_set_color(COLORS.speed[0]);
			}
			draw_text(round(tx), round(ty), string(rt) + " " + unit);
		}
	} #endregion
	
	static drawNode = function(_x, _y, _mx, _my, _s, display_parameter = noone) { #region
		if(draw_graph_culled) return;
		if(!active) return;
		
		if(display_parameter != noone)
			self.display_parameter = display_parameter;
		
		var xx = x * _s + _x;
		var yy = y * _s + _y;
		
		preview_mx = _mx;
		preview_my = _my;
		
		if(value_validation[VALIDATION.error] || error_noti_update != noone)
			draw_sprite_stretched_ext(THEME.node_glow, 0, xx - 9, yy - 9, w * _s + 18, h * _s + 18, COLORS._main_value_negative, 1);
		
		drawNodeBase(xx, yy, _s);
		if(previewable && ds_list_size(outputs)) {
			if(preview_channel >= ds_list_size(outputs))
				preview_channel = 0;
			drawPreview(xx, yy, _s);
		} 
		drawDimension(xx, yy, _s);
		
		onDrawNode(xx, yy, _mx, _my, _s, PANEL_GRAPH.node_hovering == self, PANEL_GRAPH.node_focus == self);
		drawNodeName(xx, yy, _s);
		
		if(active_draw_index > -1) {
			draw_sprite_stretched_ext(bg_sel_spr, 0, xx, yy, round(w * _s), round(h * _s), active_draw_index > 1? COLORS.node_border_file_drop : COLORS._main_accent, 1);
			active_draw_index = -1;
		}
		
		if(draw_droppable)
			draw_sprite_stretched_ext(THEME.ui_panel_active, 0, xx, yy, w * _s, h * _s, COLORS._main_value_positive, 1);
		draw_droppable = false;
		
		return drawJunctions(xx, yy, _mx, _my, _s);
	} #endregion
	
	static onDrawNodeBehind = function(_x, _y, _mx, _my, _s) {}
	
	static onDrawNode = function(xx, yy, _mx, _my, _s, _hover = false, _focus = false) {}
	
	static onDrawHover = function(_x, _y, _mx, _my, _s) {}
	
	static drawBadge = function(_x, _y, _s) { #region
		if(!active) return;
		var xx = x * _s + _x + w * _s;
		var yy = y * _s + _y;
		
		badgePreview = lerp_float(badgePreview, !!previewing, 2);
		badgeInspect = lerp_float(badgeInspect,   inspecting, 2);
		
		if(badgePreview > 0) {
			draw_sprite_ext(THEME.node_state, 0, xx, yy, badgePreview, badgePreview, 0, c_white, 1);
			xx -= 28 * badgePreview;
		}
		
		if(badgeInspect > 0) {
			draw_sprite_ext(THEME.node_state, 1, xx, yy, badgeInspect, badgeInspect, 0, c_white, 1);
			xx -= 28 * badgeInspect;
		}
		
		if(isTool) {
			draw_sprite_ext(THEME.node_state, 2, xx, yy, 1, 1, 0, c_white, 1);
			xx -= 28 * 2;
		}
		
		inspecting = false;
		previewing = 0;
	} #endregion
	
	static drawActive = function(_x, _y, _s, ind = 0) { active_draw_index = ind; }
	
	static drawOverlay = function(active, _x, _y, _s, _mx, _my, _snx, _sny) {}
	
	static drawAnimationTimeline = function(_w, _h, _s) {}
	
	static enable = function() { active = true; }
	static disable = function() { active = false; }
	
	static destroy = function(_merge = false) { #region
		if(!active) return;
		disable();
		
		if(PANEL_GRAPH.node_hover     == self) PANEL_GRAPH.node_hover     = noone;
		if(PANEL_GRAPH.node_focus     == self) PANEL_GRAPH.node_focus     = noone;
		if(PANEL_INSPECTOR.inspecting == self) PANEL_INSPECTOR.inspecting = noone;
		
		PANEL_PREVIEW.removeNodePreview(self);
		PANEL_ANIMATION.updatePropertyList();
		
		for(var i = 0; i < ds_list_size(outputs); i++) {
			var jun = outputs[| i];
			
			for(var j = 0; j < ds_list_size(jun.value_to); j++) {
				var _vt = jun.value_to[| j];
				if(_vt.value_from == noone) break;
				if(_vt.value_from.node != self) break;
				
				_vt.removeFrom(false);
				
				if(!_merge) continue;
				
				for( var k = 0; k < ds_list_size(inputs); k++ ) {
					if(inputs[| k].value_from == noone) continue;
					if(_vt.setFrom(inputs[| k].value_from)) break;
				}
			}
			
			ds_list_clear(jun.value_to);
		}
		
		for( var i = 0; i < ds_list_size(inputs); i++ )
			inputs[| i].destroy();
		
		for( var i = 0; i < ds_list_size(outputs); i++ )
			outputs[| i].destroy();
		
		onDestroy();
		UPDATE |= RENDER_TYPE.full;
	} #endregion
	
	static restore = function() { #region
		if(active) return;
		enable();
		ds_list_add(group == noone? PROJECT.nodes : group.getNodeList(), self);
	} #endregion
	
	static onValidate = function() { #region
		value_validation[VALIDATION.pass]	 = 0;
		value_validation[VALIDATION.warning] = 0;
		value_validation[VALIDATION.error]   = 0;
		
		for( var i = 0; i < ds_list_size(inputs); i++ ) {
			var jun = inputs[| i];
			if(jun.value_validation)
				value_validation[jun.value_validation]++;
		}
	} #endregion
	
	static onDestroy = function() {}
	
	static clearInputCache = function() { #region
		for( var i = 0; i < ds_list_size(inputs); i++ )
			inputs[| i].cache_value[0] = false;
	} #endregion
	
	static cacheArrayCheck = function() { #region
		if(array_length(cached_output) != PROJECT.animator.frames_total)
			array_resize(cached_output, PROJECT.animator.frames_total);
		if(array_length(cache_result) != PROJECT.animator.frames_total)
			array_resize(cache_result, PROJECT.animator.frames_total);
	} #endregion
	
	static cacheCurrentFrame = function(_frame) { #region
		cacheArrayCheck();
		if(PROJECT.animator.current_frame < 0) return;
		if(PROJECT.animator.current_frame >= array_length(cached_output)) return;
		
		surface_array_free(cached_output[PROJECT.animator.current_frame]);
		cached_output[PROJECT.animator.current_frame] = surface_array_clone(_frame);
		
		array_safe_set(cache_result, PROJECT.animator.current_frame, true);
		
		return cached_output[PROJECT.animator.current_frame];
	} #endregion
	
	static cacheExist = function(frame = PROJECT.animator.current_frame) { #region
		if(frame < 0) return false;
		
		if(frame >= array_length(cached_output)) return false;
		if(frame >= array_length(cache_result)) return false;
		if(!array_safe_get(cache_result, frame, false)) return false;
		
		var s = array_safe_get(cached_output, frame);
		return is_array(s) || surface_exists(s);
	} #endregion
	
	static getCacheFrame = function(frame = PROJECT.animator.current_frame) { #region
		if(frame < 0) return false;
		
		if(!cacheExist(frame)) return noone;
		var surf = array_safe_get(cached_output, frame);
		return surf;
	} #endregion
	
	static recoverCache = function(frame = PROJECT.animator.current_frame) { #region
		if(!cacheExist(frame)) return false;
		
		var _s = cached_output[PROJECT.animator.current_frame];
		outputs[| 0].setValue(_s);
			
		return true;
	} #endregion
	
	static clearCache = function() { #region
		clearInputCache();
		
		if(!clearCacheOnChange) return;
		if(!use_cache) return;
		if(!isRenderActive()) return;
		
		if(array_length(cached_output) != PROJECT.animator.frames_total)
			array_resize(cached_output, PROJECT.animator.frames_total);
		for(var i = 0; i < array_length(cached_output); i++) {
			var _s = cached_output[i];
			if(is_surface(_s))
				surface_free(_s);
			cached_output[i] = 0;
			cache_result[i] = false;
		}
	} #endregion
	
	static clearCacheForward = function() { _clearCacheForward(); }
	
	static _clearCacheForward = function() { #region
		if(!isRenderActive()) return;
		
		clearCache();
		var arr = getNextNodesRaw();
		for( var i = 0, n = array_length(arr); i < n; i++ )
			arr[i]._clearCacheForward();
		
		//for( var i = 0; i < ds_list_size(outputs); i++ )
		//for( var j = 0; j < ds_list_size(outputs[| i].value_to); j++ )
		//	outputs[| i].value_to[| j].node._clearCacheForward();
	} #endregion
	
	static clearInputCache = function() { #region
		for( var i = 0; i < ds_list_size(inputs); i++ )
			inputs[| i].resetCache();
	} #endregion
	
	static checkConnectGroup = function(_type = "group") { #region
		var _y = y;
		var nodes = [];
				
		for(var i = 0; i < ds_list_size(inputs); i++) {
			var _in = inputs[| i];
			if(_in.value_from == noone) continue;
			if(_in.value_from.node.group == group) continue;
			var input_node = noone;
			
			switch(_type) {
				case "group" :		input_node = new Node_Group_Input(x - w - 64, _y, group);	break;	
				case "loop" :		input_node = new Node_Iterator_Input(x - w - 64, _y, group); break;	
				case "feedback" :	input_node = new Node_Feedback_Input(x - w - 64, _y, group); break;	
			}
				
			if(input_node == noone) continue;
			
			array_push(nodes, input_node);
			input_node.inputs[| 2].setValue(_in.type);
			input_node.inParent.setFrom(_in.value_from);
			input_node.onValueUpdate(0);
			_in.setFrom(input_node.outputs[| 0]);
			
			_y += 64;
		}
		
		for(var i = 0; i < ds_list_size(outputs); i++) {
			var _ou = outputs[| i];
			for(var j = 0; j < ds_list_size(_ou.value_to); j++) {
				var _to = _ou.value_to[| j];
				if(_to.value_from != _ou) continue;
				if(!_to.node.active) continue;
				if(_to.node.group == group) continue;
				var output_node = noone;
				
				switch(_type) {
					case "group" :		output_node = new Node_Group_Output(x + w + 64, y, group);		break;
					case "loop" :		output_node = new Node_Iterator_Output(x + w + 64, y, group);	break;	
					case "feedback" :	output_node = new Node_Feedback_Output(x + w + 64, y, group);	break;	
				}
					
				if(output_node == noone) continue;
				
				array_push(nodes, output_node);
				_to.setFrom(output_node.outParent);
				output_node.inputs[| 0].setFrom(_ou);
			}
		}
		
		return nodes;
	} #endregion
	
	static isNotUsingTool = function() { return PANEL_PREVIEW.tool_current == noone; }
	
	static isUsingTool = function(index = undefined, subtool = noone) { #region
		if(tools == -1) 
			return false;
		
		var _tool = PANEL_PREVIEW.tool_current;
		if(_tool == noone)
			return false;
		
		if(index == undefined) 
			return true;
		
		if(is_real(index) && _tool != tools[index])
			return false;
			
		if(is_string(index) && _tool.getName(_tool.selecting) != index)
			return false;
			
		if(subtool == noone)
			return true;
			
		return _tool.selecting == subtool;
	} #endregion
	
	static clone = function(target = PANEL_GRAPH.getCurrentContext()) { #region
		CLONING = true;
		var _type = instanceof(self);
		var _node = nodeBuild(_type, x, y, target);
		CLONING = false;
		
		PROJECT.version = SAVE_VERSION;
		
		if(!_node) return;
		
		CLONING = true;
		var _nid = _node.node_id;
		_node.deserialize(serialize());
		_node.postDeserialize();
		_node.applyDeserialize();
		_node.node_id = _nid;
		
		PROJECT.nodeMap[? node_id] = self;
		PROJECT.nodeMap[? _nid] = _node;
		PANEL_ANIMATION.updatePropertyList();
		CLONING = false;
		
		onClone(_node, target);
		
		return _node;
	} #endregion
	
	static onClone = function(_NewNode, target = PANEL_GRAPH.getCurrentContext()) {}
	
	static droppable = function(dragObj) { #region
		for( var i = 0; i < ds_list_size(inputs); i++ ) {
			if(dragObj.type == inputs[| i].drop_key)
				return true;
		}
		return false;
	} #endregion
	
	on_drop_file = noone;
	static onDrop = function(dragObj) { #region
		if(dragObj.type == "Asset" && is_callable(on_drop_file)) {
			on_drop_file(dragObj.data.path);
			return;
		}
		
		for( var i = 0; i < ds_list_size(inputs); i++ ) {
			if(dragObj.type == inputs[| i].drop_key) {
				inputs[| i].setValue(dragObj.data);
				return;
			}
		}
	} #endregion
	
	static getPreviewValues = function() { #region
		if(preview_channel >= ds_list_size(outputs)) return noone;
		
		switch(outputs[| preview_channel].type) {
			case VALUE_TYPE.surface :
			case VALUE_TYPE.dynaSurface :
				break;
			default :
				return;
		}
		
		return outputs[| preview_channel].getValue();
	} #endregion
	
	static getPreviewBoundingBox = function() { #region
		var _surf = getPreviewValues();
		if(is_array(_surf)) 
			_surf = array_safe_get(_surf, preview_index, noone);
		if(!is_surface(_surf)) return noone;
		
		return BBOX().fromWH(preview_x, preview_y, surface_get_width_safe(_surf), surface_get_height_safe(_surf));
	} #endregion
	
	static getTool = function() { return self; }
	
	static getToolSettings = function() { return tool_settings; }
	
	static setTool = function(tool) { #region
		if(!tool) {
			isTool = false;
			return;
		}
		
		for( var i = 0; i < ds_list_size(group.nodes); i++ )
			group.nodes[| i].isTool = false;
		
		isTool = true;
	} #endregion
	
	static serialize = function(scale = false, preset = false) { #region
		var _map = {};
		//print(" > Serializing: " + name);
		
		if(!preset) {
			_map.id	     = node_id;
			_map.render  = renderActive;
			_map.name	 = display_name;
			_map.iname	 = internalName;
			_map.x		 = x;
			_map.y		 = y;
			_map.type    = instanceof(self);
			_map.group   = group == noone? group : group.node_id;
			_map.preview = previewable;
			_map.tool    = isTool;
		}
		
		_map.attri = attributeSerialize();
		
		if(is_dynamic_input) {
			_map.input_fix_len  = input_fix_len;
			_map.data_length    = data_length;
		}
		
		var _inputs = [];
		for(var i = 0; i < ds_list_size(inputs); i++)
			array_push(_inputs, inputs[| i].serialize(scale, preset));
		_map.inputs = _inputs;
		
		var _outputs = [];
		for(var i = 0; i < ds_list_size(outputs); i++)
			array_push(_outputs, outputs[| i].serialize(scale, preset));
		_map.outputs = _outputs;
		
		var _trigger = [];
		array_push(_trigger, inspectInput1.serialize(scale, preset));
		array_push(_trigger, inspectInput2.serialize(scale, preset));
		array_push(_trigger, updatedTrigger.serialize(scale, preset));
		_map.inspectInputs = _trigger;
		
		doSerialize(_map);
		processSerialize(_map);
		return _map;
	} #endregion
	
	static attributeSerialize = function() { return attributes; }
	static doSerialize = function(_map) {}
	static processSerialize = function(_map) {}
	
	load_scale = false;
	load_map = -1;
	static deserialize = function(_map, scale = false, preset = false) { #region
		load_map = _map;
		load_scale = scale;
		
		if(!preset) {
			if(APPENDING) APPEND_MAP[? load_map.id] = node_id;
			else		  node_id = load_map.id;
			
			PROJECT.nodeMap[? node_id] = self;
			//print($"D Adding node {node_id} to {PROJECT.path} [{ds_map_size(PROJECT.nodeMap)}]");
			
			if(struct_has(load_map, "name"))
				setDisplayName(load_map.name);
			
			internalName = struct_try_get(load_map, "iname", internalName);
			if(internalName == "")
				resetInternalName();
			
			_group = struct_try_get(load_map, "group", noone);
			if(_group == -1) _group = noone;
			
			x = struct_try_get(load_map, "x");
			y = struct_try_get(load_map, "y");
			renderActive = struct_try_get(load_map, "render", true);
			previewable  = struct_try_get(load_map, "preview", previewable);
			isTool       = struct_try_get(load_map, "tool");
		}
		
		if(struct_has(load_map, "attri"))
			attributeDeserialize(load_map.attri);
		
		if(is_dynamic_input) {
			inputBalance();
			inputGenerate();
		}
		
		processDeserialize();
		
		if(preset) {
			postDeserialize();
			applyDeserialize();
			
			triggerRender();
		}
	} #endregion
	
	static inputBalance = function() { #region //Cross version compatibility for dynamic input nodes
		if(!struct_has(load_map, "data_length")) 
			return;
		
		var _input_fix_len  = load_map.input_fix_len;
		var _data_length    = load_map.data_length;
		
		//print($"Balancing IO: {input_fix_len} => {load_map.input_fix_len} : {data_length} => {load_map.data_length}");
		//print($"IO size before: {array_length(load_map.inputs)}");
		//for( var i = 0, n = array_length(load_map.inputs); i < n; i++ ) 
		//	print($"{i}: {load_map.inputs[i].name}");
		
		var _dynamic_inputs = (array_length(load_map.inputs) - _input_fix_len) / _data_length;
		if(frac(_dynamic_inputs) != 0) {
			noti_warning("LOAD: Uneven dynamic input.");
			_dynamic_inputs = ceil(_dynamic_inputs);
		}
		
		if(_input_fix_len == input_fix_len && _data_length == data_length) 
			return;
		
		var _pad_dyna = data_length - _data_length;
		
		for( var i = _dynamic_inputs; i >= 1; i-- ) {
			var _ind = _input_fix_len + i * _data_length;
			if(_pad_dyna > 0)
				repeat(_pad_dyna) array_insert(load_map.inputs, _ind, noone);
			else
				array_delete(load_map.inputs, _ind + _pad_dyna, -_pad_dyna);
		}
		
		var _pad_fix = input_fix_len - _input_fix_len;
		repeat(_pad_fix) 
			array_insert(load_map.inputs, _input_fix_len, noone);
			
		//print($"IO size after: {array_length(load_map.inputs)}");
		//for( var i = 0, n = array_length(load_map.inputs); i < n; i++ ) 
		//	print($"{i}: {load_map.inputs[i] == noone? "noone" : load_map.inputs[i].name}");
	} #endregion
	
	static inputGenerate = function() { #region //Generate input for dynamic input nodes
		if(createNewInput == noone) 
			return;
		
		var _dynamic_inputs = (array_length(load_map.inputs) - input_fix_len) / data_length;
		//print($"Node {name} create {_dynamic_inputs} inputs for data length {data_length}");
		repeat(_dynamic_inputs)
			createNewInput();
	} #endregion
	
	static attributeDeserialize = function(attr) { #region
		struct_override(attributes, attr);
	}
	 #endregion
	static postDeserialize = function() {}
	static processDeserialize = function() {}
		
	static applyDeserialize = function(preset = false) { #region
		var _inputs = load_map.inputs;
		var amo = min(ds_list_size(inputs), array_length(_inputs));
		
		for(var i = 0; i < amo; i++) {
			if(inputs[| i] == noone || _inputs[i] == noone) continue;
			inputs[| i].applyDeserialize(_inputs[i], load_scale, preset);
		}
		
		if(struct_has(load_map, "outputs")) {
			var _outputs = load_map.outputs;
			var amo = min(ds_list_size(outputs), array_length(_outputs));
			
			for(var i = 0; i < amo; i++) {
				if(outputs[| i] == noone) continue;
				outputs[| i].applyDeserialize(_outputs[i], load_scale, preset);
			}
		}
		
		if(struct_has(load_map, "inspectInputs")) {
			var insInp = load_map.inspectInputs;
			inspectInput1.applyDeserialize(insInp[0], load_scale, preset);
			inspectInput2.applyDeserialize(insInp[1], load_scale, preset);
			
			if(array_length(insInp) > 2)
				updatedTrigger.applyDeserialize(insInp[2], load_scale, preset);
		}
		
		doApplyDeserialize();
	} #endregion
	
	static doApplyDeserialize = function() {}
	
	static loadGroup = function(context = PANEL_GRAPH.getCurrentContext()) { #region
		if(_group == noone) {
			var c = context;
			if(c != noone) c.add(self);
		} else {
			if(APPENDING) _group = GetAppendID(_group);
			
			if(ds_map_exists(PROJECT.nodeMap, _group)) {
				if(struct_has(PROJECT.nodeMap[? _group], "add"))
					PROJECT.nodeMap[? _group].add(self);
				else {
					var txt = $"Group load failed. Node ID {_group} is not a group.";
					throw(txt);
				}
			} else {
				var txt = $"Group load failed. Can't find node ID {_group}";
				throw(txt);
			}
		}
	} #endregion
	
	static connect = function(log = false) { #region
		var connected = true;
		for(var i = 0; i < ds_list_size(inputs); i++)
			connected &= inputs[| i].connect(log);
		
		if(struct_has(load_map, "inspectInputs")) {
			inspectInput1.connect(log);
			inspectInput2.connect(log);
		}
		
		if(!connected) ds_queue_enqueue(CONNECTION_CONFLICT, self);
		
		return connected;
	} #endregion
	
	static preConnect = function() {}
	static postConnect = function() {}
	
	static resetAnimation = function() {}
	
	static cleanUp = function() { #region
		for( var i = 0; i < ds_list_size(inputs); i++ )
			inputs[| i].cleanUp();
		for( var i = 0; i < ds_list_size(outputs); i++ )
			outputs[| i].cleanUp();
		
		ds_list_destroy(inputs);
		ds_list_destroy(outputs);
		
		ds_map_destroy(inputMap);
		ds_map_destroy(outputMap);
		
		for( var i = 0, n = array_length(temp_surface); i < n; i++ )
			surface_free(temp_surface[i]);
		
		onCleanUp();
	} #endregion
	
	static onCleanUp = function() {}
	
	// helper function
	static attrDepth = function() { #region
		if(struct_has(attributes, "color_depth")) {
			var form = attributes.color_depth;
			if(inputs[| 0].type == VALUE_TYPE.surface) 
				form--;
			if(form >= 0)
				return array_safe_get(global.SURFACE_FORMAT, form, surface_rgba8unorm);
		}
		
		var _s = inputs[| 0].getValue();
		while(is_array(_s) && array_length(_s)) _s = _s[0];
		if(!is_surface(_s)) 
			return surface_rgba8unorm;
		return surface_get_format(_s);
	} #endregion
}