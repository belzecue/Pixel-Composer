function Node_Fluid_Apply_Velocity(_x, _y, _group = noone) : Node_Fluid(_x, _y, _group) constructor {
	name  = "Apply Velocity";
	w = 96;
	min_h = 96;
	
	inputs[| 0] = nodeValue("Fluid Domain", self, JUNCTION_CONNECT.input, VALUE_TYPE.fdomain, noone)
		.setVisible(true, true);
	
	inputs[| 1] = nodeValue("Brush", self, JUNCTION_CONNECT.input, VALUE_TYPE.surface, noone);
	
	inputs[| 2] = nodeValue("Position", self, JUNCTION_CONNECT.input, VALUE_TYPE.float, [0, 0])
		.setDisplay(VALUE_DISPLAY.vector);
	
	inputs[| 3] = nodeValue("Velocity", self, JUNCTION_CONNECT.input, VALUE_TYPE.float, [0, 0])
		.setDisplay(VALUE_DISPLAY.vector);
	
	inputs[| 4] = nodeValue("Active", self, JUNCTION_CONNECT.input, VALUE_TYPE.boolean, true);
	
	input_display_list = [ 
		["Domain",		false], 0, 
		["Velocity",	false], 4, 1, 2, 3
	];
	
	outputs[| 0] = nodeValue("Fluid Domain", self, JUNCTION_CONNECT.output, VALUE_TYPE.fdomain, noone);
	
	static drawOverlay = function(active, _x, _y, _s, _mx, _my, _snx, _sny) {
		var _mat = inputs[| 1].getValue();
		var _pos = inputs[| 2].getValue();
		
		if(is_surface(_mat)) {
			var sw = surface_get_width(_mat) * _s;
			var sh = surface_get_height(_mat) * _s;
			var mx = _x + _pos[0] * _s - sw / 2;
			var my = _y + _pos[1] * _s - sh / 2;
			
			draw_surface_ext(_mat, mx, my, _s, _s, 0, c_white, 0.5);
		}
		
		inputs[| 2].drawOverlay(active, _x, _y, _s, _mx, _my, _snx, _sny);
	}
	
	static update = function(frame = ANIMATOR.current_frame) {
		var _dom = inputs[| 0].getValue(frame);
		var _mat = inputs[| 1].getValue(frame);
		var _pos = inputs[| 2].getValue(frame);
		var _vel = inputs[| 3].getValue(frame);
		var _act = inputs[| 4].getValue(frame);
		
		if(_dom == noone || !instance_exists(_dom)) return;
		outputs[| 0].setValue(_dom);
		
		if(!_act) return;
		if(!is_surface(_mat)) return;
		
		var sw = surface_get_width(_mat);
		var sh = surface_get_height(_mat);
		
        fd_rectangle_add_velocity_surface(_dom, _mat, _pos[0] - sw / 2, _pos[1] - sh / 2, 1, 1, _vel[0], _vel[1]);
	}
	
	static onDrawNode = function(xx, yy, _mx, _my, _s) {
		var bbox = drawGetBbox(xx, yy, _s);
		var _mat = inputs[| 1].getValue();
		if(!is_surface(_mat)) return;
		
		draw_surface_fit(_mat, bbox.xc, bbox.yc, bbox.w, bbox.h);
	}
}