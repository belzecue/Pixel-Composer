function Node_Path_Trim(_x, _y, _group = noone) : Node(_x, _y, _group) constructor {
	name		= "Trim Path";
	previewable = false;
	
	w = 96;
	
	inputs[| 0] = nodeValue("Path", self, JUNCTION_CONNECT.input, VALUE_TYPE.pathnode, noone)
		.setVisible(true, true);
	
	inputs[| 1] = nodeValue("Range", self, JUNCTION_CONNECT.input, VALUE_TYPE.float, [ 0, 1 ])
		.setDisplay(VALUE_DISPLAY.slider_range, [ 0, 1, 0.01 ]);
	
	outputs[| 0] = nodeValue("Path", self, JUNCTION_CONNECT.output, VALUE_TYPE.pathnode, self);
	
	static getLineCount = function() { 
		var _path = inputs[| 0].getValue();
		return struct_has(_path, "getLineCount")? _path.getLineCount() : 1; 
	}
	
	static getSegmentCount = function() { 
		var _path = inputs[| 0].getValue();
		return struct_has(_path, "getSegmentCount")? _path.getSegmentCount() : 0; 
	}
	
	static getLength = function() { 
		var _path = inputs[| 0].getValue();
		return struct_has(_path, "getLength")? _path.getLength() : 0; 
	}
	
	static getSegmentLength = function() { 
		var _path = inputs[| 0].getValue();
		return struct_has(_path, "getSegmentLength")? _path.getSegmentLength() : [];
	}
	
	static getAccuLength = function() { 
		var _path = inputs[| 0].getValue();
		return struct_has(_path, "getAccuLength")? _path.getAccuLength() : []; 
	}
	
	static getBoundary = function() { 
		var _path = inputs[| 0].getValue();
		return struct_has(_path, "getBoundary")? _path.getBoundary() : new BoundingBox( 0, 0, 1, 1 ); 
	}
		
	static getPointRatio = function(_rat, ind = 0) {
		var _path = inputs[| 0].getValue();
		var _rng  = inputs[| 1].getValue();
		
		if(is_array(_path)) {
			_path = array_safe_get(_path, ind);
			ind = 0;
		}
		
		if(!is_struct(_path) || !struct_has(_path, "getPointRatio"))
			return new Point();
		
		_rat = _rng[0] + _rat * (_rng[1] - _rng[0]);
		return _path.getPointRatio(_rat, ind).clone();
	}
	
	static getPointDistance = function(_dist, ind = 0) {
		return getPointRatio(_dist / getLength(), ind);
	}
	
	function update() { 
		outputs[| 0].setValue(self);
	}
	
	static onDrawNode = function(xx, yy, _mx, _my, _s, _hover, _focus) {
		var bbox = drawGetBbox(xx, yy, _s);
		draw_sprite_fit(s_node_path_trim, 0, bbox.xc, bbox.yc, bbox.w, bbox.h);
	}
}