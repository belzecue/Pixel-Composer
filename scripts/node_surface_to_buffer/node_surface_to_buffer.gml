function Node_Surface_To_Buffer(_x, _y, _group = noone) : Node_Processor(_x, _y, _group) constructor {
	name	= "Buffer from Surface";
	
	inputs[| 0] = nodeValue("Surface", self, JUNCTION_CONNECT.input, VALUE_TYPE.surface, noone);
	
	outputs[| 0] = nodeValue("Buffer", self, JUNCTION_CONNECT.output, VALUE_TYPE.buffer, noone);
	
	static process_data = function(_outSurf, _data, _output_index, _array_index) {
		var _surf = _data[0];
		return buffer_from_surface(_surf);
	}
}