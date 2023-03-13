function Node_Gradient_Out(_x, _y, _group = noone) : Node_Processor(_x, _y, _group) constructor {
	name		= "Gradient";
	previewable = false;
	
	w = 96;
	
	inputs[| 0] = nodeValue("Gradient", self, JUNCTION_CONNECT.input, VALUE_TYPE.color, new gradientObject(c_white) )
		.setDisplay(VALUE_DISPLAY.gradient);
	
	inputs[| 1] = nodeValue("Sample", self, JUNCTION_CONNECT.input, VALUE_TYPE.float, 0, "Position to sample a color from the gradient.")
		.setDisplay(VALUE_DISPLAY.slider, [0, 1, 0.01])
		.rejectArray();
	
	outputs[| 0] = nodeValue("Gradient", self, JUNCTION_CONNECT.output, VALUE_TYPE.color, new gradientObject(c_white) )
		.setDisplay(VALUE_DISPLAY.gradient);
	
	outputs[| 1] = nodeValue("Color", self, JUNCTION_CONNECT.output, VALUE_TYPE.color, c_white);
	
	_pal = -1;
	
	static process_data = function(_outSurf, _data, _output_index, _array_index) {
		var pal = _data[0];
		var pos = _data[1];
		
		//print("Gradient out " + string(pal))
		
		if(_output_index == 0) return pal;
		if(_output_index == 1) return pal.eval(pos);
		return 0;
	}
	
	static onDrawNode = function(xx, yy, _mx, _my, _s, _hover, _focus) {
		var bbox = drawGetBbox(xx, yy, _s);
		if(bbox.h < 1) return;
		
		var grad = getSingleValue(0);
		grad.draw(bbox.x0, bbox.y0, bbox.w, bbox.h);
	}
}