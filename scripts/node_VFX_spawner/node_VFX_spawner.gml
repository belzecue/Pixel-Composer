function Node_VFX_Spawner(_x, _y, _group = noone) : Node_VFX_Spawner_Base(_x, _y, _group) constructor {
	name = "Spawner";
	color = COLORS.node_blend_vfx;
	icon  = THEME.vfx;
	
	attributes[? "Output pool"] = false;
	
	inputs[| input_len + 0] = nodeValue("Spawn trigger", self, JUNCTION_CONNECT.input, VALUE_TYPE.node, false)
		.setVisible(true, true);
	
	inputs[| input_len + 1] = nodeValue("Step interval", self, JUNCTION_CONNECT.input, VALUE_TYPE.integer, 1, "How often the 'on step' event is triggered.\nWith 1 being trigger every frame, 2 means triggered once every 2 frames.");
	
	outputs[| 0] = nodeValue("Particles", self, JUNCTION_CONNECT.output, VALUE_TYPE.particle, [] );
	outputs[| 1] = nodeValue("On create", self, JUNCTION_CONNECT.output, VALUE_TYPE.node, noone );
	outputs[| 2] = nodeValue("On step", self, JUNCTION_CONNECT.output, VALUE_TYPE.node, noone );
	outputs[| 3] = nodeValue("On destroy", self, JUNCTION_CONNECT.output, VALUE_TYPE.node, noone );
	
	array_insert(input_display_list, 0, ["Trigger", true], input_len + 0, input_len + 1);
	
	static updateParticleForward = function(_render = true) {
		var pt = outputs[| 0];
		for( var i = 0; i < ds_list_size(pt.value_to); i++ ) {
			var _n = pt.value_to[| i];
			if(_n.value_from != pt) continue;
			
			if(variable_struct_exists(_n.node, "updateParticleForward"))
				_n.node.updateParticleForward();
		}
	}
	
	static onUpdate = function() {
		RETURN_ON_REST
		
		if(ANIMATOR.current_frame == 0)
			reset();
		runVFX(ANIMATOR.current_frame);
		
		if(attributes[? "Output pool"]) {
			outputs[| 0].setValue(parts);
			return;
		} else {
			var _parts = [];
			for( var i = 0; i < array_length(parts); i++ ) {
				if(!parts[i].active) continue;
				array_push(_parts, parts[i]);
			}
			outputs[| 0].setValue(_parts);
		}
	}
	
	static onSpawn = function(_time, part) {
		part.step_int = inputs[| input_len + 1].getValue(_time);
	}
	
	static onPartCreate = function(part) {  
		var vt = outputs[| 1];
		if(ds_list_empty(vt.value_to)) return;
		
		var pv = part.getPivot();
		for( var i = 0; i < ds_list_size(inputs); i++ )
			current_data[i] = inputs[| i].getValue();
		
		for( var i = 0; i < ds_list_size(vt.value_to); i++ ) {
			var _n = vt.value_to[| i];
			if(_n.value_from != vt) continue;
			_n.node.spawn(, pv);
		}
	}
	
	static onPartStep = function(part) {
		var vt = outputs[| 2];
		if(ds_list_empty(vt.value_to)) return;
		
		var pv = part.getPivot();
		for( var i = 0; i < ds_list_size(inputs); i++ )
			current_data[i] = inputs[| i].getValue();
			
		for( var i = 0; i < ds_list_size(vt.value_to); i++ ) {
			var _n = vt.value_to[| i];
			if(_n.value_from != vt) continue;
			_n.node.spawn(, pv);
		}
	}
	
	static onPartDestroy = function(part) {
		var vt = outputs[| 3];
		if(ds_list_empty(vt.value_to)) return;
		
		var pv = part.getPivot();
		for( var i = 0; i < ds_list_size(inputs); i++ )
			current_data[i] = inputs[| i].getValue();
			
		for( var i = 0; i < ds_list_size(vt.value_to); i++ ) {
			var _n = vt.value_to[| i];
			if(_n.value_from != vt) continue;
			_n.node.spawn(, pv);
		}
	}
	
	static onDrawNode = function(xx, yy, _mx, _my, _s, _hover, _focus) {
		var spr = inputs[| 0].getValue();
		
		if(spr == 0) {
			if(!is_surface(def_surface)) 
				return;
			spr = def_surface;	
		}
		
		if(is_array(spr))
			spr = spr[safe_mod(round(current_time / 100), array_length(spr))];
		
		var cx = xx + w * _s / 2;
		var cy = yy + h * _s / 2;
		var ss = min((w - 8) / surface_get_width(spr), (h - 8) / surface_get_height(spr)) * _s;
		draw_surface_align(spr, cx, cy, ss, fa_center, fa_center);
	}
}